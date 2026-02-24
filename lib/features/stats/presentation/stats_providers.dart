import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/storage/local_db.dart';
import '../../../core/storage/local_db_provider.dart';

enum StatsPeriod { month, year, all }

class StatsFilter {
  final StatsPeriod period;
  final int year;
  final int month;

  const StatsFilter({
    required this.period,
    required this.year,
    required this.month,
  });
}

class TherapistStatsSummary {
  final String therapistId;
  final String therapistName;
  final int totalPatients;
  final int patientsMale;
  final int patientsFemale;
  final int patientsChild;
  final int activePatients;
  final int completedPatients;

  const TherapistStatsSummary({
    required this.therapistId,
    required this.therapistName,
    required this.totalPatients,
    required this.patientsMale,
    required this.patientsFemale,
    required this.patientsChild,
    required this.activePatients,
    required this.completedPatients,
  });
}

class StatsSummary {
  final int totalSessions;
  final int sessionsMale;
  final int sessionsFemale;
  final int sessionsChild;
  final int totalPatients;
  final int patientsMale;
  final int patientsFemale;
  final int patientsChild;
  final int activePatients;
  final int completedPatients;
  final List<TherapistStatsSummary> byTherapist;

  const StatsSummary({
    required this.totalSessions,
    required this.sessionsMale,
    required this.sessionsFemale,
    required this.sessionsChild,
    required this.totalPatients,
    required this.patientsMale,
    required this.patientsFemale,
    required this.patientsChild,
    required this.activePatients,
    required this.completedPatients,
    required this.byTherapist,
  });
}

final statsSummaryProvider =
    FutureProvider.family<StatsSummary, StatsFilter>((ref, filter) async {
      final db = ref.watch(localDbProvider);
      final service = _StatsService(db);
      return service.load(filter);
    });

class _TherapistCounters {
  int totalPatients = 0;
  int patientsMale = 0;
  int patientsFemale = 0;
  int patientsChild = 0;
  int activePatients = 0;
  int completedPatients = 0;
}

class _StatsService {
  final LocalDbService _db;
  final SupabaseClient _client = Supabase.instance.client;

  _StatsService(this._db);

  Future<StatsSummary> load(StatsFilter filter) async {
    await _db.init();
    var patientsRows = await _db.query('patients');
    var appointmentsRows = await _db.query('appointments');
    var therapistsRows = await _db.query('therapists');

    try {
      final remotePatients = await _client.from('patients').select();
      patientsRows = (remotePatients as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      for (final row in patientsRows) {
        await _db.insert('patients', _toLocalRow(row));
      }
    } catch (_) {
      // Keep local fallback.
    }

    try {
      final remoteAppointments = await _client.from('appointments').select();
      appointmentsRows = (remoteAppointments as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      for (final row in appointmentsRows) {
        await _db.insert('appointments', _toLocalRow(row));
      }
    } catch (_) {
      // Keep local fallback.
    }

    try {
      final remoteTherapists = await _client.from('therapists').select();
      therapistsRows = (remoteTherapists as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      for (final row in therapistsRows) {
        await _db.insert('therapists', _toLocalRow(row));
      }
    } catch (_) {
      // Keep local fallback.
    }

    final therapistNames = <String, String>{};
    for (final t in therapistsRows) {
      final id = (t['id'] ?? '').toString();
      if (id.isEmpty) continue;
      therapistNames[id] = (t['full_name'] ?? '').toString();
    }

    final genderByPatientId = <String, String>{};
    final perTherapist = <String, _TherapistCounters>{};
    var malePatients = 0;
    var femalePatients = 0;
    var childPatients = 0;
    var activePatients = 0;
    var completedPatients = 0;
    var totalPatients = 0;

    for (final p in patientsRows) {
      if (!_matchesFilter(_readEpochMs(p['created_at']), filter)) continue;

      final patientId = (p['id'] ?? '').toString();
      final therapistId = (p['therapist_id'] ?? '').toString();
      final gender = _normalizeGender((p['gender'] ?? '').toString());
      final status = (p['status'] ?? '').toString().toLowerCase();
      totalPatients++;

      if (patientId.isNotEmpty) genderByPatientId[patientId] = gender;
      if (gender == 'male') malePatients++;
      if (gender == 'female') femalePatients++;
      if (gender == 'child') childPatients++;
      if (status == 'active') activePatients++;
      if (status == 'completed') completedPatients++;

      if (therapistId.isNotEmpty) {
        final c = perTherapist.putIfAbsent(therapistId, _TherapistCounters.new);
        c.totalPatients++;
        if (gender == 'male') c.patientsMale++;
        if (gender == 'female') c.patientsFemale++;
        if (gender == 'child') c.patientsChild++;
        if (status == 'active') c.activePatients++;
        if (status == 'completed') c.completedPatients++;
      }
    }

    var maleSessions = 0;
    var femaleSessions = 0;
    var childSessions = 0;
    var totalSessions = 0;

    for (final a in appointmentsRows) {
      if (!_matchesFilter(_readEpochMs(a['scheduled_at']), filter)) continue;
      final status = (a['status'] ?? '').toString().toLowerCase();
      if (status == 'canceled') continue;
      totalSessions++;

      final patientId = (a['patient_id'] ?? '').toString();
      final g = genderByPatientId[patientId];
      if (g == 'male') maleSessions++;
      if (g == 'female') femaleSessions++;
      if (g == 'child') childSessions++;
    }

    final byTherapist = perTherapist.entries.map((entry) {
      final id = entry.key;
      final c = entry.value;
      return TherapistStatsSummary(
        therapistId: id,
        therapistName: therapistNames[id] ?? '-',
        totalPatients: c.totalPatients,
        patientsMale: c.patientsMale,
        patientsFemale: c.patientsFemale,
        patientsChild: c.patientsChild,
        activePatients: c.activePatients,
        completedPatients: c.completedPatients,
      );
    }).toList()
      ..sort((a, b) => b.totalPatients.compareTo(a.totalPatients));

    return StatsSummary(
      totalSessions: totalSessions,
      sessionsMale: maleSessions,
      sessionsFemale: femaleSessions,
      sessionsChild: childSessions,
      totalPatients: totalPatients,
      patientsMale: malePatients,
      patientsFemale: femalePatients,
      patientsChild: childPatients,
      activePatients: activePatients,
      completedPatients: completedPatients,
      byTherapist: byTherapist,
    );
  }

  bool _matchesFilter(int? epochMs, StatsFilter filter) {
    if (filter.period == StatsPeriod.all) return true;
    if (epochMs == null) return false;
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs).toLocal();
    if (filter.period == StatsPeriod.year) {
      return dt.year == filter.year;
    }
    return dt.year == filter.year && dt.month == filter.month;
  }

  int? _readEpochMs(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return raw;
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed.millisecondsSinceEpoch;
      return int.tryParse(raw);
    }
    return null;
  }

  String _normalizeGender(String raw) {
    final g = raw.toLowerCase().trim();
    if (g == 'male' || g == 'm' || g.contains('ذكر')) return 'male';
    if (g == 'female' || g == 'f' || g.contains('أنث')) return 'female';
    if (g == 'child' || g.contains('طفل')) return 'child';
    return '';
  }

  Map<String, dynamic> _toLocalRow(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row);
    for (final entry in row.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.endsWith('_at') && value is String) {
        data[key] = DateTime.parse(value).millisecondsSinceEpoch;
      }
      if (key == 'is_primary' && value is bool) {
        data[key] = value ? 1 : 0;
      }
    }
    return data;
  }
}
