import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_db.dart';
import 'sqlite_local_db.dart';

final localDbProvider = Provider<LocalDbService>((ref) {
  return SqliteLocalDb();
});
