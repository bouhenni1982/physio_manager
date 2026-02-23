import 'package:sqflite/sqflite.dart';

class DbSchema {
  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE therapists (
        id TEXT PRIMARY KEY,
        user_id TEXT UNIQUE NOT NULL,
        full_name TEXT NOT NULL,
        phone TEXT,
        is_primary INTEGER DEFAULT 0,
        work_days TEXT,
        work_hours TEXT,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        age INTEGER,
        gender TEXT,
        diagnosis TEXT,
        medical_history TEXT,
        suggested_sessions INTEGER,
        therapist_id TEXT,
        doctor_name TEXT,
        phone TEXT,
        prescription_image_path TEXT,
        status TEXT,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        patient_id TEXT,
        therapist_id TEXT,
        scheduled_at INTEGER,
        status TEXT,
        notes TEXT,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        appointment_id TEXT UNIQUE,
        attendance INTEGER,
        done_at INTEGER,
        notes TEXT,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE autocomplete_values (
        id TEXT PRIMARY KEY,
        type TEXT,
        value TEXT,
        use_count INTEGER DEFAULT 0,
        last_used_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        table_name TEXT NOT NULL,
        operation TEXT NOT NULL,
        record_id TEXT NOT NULL,
        payload TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_meta (
        id TEXT PRIMARY KEY,
        last_sync INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE notification_log (
        id TEXT PRIMARY KEY,
        title TEXT,
        body TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE session_audit (
        id TEXT PRIMARY KEY,
        session_id TEXT,
        appointment_id TEXT,
        action TEXT,
        details TEXT,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE patient_audit (
        id TEXT PRIMARY KEY,
        patient_id TEXT,
        action TEXT,
        changed_by TEXT,
        details TEXT,
        created_at INTEGER
      )
    ''');
  }

  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_queue (
          id TEXT PRIMARY KEY,
          table_name TEXT NOT NULL,
          operation TEXT NOT NULL,
          record_id TEXT NOT NULL,
          payload TEXT,
          created_at INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_meta (
          id TEXT PRIMARY KEY,
          last_sync INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notification_log (
          id TEXT PRIMARY KEY,
          title TEXT,
          body TEXT,
          created_at INTEGER
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS session_audit (
          id TEXT PRIMARY KEY,
          session_id TEXT,
          appointment_id TEXT,
          action TEXT,
          details TEXT,
          created_at INTEGER
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE patients ADD COLUMN medical_history TEXT');
      await db.execute(
        'ALTER TABLE patients ADD COLUMN prescription_image_path TEXT',
      );
    }
    if (oldVersion < 5) {
      await db.execute(
        "ALTER TABLE patients ADD COLUMN status TEXT DEFAULT 'active'",
      );
    }
    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS patient_audit (
          id TEXT PRIMARY KEY,
          patient_id TEXT,
          action TEXT,
          changed_by TEXT,
          details TEXT,
          created_at INTEGER
        )
      ''');
    }
    if (oldVersion < 7) {
      await db.execute('ALTER TABLE patients ADD COLUMN phone TEXT');
    }
  }
}
