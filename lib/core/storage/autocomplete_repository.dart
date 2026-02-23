import '../../../core/storage/local_db.dart';
import '../../../core/network/sync_manager.dart';

abstract class AutocompleteRepository {
  Future<List<String>> search(String type, String query);
  Future<void> record(String type, String value);
}

class SqliteAutocompleteRepository implements AutocompleteRepository {
  final LocalDbService db;
  final SyncManager _sync;

  SqliteAutocompleteRepository(this.db) : _sync = SyncManager(db);

  @override
  Future<List<String>> search(String type, String query) async {
    await db.init();
    final rows = await db.queryWhere(
      'autocomplete_values',
      where: 'type = ? AND value LIKE ?',
      whereArgs: [type, '%$query%'],
      orderBy: 'use_count DESC, last_used_at DESC',
      limit: 10,
    );
    return rows.map((r) => r['value'] as String).toList();
  }

  @override
  Future<void> record(String type, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    await db.init();
    final existing = await db.queryWhere(
      'autocomplete_values',
      where: 'type = ? AND value = ?',
      whereArgs: [type, trimmed],
      limit: 1,
    );
    final now = DateTime.now().millisecondsSinceEpoch;
    if (existing.isEmpty) {
      final id = '${type}_$trimmed';
      await db.insert('autocomplete_values', {
        'id': id,
        'type': type,
        'value': trimmed,
        'use_count': 1,
        'last_used_at': now,
      });
      await _sync.enqueue(
        table: 'autocomplete_values',
        operation: 'upsert',
        recordId: id,
        payload: {
          'id': id,
          'type': type,
          'value': trimmed,
          'use_count': 1,
          'last_used_at': DateTime.fromMillisecondsSinceEpoch(
            now,
          ).toUtc().toIso8601String(),
        },
      );
    } else {
      final row = existing.first;
      final count = (row['use_count'] as int? ?? 0) + 1;
      await db.update(
        'autocomplete_values',
        {'use_count': count, 'last_used_at': now},
        'id = ?',
        [row['id']],
      );
      await _sync.enqueue(
        table: 'autocomplete_values',
        operation: 'upsert',
        recordId: row['id'] as String,
        payload: {
          'id': row['id'] as String,
          'type': type,
          'value': trimmed,
          'use_count': count,
          'last_used_at': DateTime.fromMillisecondsSinceEpoch(
            now,
          ).toUtc().toIso8601String(),
        },
      );
    }
  }
}
