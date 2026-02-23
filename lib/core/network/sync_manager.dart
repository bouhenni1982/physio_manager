import 'dart:async';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../storage/local_db.dart';
import '../notifications/notification_scheduler.dart';
import '../debug/network_error.dart';

class SyncManager {
  final LocalDbService db;
  final SupabaseClient _client = Supabase.instance.client;
  Timer? _timer;

  SyncManager(this.db);

  Future<void> syncAll() async {
    await db.init();
    await _pushQueue();
    await _pullUpdates();
    await NotificationScheduler.instance.showSyncComplete();
  }

  Future<void> enqueue({
    required String table,
    required String operation,
    required String recordId,
    Map<String, dynamic>? payload,
  }) async {
    await db.insert('sync_queue', {
      'id': '${DateTime.now().microsecondsSinceEpoch}_$recordId',
      'table_name': table,
      'operation': operation,
      'record_id': recordId,
      'payload': payload == null ? null : jsonEncode(payload),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> _pushQueue() async {
    final rows = await db.queryWhere('sync_queue', orderBy: 'created_at ASC');
    for (final row in rows) {
      final table = row['table_name'] as String;
      final operation = row['operation'] as String;
      final recordId = row['record_id'] as String;
      final payloadJson = row['payload'] as String?;
      final payload = payloadJson == null
          ? null
          : jsonDecode(payloadJson) as Map<String, dynamic>;

      try {
        if (operation == 'insert') {
          var insertPayload = payload ?? {};
          try {
            await _client
                .from(table)
                .insert(insertPayload)
                .select()
                .maybeSingle();
          } on PostgrestException catch (e) {
            if (table == 'patients' &&
                (e.code == '42703' || e.message.contains('column')) &&
                insertPayload.containsKey('phone')) {
              insertPayload = Map<String, dynamic>.from(insertPayload)
                ..remove('phone');
              await _client
                  .from(table)
                  .insert(insertPayload)
                  .select()
                  .maybeSingle();
            } else {
              rethrow;
            }
          }
        } else if (operation == 'update') {
          var updatePayload = payload ?? {};
          try {
            await _client.from(table).update(updatePayload).eq('id', recordId);
          } on PostgrestException catch (e) {
            if (table == 'patients' &&
                (e.code == '42703' || e.message.contains('column')) &&
                updatePayload.containsKey('phone')) {
              updatePayload = Map<String, dynamic>.from(updatePayload)
                ..remove('phone');
              await _client.from(table).update(updatePayload).eq('id', recordId);
            } else {
              rethrow;
            }
          }
        } else if (operation == 'delete') {
          await _client.from(table).delete().eq('id', recordId);
        } else if (operation == 'upsert') {
          await _client.from(table).upsert(payload ?? {});
        }
        await db.delete('sync_queue', 'id = ?', [row['id']]);
      } catch (_) {
        // leave in queue for retry
      }
    }
  }

  Future<void> _pullUpdates() async {
    final lastSync = await _getLastSync();
    final lastSyncIso = DateTime.fromMillisecondsSinceEpoch(
      lastSync,
    ).toUtc().toIso8601String();

    await _pullTable('therapists', lastSyncIso);
    await _pullTable('patients', lastSyncIso);
    await _pullTable('appointments', lastSyncIso);
    await _pullTable('sessions', lastSyncIso);
    await _pullTable(
      'session_audit',
      lastSyncIso,
      timestampColumn: 'created_at',
    );
    await _pullTable(
      'autocomplete_values',
      lastSyncIso,
      timestampColumn: 'last_used_at',
    );
    await _pullTable(
      'patient_audit',
      lastSyncIso,
      timestampColumn: 'created_at',
    );

    await _setLastSync(DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _pullTable(
    String table,
    String sinceIso, {
    String timestampColumn = 'updated_at',
  }) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .gte(timestampColumn, sinceIso);
      for (final row in (rows as List<dynamic>)) {
        final data = _normalizeRow(row as Map<String, dynamic>);
        if (table == 'patients') {
          await _preserveLocalPatientImagePath(data);
        }
        await db.insert(table, data);
        if (table == 'appointments') {
          await NotificationScheduler.instance.scheduleForAppointmentRow(data);
        }
      }
    } catch (e) {
      // Network failures should bubble up so coordinator can retry/backoff.
      if (isNetworkError(e)) rethrow;
      // Non-network issues (schema/RLS/temporary backend constraints) should not block offline UX.
    }
  }

  Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row);
    for (final entry in row.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.endsWith('_at') && value is String) {
        data[key] = DateTime.parse(value).millisecondsSinceEpoch;
      }
      if (key == 'details' && (value is Map || value is List)) {
        data[key] = jsonEncode(value);
      }
    }
    if (data['is_primary'] is bool) {
      data['is_primary'] = (data['is_primary'] as bool) ? 1 : 0;
    }
    return data;
  }

  Future<void> _preserveLocalPatientImagePath(Map<String, dynamic> data) async {
    if (data.containsKey('prescription_image_path')) return;
    final id = data['id'] as String?;
    if (id == null || id.isEmpty) return;
    final local = await db.queryWhere(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (local.isEmpty) return;
    final path = local.first['prescription_image_path'];
    if (path != null) {
      data['prescription_image_path'] = path;
    }
  }

  void startPeriodic({Duration interval = const Duration(minutes: 5)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      syncAll();
    });
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<int> _getLastSync() async {
    final rows = await db.queryWhere(
      'sync_meta',
      where: 'id = ?',
      whereArgs: ['main'],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return (rows.first['last_sync'] as int?) ?? 0;
  }

  Future<int> getLastSyncMs() async {
    return _getLastSync();
  }

  Future<void> _setLastSync(int ms) async {
    await db.insert('sync_meta', {'id': 'main', 'last_sync': ms});
  }
}
