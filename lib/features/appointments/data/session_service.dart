import '../../../core/storage/local_db.dart';
import '../../../core/storage/local_db_instance.dart';
import '../../../core/network/sync_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionService {
  final LocalDbService _db = appLocalDb;
  late final SyncManager _sync = SyncManager(_db);
  static const Uuid _uuid = Uuid();
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> upsertSession({
    required String appointmentId,
    bool? attendance,
    String? notes,
  }) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await _db.queryWhere(
      'sessions',
      where: 'appointment_id = ?',
      whereArgs: [appointmentId],
      limit: 1,
    );

    final existingId = existing.isEmpty
        ? null
        : (existing.first['id'] as String?);
    final id = (existingId == null || existingId.isEmpty)
        ? _uuid.v4()
        : existingId;

    final row = <String, dynamic>{
      'id': id,
      'appointment_id': appointmentId,
      'attendance': attendance == null ? null : (attendance ? 1 : 0),
      'notes': notes,
      'updated_at': now,
      'created_at': existing.isEmpty ? now : null,
    }..removeWhere((key, value) => value == null);

    await _db.insert('sessions', row);

    await _sync.enqueue(
      table: 'sessions',
      operation: existing.isEmpty ? 'insert' : 'update',
      recordId: id,
      payload: {
        'id': id,
        'appointment_id': appointmentId,
        'attendance': attendance,
        'notes': notes,
        'updated_at': DateTime.fromMillisecondsSinceEpoch(
          now,
        ).toUtc().toIso8601String(),
        'created_at': existing.isEmpty
            ? DateTime.fromMillisecondsSinceEpoch(now).toUtc().toIso8601String()
            : null,
      }..removeWhere((key, value) => value == null),
    );

    await _updatePatientStatusAfterAttendance(
      appointmentId: appointmentId,
      attendance: attendance,
      now: now,
    );
  }

  Future<void> audit({
    required String appointmentId,
    required String action,
    String? details,
  }) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    await _db.insert('session_audit', {
      'id': id,
      'session_id': null,
      'appointment_id': appointmentId,
      'action': action,
      'details': details,
      'created_at': now,
    });

    await _sync.enqueue(
      table: 'session_audit',
      operation: 'insert',
      recordId: id,
      payload: {
        'id': id,
        'session_id': null,
        'appointment_id': appointmentId,
        'action': action,
        'details': details,
        'created_at': DateTime.fromMillisecondsSinceEpoch(
          now,
        ).toUtc().toIso8601String(),
      },
    );
  }

  Future<void> _updatePatientStatusAfterAttendance({
    required String appointmentId,
    required bool? attendance,
    required int now,
  }) async {
    if (attendance != true) return;

    final appointmentRows = await _db.queryWhere(
      'appointments',
      where: 'id = ?',
      whereArgs: [appointmentId],
      limit: 1,
    );
    if (appointmentRows.isEmpty) return;
    final patientId = (appointmentRows.first['patient_id'] ?? '').toString();
    if (patientId.isEmpty) return;

    final patientRows = await _db.queryWhere(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
      limit: 1,
    );
    if (patientRows.isEmpty) return;

    final patient = patientRows.first;
    final currentStatus = (patient['status'] ?? 'not_started').toString();
    final suggestedSessions = patient['suggested_sessions'] as int?;
    final completedAppointments = await _db.queryWhere(
      'appointments',
      where: 'patient_id = ? AND status = ?',
      whereArgs: [patientId, 'completed'],
    );
    final completedCount = completedAppointments.length;

    String nextStatus = currentStatus;
    if ((suggestedSessions ?? 0) > 0 && completedCount >= suggestedSessions!) {
      nextStatus = 'completed';
    } else if (completedCount > 0 && currentStatus == 'not_started') {
      nextStatus = 'active';
    }

    if (nextStatus == currentStatus) return;

    await _db.update('patients', {
      'status': nextStatus,
      'updated_at': now,
    }, 'id = ?', [patientId]);

    final payload = {
      'status': nextStatus,
      'updated_at': DateTime.fromMillisecondsSinceEpoch(
        now,
      ).toUtc().toIso8601String(),
    };

    try {
      await _client.from('patients').update(payload).eq('id', patientId);
    } catch (_) {
      await _sync.enqueue(
        table: 'patients',
        operation: 'update',
        recordId: patientId,
        payload: payload,
      );
    }
  }
}
