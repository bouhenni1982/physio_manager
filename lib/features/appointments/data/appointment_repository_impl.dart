import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/sync_manager.dart';
import '../../../core/storage/local_db.dart';
import '../../../core/storage/sqlite_local_db.dart';
import '../domain/appointment.dart';
import 'appointment_repository.dart';

class SupabaseAppointmentRepository implements AppointmentRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final LocalDbService _db = SqliteLocalDb();
  late final SyncManager _sync = SyncManager(_db);

  @override
  Future<List<Appointment>> getForDay(DateTime day) async {
    await _db.init();
    final isAdmin = await _isCurrentUserAdmin();
    final therapistId = isAdmin ? null : await _currentTherapistId();
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
    final local = isAdmin
        ? await _db.queryWhere(
            'appointments',
            where: 'scheduled_at >= ? AND scheduled_at <= ?',
            whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
          )
        : await _db.queryWhere(
            'appointments',
            where: 'scheduled_at >= ? AND scheduled_at <= ? AND therapist_id = ?',
            whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch, therapistId ?? ''],
          );
    if (local.isNotEmpty) {
      return local.map(_fromRowLocal).toList();
    }

    try {
      var req = _client
          .from('appointments')
          .select()
          .gte('scheduled_at', start.toUtc().toIso8601String())
          .lte('scheduled_at', end.toUtc().toIso8601String());
      if (!isAdmin && therapistId != null) {
        req = req.eq('therapist_id', therapistId);
      }
      final rows = await req;
      for (final r in (rows as List<dynamic>)) {
        final data = r as Map<String, dynamic>;
        await _db.insert('appointments', _toLocal(data));
      }
      return (rows as List<dynamic>).map(_fromRow).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Appointment> create(Appointment appointment) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.insert('appointments', _toLocal(_toRow(appointment), nowMs: now));
    try {
      final row = _toRow(appointment, nowMs: now);
      final res = await _client.from('appointments').insert(row).select().single();
      return _fromRow(res);
    } catch (_) {
      await _sync.enqueue(
        table: 'appointments',
        operation: 'insert',
        recordId: appointment.id,
        payload: _toRow(appointment, nowMs: now),
      );
      return appointment;
    }
  }

  @override
  Future<void> update(Appointment appointment) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.update('appointments', _toLocal(_toRow(appointment), nowMs: now), 'id = ?', [appointment.id]);
    try {
      final row = _toRow(appointment, nowMs: now);
      await _client.from('appointments').update(row).eq('id', appointment.id);
    } catch (_) {
      await _sync.enqueue(
        table: 'appointments',
        operation: 'update',
        recordId: appointment.id,
        payload: _toRow(appointment, nowMs: now),
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    await _db.init();
    await _db.delete('appointments', 'id = ?', [id]);
    try {
      await _client.from('appointments').delete().eq('id', id);
    } catch (_) {
      await _sync.enqueue(
        table: 'appointments',
        operation: 'delete',
        recordId: id,
      );
    }
  }

  Appointment _fromRow(dynamic row) {
    final data = row as Map<String, dynamic>;
    final scheduledAt = data['scheduled_at'] as String?;
    return Appointment(
      id: data['id'] as String,
      patientId: (data['patient_id'] as String?) ?? '',
      therapistId: (data['therapist_id'] as String?) ?? '',
      scheduledAt: scheduledAt == null ? DateTime.now() : DateTime.parse(scheduledAt),
      status: (data['status'] as String?) ?? 'scheduled',
    );
  }

  Appointment _fromRowLocal(Map<String, dynamic> data) {
    return Appointment(
      id: data['id'] as String,
      patientId: (data['patient_id'] as String?) ?? '',
      therapistId: (data['therapist_id'] as String?) ?? '',
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(data['scheduled_at'] as int? ?? 0),
      status: (data['status'] as String?) ?? 'scheduled',
    );
  }

  Map<String, dynamic> _toRow(Appointment appointment, {int? nowMs}) {
    return {
      'id': appointment.id,
      'patient_id': appointment.patientId,
      'therapist_id': appointment.therapistId,
      'scheduled_at': appointment.scheduledAt.toUtc().toIso8601String(),
      'status': appointment.status,
      if (nowMs != null) 'updated_at': DateTime.fromMillisecondsSinceEpoch(nowMs).toUtc().toIso8601String(),
      if (nowMs != null) 'created_at': DateTime.fromMillisecondsSinceEpoch(nowMs).toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _toLocal(Map<String, dynamic> row, {int? nowMs}) {
    final data = Map<String, dynamic>.from(row);
    final updated = row['updated_at'];
    final created = row['created_at'];
    if (updated is String) {
      data['updated_at'] = DateTime.parse(updated).millisecondsSinceEpoch;
    } else if (nowMs != null) {
      data['updated_at'] = nowMs;
    }
    if (created is String) {
      data['created_at'] = DateTime.parse(created).millisecondsSinceEpoch;
    } else if (nowMs != null) {
      data['created_at'] = nowMs;
    }
    if (data['scheduled_at'] is String) {
      data['scheduled_at'] = DateTime.parse(data['scheduled_at'] as String).millisecondsSinceEpoch;
    }
    return data;
  }

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return false;
    try {
      final row = await _client
          .from('therapists')
          .select('is_primary')
          .eq('user_id', uid)
          .maybeSingle();
      return row?['is_primary'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _currentTherapistId() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;
    try {
      final row = await _client
          .from('therapists')
          .select('id')
          .eq('user_id', uid)
          .maybeSingle();
      return row?['id'] as String?;
    } catch (_) {
      return null;
    }
  }
}
