import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'db_schema.dart';
import 'local_db.dart';

class SqliteLocalDb implements LocalDbService {
  Database? _db;

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final base = await getDatabasesPath();
    final path = p.join(base, 'physio_manager.db');
    _db = await openDatabase(
      path,
      version: 7,
      onCreate: (db, _) => DbSchema.create(db),
      onUpgrade: (db, oldVersion, newVersion) =>
          DbSchema.migrate(db, oldVersion, newVersion),
    );
    return _db!;
  }

  @override
  Future<void> init() async {
    await _open();
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _open();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await _open();
    return db.query(table);
  }

  @override
  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await _open();
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List<Object?> args,
  ) async {
    final db = await _open();
    return db.update(table, data, where: where, whereArgs: args);
  }

  @override
  Future<int> delete(String table, String where, List<Object?> args) async {
    final db = await _open();
    return db.delete(table, where: where, whereArgs: args);
  }
}
