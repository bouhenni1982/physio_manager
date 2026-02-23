import 'local_db.dart';

class InMemoryLocalDb implements LocalDbService {
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  bool _initialized = false;

  @override
  Future<void> init() async {
    _initialized = true;
  }

  List<Map<String, dynamic>> _table(String name) =>
      _tables.putIfAbsent(name, () => <Map<String, dynamic>>[]);

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    if (!_initialized) await init();
    final rows = _table(table);
    final id = data['id'];
    if (id != null) {
      rows.removeWhere((row) => row['id'] == id);
    }
    rows.add(Map<String, dynamic>.from(data));
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table) async {
    if (!_initialized) await init();
    return _table(table).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    if (!_initialized) await init();
    final out = _table(table)
        .where((row) => _matchesWhere(row, where, whereArgs))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (orderBy != null && orderBy.trim().isNotEmpty) {
      final parts = orderBy.trim().split(RegExp(r'\s+'));
      final col = parts.first;
      final desc = parts.length > 1 && parts[1].toUpperCase() == 'DESC';
      out.sort((a, b) {
        final av = a[col];
        final bv = b[col];
        final cmp = _compareDynamic(av, bv);
        return desc ? -cmp : cmp;
      });
    }

    if (limit != null && out.length > limit) {
      return out.sublist(0, limit);
    }
    return out;
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List<Object?> args,
  ) async {
    if (!_initialized) await init();
    final rows = _table(table);
    var count = 0;
    for (final row in rows) {
      if (_matchesWhere(row, where, args)) {
        row.addAll(data);
        count++;
      }
    }
    return count;
  }

  @override
  Future<int> delete(String table, String where, List<Object?> args) async {
    if (!_initialized) await init();
    final rows = _table(table);
    if (where.trim() == '1 = 1') {
      final count = rows.length;
      rows.clear();
      return count;
    }
    final before = rows.length;
    rows.removeWhere((row) => _matchesWhere(row, where, args));
    return before - rows.length;
  }

  bool _matchesWhere(
    Map<String, dynamic> row,
    String? where,
    List<Object?>? whereArgs,
  ) {
    if (where == null || where.trim().isEmpty) return true;
    final expr = where.trim();
    if (expr == '1 = 1') return true;
    final parts = expr.split(' AND ');
    var argIndex = 0;
    for (final rawPart in parts) {
      final part = rawPart.trim();
      if (part.contains('>= ?')) {
        final col = part.replaceAll('>= ?', '').trim();
        final arg = whereArgs![argIndex++];
        if (_compareDynamic(row[col], arg) < 0) return false;
      } else if (part.contains('<= ?')) {
        final col = part.replaceAll('<= ?', '').trim();
        final arg = whereArgs![argIndex++];
        if (_compareDynamic(row[col], arg) > 0) return false;
      } else if (part.contains('= ?')) {
        final col = part.replaceAll('= ?', '').trim();
        final arg = whereArgs![argIndex++];
        if (row[col] != arg) return false;
      } else {
        return false;
      }
    }
    return true;
  }

  int _compareDynamic(dynamic a, dynamic b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    if (a is num && b is num) return a.compareTo(b);
    return a.toString().compareTo(b.toString());
  }
}
