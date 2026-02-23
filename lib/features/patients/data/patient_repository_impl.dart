import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/sync_manager.dart';
import '../../../core/storage/local_db.dart';
import '../../../core/storage/local_db_instance.dart';
import '../domain/patient.dart';
import 'patient_repository.dart';

class SupabasePatientRepository implements PatientRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final LocalDbService _db = appLocalDb;
  late final SyncManager _sync = SyncManager(_db);

  @override
  Future<List<Patient>> getAll() async {
    await _db.init();
    final isAdmin = await _isCurrentUserAdmin();
    final therapistId = isAdmin ? null : await _currentTherapistId();
    final local = isAdmin
        ? await _db.query('patients')
        : await _db.queryWhere(
            'patients',
            where: 'therapist_id = ?',
            whereArgs: [therapistId ?? ''],
          );
    if (local.isNotEmpty) {
      return local.map(_fromRowLocal).toList();
    }
    try {
      var req = _client.from('patients').select();
      if (!isAdmin && therapistId != null) {
        req = req.eq('therapist_id', therapistId);
      }
      final rows = await req;
      for (final r in (rows as List<dynamic>)) {
        final data = r as Map<String, dynamic>;
        await _db.insert('patients', _toLocal(data));
      }
      return (rows as List<dynamic>).map(_fromRow).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Patient> create(Patient patient) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final localRow = _toLocal(_toRow(patient), nowMs: now);
    localRow['prescription_image_path'] = patient.prescriptionImagePath;
    await _db.insert('patients', localRow);
    await _logAudit(
      patientId: patient.id,
      action: 'created',
      details: {
        'full_name': patient.fullName,
        'gender': patient.gender,
        'status': patient.status,
        'phone': patient.phone,
      },
      nowMs: now,
    );
    try {
      final row = _toRow(patient, nowMs: now);
      dynamic res;
      try {
        res = await _client.from('patients').insert(row).select().single();
      } on PostgrestException catch (e) {
        // Backward compatibility if remote schema still misses patients.phone.
        if ((e.code == '42703' || e.message.contains('column')) &&
            row.containsKey('phone')) {
          final fallback = Map<String, dynamic>.from(row)..remove('phone');
          res = await _client
              .from('patients')
              .insert(fallback)
              .select()
              .single();
        } else {
          rethrow;
        }
      }
      return _fromRow(res);
    } catch (_) {
      await _sync.enqueue(
        table: 'patients',
        operation: 'insert',
        recordId: patient.id,
        payload: _toRow(patient, nowMs: now),
      );
      return patient;
    }
  }

  @override
  Future<void> update(Patient patient) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    final localRow = _toLocal(_toRow(patient), nowMs: now);
    localRow['prescription_image_path'] = patient.prescriptionImagePath;
    await _db.update('patients', localRow, 'id = ?', [patient.id]);
    await _logAudit(
      patientId: patient.id,
      action: 'updated',
      details: {
        'full_name': patient.fullName,
        'gender': patient.gender,
        'status': patient.status,
        'phone': patient.phone,
      },
      nowMs: now,
    );
    try {
      final row = _toRow(patient, nowMs: now);
      try {
        await _client.from('patients').update(row).eq('id', patient.id);
      } on PostgrestException catch (e) {
        if ((e.code == '42703' || e.message.contains('column')) &&
            row.containsKey('phone')) {
          final fallback = Map<String, dynamic>.from(row)..remove('phone');
          await _client.from('patients').update(fallback).eq('id', patient.id);
        } else {
          rethrow;
        }
      }
    } catch (_) {
      await _sync.enqueue(
        table: 'patients',
        operation: 'update',
        recordId: patient.id,
        payload: _toRow(patient, nowMs: now),
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    await _db.init();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _logAudit(
      patientId: id,
      action: 'deleted',
      details: const {},
      nowMs: now,
    );
    await _db.delete('patients', 'id = ?', [id]);
    try {
      await _client.from('patients').delete().eq('id', id);
    } catch (_) {
      await _sync.enqueue(table: 'patients', operation: 'delete', recordId: id);
    }
  }

  Patient _fromRow(dynamic row) {
    final data = row as Map<String, dynamic>;
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

  Patient _fromRowLocal(Map<String, dynamic> data) {
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

  Map<String, dynamic> _toRow(Patient patient, {int? nowMs}) {
    return {
      'id': patient.id,
      'full_name': patient.fullName,
      'age': patient.age,
      'gender': patient.gender,
      'diagnosis': patient.diagnosis,
      'medical_history': patient.medicalHistory,
      'suggested_sessions': patient.suggestedSessions,
      'therapist_id': patient.therapistId,
      'doctor_name': patient.doctorName,
      'phone': patient.phone,
      'status': patient.status,
      if (nowMs != null)
        'updated_at': DateTime.fromMillisecondsSinceEpoch(
          nowMs,
        ).toUtc().toIso8601String(),
      if (nowMs != null)
        'created_at': DateTime.fromMillisecondsSinceEpoch(
          nowMs,
        ).toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _toLocal(Map<String, dynamic> row, {int? nowMs}) {
    final data = Map<String, dynamic>.from(row);
    final updated = row['updated_at'];
    final created = row['created_at'];
    if (updated is String) {
      data['updated_at'] = DateTime.parse(updated).millisecondsSinceEpoch;
    } else if (nowMs != null) {
      data['updated_at'] = nowMs;
    }
    if (created is String) {
      data['created_at'] = DateTime.parse(created).millisecondsSinceEpoch;
    } else if (nowMs != null) {
      data['created_at'] = nowMs;
    }
    return data;
  }

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return false;
    try {
      final row = await _client
          .from('therapists')
          .select('is_primary')
          .eq('user_id', uid)
          .maybeSingle();
      return row?['is_primary'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _currentTherapistId() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;
    try {
      final row = await _client
          .from('therapists')
          .select('id')
          .eq('user_id', uid)
          .maybeSingle();
      return row?['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> _logAudit({
    required String patientId,
    required String action,
    required Map<String, dynamic> details,
    required int nowMs,
  }) async {
    final changedBy = _client.auth.currentUser?.id;
    final id = const Uuid().v4();
    final row = <String, dynamic>{
      'id': id,
      'patient_id': patientId,
      'action': action,
      'changed_by': changedBy,
      'details': jsonEncode(details),
      'created_at': nowMs,
    };
    await _db.insert('patient_audit', row);
    final payload = <String, dynamic>{
      'id': id,
      'patient_id': patientId,
      'action': action,
      'changed_by': changedBy,
      'details': details,
      'created_at': DateTime.fromMillisecondsSinceEpoch(
        nowMs,
      ).toUtc().toIso8601String(),
    };
    try {
      await _client.from('patient_audit').insert(payload);
    } catch (_) {
      await _sync.enqueue(
        table: 'patient_audit',
        operation: 'insert',
        recordId: id,
        payload: payload,
      );
    }
  }
}
