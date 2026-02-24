import 'dart:io';
import 'package:flutter/material.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/utils/phone_launcher.dart';
import '../data/patient_details_service.dart';
import '../../appointments/presentation/appointment_details_screen.dart';
import 'patient_form_screen.dart';
import 'patient_providers.dart';

class PatientDetailsScreen extends ConsumerWidget {
  static const String routeName = '/patients/details';

  final String patientId;

  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(patientDetailsProvider(patientId));
    return AppScaffold(
      title: l10n.patientDetailsTitle,
      body: data.when(
        data: (details) {
          if (details == null) {
            return Center(child: Text(l10n.loadPatientDetailsFailed));
          }
          final patient = details.patient;
          final completedCount = details.history
              .where(
                (e) =>
                    e.appointment.status == 'completed' || e.attendance == true,
              )
              .length;
          final missedCount = details.history
              .where(
                (e) =>
                    e.appointment.status == 'missed' || e.attendance == false,
              )
              .length;
          final suggested = patient.suggestedSessions;
          final remainingCount = suggested == null
              ? null
              : math.max(suggested - completedCount, 0);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.phoneValue(patient.phone ?? '-'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF0B6E8A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if ((patient.phone ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () async {
                            final ok = await launchPhone(patient.phone!);
                            if (!ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.callFailed)),
                              );
                            }
                          },
                          icon: const Icon(Icons.phone),
                          label: Text(l10n.callPatient),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(l10n.ageValue('${patient.age ?? '-'}')),
                      Text(l10n.genderValue(_genderLabel(patient.gender, l10n))),
                      Text(
                        l10n.statusLabelValue(
                          _patientStatusLabel(patient.status, l10n),
                        ),
                      ),
                      Text(l10n.diagnosisValue(patient.diagnosis ?? '-')),
                      Text(l10n.medicalHistoryValue(patient.medicalHistory ?? '-')),
                      Text(l10n.doctorValue(patient.doctorName ?? '-')),
                    ],
                  ),
                ),
              ),
              if (patient.prescriptionImagePath != null &&
                  File(patient.prescriptionImagePath!).existsSync()) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.prescriptionTitle),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(patient.prescriptionImagePath!),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickStatCard(
                      label: l10n.completed,
                      value: completedCount.toString(),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickStatCard(
                      label: l10n.missed,
                      value: missedCount.toString(),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickStatCard(
                      label: l10n.remaining,
                      value: remainingCount?.toString() ?? '-',
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientFormScreen(patient: patient),
                      ),
                    );
                    ref.invalidate(patientDetailsProvider(patientId));
                    ref.invalidate(patientsProvider);
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.editPatientData),
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(
                title: l10n.upcomingAppointments,
                count: details.upcoming.length,
              ),
              const SizedBox(height: 8),
              if (details.upcoming.isEmpty)
                _EmptyState(text: l10n.noUpcomingAppointments),
              ...details.upcoming.map(
                (entry) => _AppointmentTile(
                  title: entry.therapistName,
                  subtitle: _buildSubtitle(entry, context),
                  status: entry.appointment.status,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsScreen(
                          appointment: entry.appointment,
                          patientName: patient.fullName,
                          therapistName: entry.therapistName,
                        ),
                      ),
                    );
                    ref.invalidate(patientDetailsProvider(patientId));
                  },
                ),
              ),
              const SizedBox(height: 16),
              _SectionTitle(
                title: l10n.sessionsHistory,
                count: details.history.length,
              ),
              const SizedBox(height: 8),
              if (details.history.isEmpty)
                _EmptyState(text: l10n.noSessionsYet),
              ...details.history.map(
                (entry) => _AppointmentTile(
                  title: entry.therapistName,
                  subtitle: _buildSubtitle(entry, context),
                  status: entry.appointment.status,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsScreen(
                          appointment: entry.appointment,
                          patientName: patient.fullName,
                          therapistName: entry.therapistName,
                        ),
                      ),
                    );
                    ref.invalidate(patientDetailsProvider(patientId));
                  },
                ),
              ),
              const SizedBox(height: 16),
              _SectionTitle(
                title: l10n.patientAuditTitle,
                count: details.audits.length,
              ),
              const SizedBox(height: 8),
              if (details.audits.isEmpty)
                _EmptyState(text: l10n.patientAuditEmpty),
              ...details.audits.map(
                (audit) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_auditActionLabel(audit.action, l10n)),
                    subtitle: Text(
                      '${_fmtDateTime(audit.createdAt, context)}\n${audit.changedBy ?? '-'}',
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.loadPatientDetailsFailed)),
      ),
    );
  }

  String _buildSubtitle(PatientTimelineEntry entry, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheduled = _fmtDateTime(entry.appointment.scheduledAt, context);
    final attendance = switch (entry.attendance) {
      true => l10n.attendancePresent,
      false => l10n.attendanceAbsent,
      null => l10n.attendanceUnknown,
    };
    final note =
        (entry.sessionNotes == null || entry.sessionNotes!.trim().isEmpty)
        ? '-'
        : entry.sessionNotes!;
    return l10n.appointmentSubtitle(
      scheduled,
      _statusLabel(entry.appointment.status, l10n),
      attendance,
      note,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text('($count)'),
      ],
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final VoidCallback onTap;

  const _AppointmentTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        isThreeLine: true,
        trailing: _StatusChip(status: status),
        onTap: onTap,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (text, color) = switch (status) {
      'completed' => (l10n.completed, Colors.green),
      'missed' => (l10n.missed, Colors.red),
      'canceled' => (l10n.canceled, Colors.orange),
      _ => (l10n.scheduled, Colors.blue),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)),
    );
  }
}

String _fmtDateTime(DateTime dt, BuildContext context) {
  final local = dt.toLocal();
  final date = MaterialLocalizations.of(context).formatMediumDate(local);
  final time = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
  );
  return '$date $time';
}

String _statusLabel(String status, AppLocalizations l10n) {
  return switch (status) {
    'completed' => l10n.completed,
    'missed' => l10n.missed,
    'canceled' => l10n.canceled,
    _ => l10n.scheduled,
  };
}

String _genderLabel(String gender, AppLocalizations l10n) {
  return switch (gender) {
    'male' => l10n.filterMale,
    'female' => l10n.filterFemale,
    'child' => l10n.filterChild,
    _ => gender,
  };
}

String _patientStatusLabel(String status, AppLocalizations l10n) {
  return switch (status) {
    'active' => l10n.statusActive,
    'completed' => l10n.statusCompleted,
    'suspended' => l10n.statusSuspended,
    _ => status,
  };
}

String _auditActionLabel(String action, AppLocalizations l10n) {
  return switch (action) {
    'created' => l10n.auditCreated,
    'updated' => l10n.auditUpdated,
    'deleted' => l10n.auditDeleted,
    _ => action,
  };
}

