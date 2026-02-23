import '../../../core/storage/local_db.dart';
import '../../../core/storage/local_db_instance.dart';
import '../../../core/network/sync_manager.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  final LocalDbService _db = appLocalDb;
  late final SyncManager _sync = SyncManager(_db);
  static const Uuid _uuid = Uuid();

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
}
