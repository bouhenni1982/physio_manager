import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_db.dart';
import 'local_db_instance.dart';

final localDbProvider = Provider<LocalDbService>((ref) {
  return appLocalDb;
});
