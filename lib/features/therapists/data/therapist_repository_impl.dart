import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/sync_manager.dart';
import '../../../core/storage/local_db.dart';
import '../../../core/storage/sqlite_local_db.dart';
import '../domain/therapist.dart';
import 'therapist_repository.dart';

class SupabaseTherapistRepository implements TherapistRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final LocalDbService _db = SqliteLocalDb();
  late final SyncManager _sync = SyncManager(_db);

  @override
  Future<List<Therapist>> getAll() async {
    await _db.init();
    final local = await _db.query('therapists');
    if (local.isNotEmpty) {
      return local.map(_fromRowLocal).toList();
    }
    try {
      final rows = await _client.from('therapists').select();
      for (final r in (rows as List<dynamic>)) {
        final data = r as Map<String, dynamic>;
        await _db.insert('therapists', _toLocal(data));
      }
      return (rows as List<dynamic>).map(_fromRow).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Therapist> create(Therapist therapist) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final insertRow = _toRow(therapist, nowMs: now, forcePrimary: false);
    await _db.insert('therapists', _toLocal(insertRow, nowMs: now));
    try {
      final row = insertRow;
      final res = await _client.from('therapists').insert(row).select().single();
      return _fromRow(res);
    } catch (_) {
      await _sync.enqueue(
        table: 'therapists',
        operation: 'insert',
        recordId: therapist.id,
        payload: insertRow,
      );
      return Therapist(
        id: therapist.id,
        userId: therapist.userId,
        fullName: therapist.fullName,
        phone: therapist.phone,
        isPrimary: false,
      );
    }
  }

  @override
  Future<void> update(Therapist therapist) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final baseRow = _toRow(therapist, nowMs: now, includePrimary: false);
    await _db.update('therapists', _toLocal(baseRow, nowMs: now), 'id = ?', [therapist.id]);
    try {
      await _client.from('therapists').update(baseRow).eq('id', therapist.id);
    } catch (_) {
      await _sync.enqueue(
        table: 'therapists',
        operation: 'update',
        recordId: therapist.id,
        payload: baseRow,
      );
    }
  }

  @override
  Future<void> setAdmin(String therapistId, bool isAdmin) async {
    await _db.init();
    await _client.rpc(
      'set_therapist_admin',
      params: {
        'p_target_therapist_id': therapistId,
        'p_make_admin': isAdmin,
      },
    );
    await _db.update(
      'therapists',
      {'is_primary': isAdmin ? 1 : 0},
      'id = ?',
      [therapistId],
    );
  }

  @override
  Future<void> transferPrimary(String therapistId) async {
    // Backward compatibility: promote target to admin via new 2-admin API.
    await setAdmin(therapistId, true);
  }

  @override
  Future<void> delete(String id) async {
    await _db.init();
    await _db.delete('therapists', 'id = ?', [id]);
    try {
      await _client.from('therapists').delete().eq('id', id);
    } catch (_) {
      await _sync.enqueue(
        table: 'therapists',
        operation: 'delete',
        recordId: id,
      );
    }
  }

  Therapist _fromRow(dynamic row) {
    final data = row as Map<String, dynamic>;
    return Therapist(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      fullName: data['full_name'] as String,
      phone: data['phone'] as String?,
      isPrimary: data['is_primary'] == true,
    );
  }

  Therapist _fromRowLocal(Map<String, dynamic> data) {
    return Therapist(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      fullName: data['full_name'] as String,
      phone: data['phone'] as String?,
      isPrimary: (data['is_primary'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _toRow(
    Therapist therapist, {
    int? nowMs,
    bool includePrimary = true,
    bool? forcePrimary,
  }) {
    final row = <String, dynamic>{
      'id': therapist.id,
      'user_id': therapist.userId,
      'full_name': therapist.fullName,
      'phone': therapist.phone,
      if (nowMs != null) 'updated_at': DateTime.fromMillisecondsSinceEpoch(nowMs).toUtc().toIso8601String(),
      if (nowMs != null) 'created_at': DateTime.fromMillisecondsSinceEpoch(nowMs).toUtc().toIso8601String(),
    };
    if (includePrimary) {
      row['is_primary'] = forcePrimary ?? therapist.isPrimary;
    }
    return row;
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
    if (data['is_primary'] is bool) {
      data['is_primary'] = (data['is_primary'] as bool) ? 1 : 0;
    }
    return data;
  }
}
