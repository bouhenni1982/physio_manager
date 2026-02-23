import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../../../core/storage/local_db.dart';
import '../domain/patient.dart';
import '../../appointments/domain/appointment.dart';

class PatientTimelineEntry {
  final Appointment appointment;
  final bool? attendance;
  final DateTime? doneAt;
  final String? sessionNotes;
  final String therapistName;

  const PatientTimelineEntry({
    required this.appointment,
    required this.attendance,
    required this.doneAt,
    required this.sessionNotes,
    required this.therapistName,
  });
}

class PatientDetailsData {
  final Patient patient;
  final List<PatientTimelineEntry> upcoming;
  final List<PatientTimelineEntry> history;
  final List<PatientAuditEntry> audits;

  const PatientDetailsData({
    required this.patient,
    required this.upcoming,
    required this.history,
    required this.audits,
  });
}

class PatientAuditEntry {
  final String action;
  final String? changedBy;
  final DateTime createdAt;
  final Map<String, dynamic> details;

  const PatientAuditEntry({
    required this.action,
    required this.changedBy,
    required this.createdAt,
    required this.details,
  });
}

class PatientDetailsService {
  final LocalDbService db;
  final SupabaseClient _client = Supabase.instance.client;

  PatientDetailsService(this.db);

  Future<PatientDetailsData?> load(String patientId) async {
    await db.init();

    final patient = await _loadPatient(patientId);
    if (patient == null) return null;

    final therapistMap = await _loadTherapistNames();
    final appointments = await _loadAppointments(patientId);
    final entries = <PatientTimelineEntry>[];

    for (final a in appointments) {
      final session = await _loadSession(a.id);
      entries.add(
        PatientTimelineEntry(
          appointment: a,
          attendance: _readAttendance(session),
          doneAt: _readDoneAt(session),
          sessionNotes: session?['notes'] as String?,
          therapistName: therapistMap[a.therapistId] ?? '-',
        ),
      );
    }

    final now = DateTime.now();
    final upcoming =
        entries.where((e) {
          return e.appointment.scheduledAt.isAfter(now) &&
              e.appointment.status != 'canceled';
        }).toList()..sort(
          (a, b) =>
              a.appointment.scheduledAt.compareTo(b.appointment.scheduledAt),
        );

    final history =
        entries.where((e) {
          return !e.appointment.scheduledAt.isAfter(now) ||
              e.appointment.status != 'scheduled';
        }).toList()..sort(
          (a, b) =>
              b.appointment.scheduledAt.compareTo(a.appointment.scheduledAt),
        );

    final audits = await _loadPatientAudit(patientId);

    return PatientDetailsData(
      patient: patient,
      upcoming: upcoming,
      history: history,
      audits: audits,
    );
  }

  Future<Patient?> _loadPatient(String patientId) async {
    final local = await db.queryWhere(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
      limit: 1,
    );
    if (local.isNotEmpty) {
      return _patientFromLocal(local.first);
    }

    try {
      final remote = await _client
          .from('patients')
          .select()
          .eq('id', patientId)
          .maybeSingle();
      if (remote == null) return null;
      final row = _toLocalRow(Map<String, dynamic>.from(remote));
      await db.insert('patients', row);
      return _patientFromLocal(row);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, String>> _loadTherapistNames() async {
    final rows = await db.query('therapists');
    final map = <String, String>{};
    for (final row in rows) {
      final id = row['id'] as String?;
      final name = row['full_name'] as String?;
      if (id != null && name != null) {
        map[id] = name;
      }
    }
    return map;
  }

  Future<List<Appointment>> _loadAppointments(String patientId) async {
    final local = await db.queryWhere(
      'appointments',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'scheduled_at DESC',
    );
    if (local.isNotEmpty) {
      return local.map(_appointmentFromLocal).toList();
    }

    try {
      final rows = await _client
          .from('appointments')
          .select()
          .eq('patient_id', patientId)
          .order('scheduled_at', ascending: false);
      final out = <Appointment>[];
      for (final r in (rows as List<dynamic>)) {
        final remote = r as Map<String, dynamic>;
        final localRow = _toLocalRow(remote);
        await db.insert('appointments', localRow);
        out.add(_appointmentFromLocal(localRow));
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, dynamic>?> _loadSession(String appointmentId) async {
    final local = await db.queryWhere(
      'sessions',
      where: 'appointment_id = ?',
      whereArgs: [appointmentId],
      limit: 1,
    );
    if (local.isNotEmpty) return local.first;

    try {
      final remote = await _client
          .from('sessions')
          .select()
          .eq('appointment_id', appointmentId)
          .maybeSingle();
      if (remote == null) return null;
      final row = _toLocalRow(Map<String, dynamic>.from(remote));
      await db.insert('sessions', row);
      return row;
    } catch (_) {
      return null;
    }
  }

  Future<List<PatientAuditEntry>> _loadPatientAudit(String patientId) async {
    final rows = await db.queryWhere(
      'patient_audit',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
      limit: 50,
    );
    if (rows.isNotEmpty) {
      return rows.map(_auditFromLocal).toList();
    }
    try {
      final remote = await _client
          .from('patient_audit')
          .select()
          .eq('patient_id', patientId)
          .order('created_at', ascending: false)
          .limit(50);
      final out = <PatientAuditEntry>[];
      for (final item in (remote as List<dynamic>)) {
        final row = _toLocalRow(Map<String, dynamic>.from(item));
        await db.insert('patient_audit', row);
        out.add(_auditFromLocal(row));
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  Patient _patientFromLocal(Map<String, dynamic> data) {
    return Patient(
      id: data['id'] as String,
      fullName: data['full_name'] as String,
      age: data['age'] as int?,
      gender: (data['gender'] as String?) ?? 'unknown',
      diagnosis: data['diagnosis'] as String?,
      medicalHistory: data['medical_history'] as String?,
      suggestedSessions: data['suggested_sessions'] as int?,
      therapistId: (data['therapist_id'] as String?) ?? '',
      doctorName: data['doctor_name'] as String?,
      phone: data['phone'] as String?,
      prescriptionImagePath: data['prescription_image_path'] as String?,
      status: (data['status'] as String?) ?? 'active',
    );
  }

  Appointment _appointmentFromLocal(Map<String, dynamic> data) {
    return Appointment(
      id: data['id'] as String,
      patientId: (data['patient_id'] as String?) ?? '',
      therapistId: (data['therapist_id'] as String?) ?? '',
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(
        (data['scheduled_at'] as int?) ?? 0,
      ),
      status: (data['status'] as String?) ?? 'scheduled',
    );
  }

  Map<String, dynamic> _toLocalRow(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row);
    for (final entry in row.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.endsWith('_at') && value is String) {
        data[key] = DateTime.parse(value).millisecondsSinceEpoch;
      }
      if (key == 'attendance' && value is bool) {
        data[key] = value ? 1 : 0;
      }
    }
    return data;
  }

  bool? _readAttendance(Map<String, dynamic>? session) {
    if (session == null) return null;
    final raw = session['attendance'];
    if (raw is int) return raw == 1;
    if (raw is bool) return raw;
    return null;
  }

  DateTime? _readDoneAt(Map<String, dynamic>? session) {
    if (session == null) return null;
    final raw = session['done_at'];
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    return null;
  }

  PatientAuditEntry _auditFromLocal(Map<String, dynamic> row) {
    final createdAt = (row['created_at'] as int?) ?? 0;
    final detailsRaw = row['details'];
    Map<String, dynamic> details = const {};
    if (detailsRaw is String && detailsRaw.isNotEmpty) {
      try {
        details = Map<String, dynamic>.from(jsonDecode(detailsRaw));
      } catch (_) {
        details = const {};
      }
    }
    return PatientAuditEntry(
      action: (row['action'] as String?) ?? 'updated',
      changedBy: row['changed_by'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      details: details,
    );
  }
}
