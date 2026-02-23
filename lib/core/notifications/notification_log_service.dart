import '../storage/local_db.dart';
import '../storage/sqlite_local_db.dart';

class NotificationLogService {
  final LocalDbService _db = SqliteLocalDb();

  Future<void> log(String title, String body) async {
    await _db.init();
    await _db.insert('notification_log', {
      'id': '${DateTime.now().microsecondsSinceEpoch}',
      'title': title,
      'body': body,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> list() async {
    await _db.init();
    return _db.queryWhere('notification_log', orderBy: 'created_at DESC');
  }

  Future<void> clearAll() async {
    await _db.init();
    await _db.delete('notification_log', '1 = 1', []);
  }
}
