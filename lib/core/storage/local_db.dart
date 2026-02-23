abstract class LocalDbService {
  Future<void> init();
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> query(String table);
  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  });
  Future<int> update(String table, Map<String, dynamic> data, String where, List<Object?> args);
  Future<int> delete(String table, String where, List<Object?> args);
}
