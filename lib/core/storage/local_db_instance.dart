import 'package:flutter/foundation.dart';
import 'in_memory_local_db.dart';
import 'local_db.dart';
import 'sqlite_local_db.dart';

final LocalDbService appLocalDb = kIsWeb ? InMemoryLocalDb() : SqliteLocalDb();
