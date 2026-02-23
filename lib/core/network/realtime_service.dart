import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../storage/local_db.dart';
import '../notifications/notification_scheduler.dart';

class RealtimeService {
  final LocalDbService db;
  final SupabaseClient _client = Supabase.instance.client;
  final List<StreamSubscription<List<Map<String, dynamic>>>> _subs = [];
  RealtimeChannel? _appointmentsChannel;

  RealtimeService(this.db);

  Future<void> start() async {
    await db.init();
    _subscribe('therapists');
    _subscribe('patients');
    _subscribeAppointments();
  }

  void _subscribe(String table) {
    final sub = _client
        .from(table)
        .stream(primaryKey: ['id'])
        .listen((rows) async {
      for (final row in rows) {
        final data = _normalizeRow(row);
        await db.insert(table, data);
        if (table == 'appointments') {
          await NotificationScheduler.instance.scheduleForAppointmentRow(data);
        }
      }
    });
    _subs.add(sub);
  }

  void _subscribeAppointments() {
    // stream for inserts/updates
    final sub = _client
        .from('appointments')
        .stream(primaryKey: ['id'])
        .listen((rows) async {
      for (final row in rows) {
        final data = _normalizeRow(row);
        await db.insert('appointments', data);
        await NotificationScheduler.instance.scheduleForAppointmentRow(data);
      }
    });
    _subs.add(sub);

    // channel for deletes
    _appointmentsChannel = _client
        .channel('public:appointments')
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'appointments',
          callback: (payload) async {
            final id = payload.oldRecord['id'] as String?;
            if (id == null) return;
            await db.delete('appointments', 'id = ?', [id]);
            await NotificationScheduler.instance.cancelById(id);
          },
        )
        .subscribe();
  }

  Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row);
    for (final entry in row.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.endsWith('_at') && value is String) {
        data[key] = DateTime.parse(value).millisecondsSinceEpoch;
      }
    }
    if (data['is_primary'] is bool) {
      data['is_primary'] = (data['is_primary'] as bool) ? 1 : 0;
    }
    return data;
  }

  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
    _appointmentsChannel?.unsubscribe();
    _appointmentsChannel = null;
  }
}
