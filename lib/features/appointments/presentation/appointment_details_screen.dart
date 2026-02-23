import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/appointment.dart';
import 'appointments_providers.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/notifications/notification_log_service.dart';
import '../../../features/settings/presentation/notification_settings_provider.dart';
import '../data/session_service.dart';

class AppointmentDetailsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/appointments/details';

  final Appointment appointment;
  final String patientName;
  final String therapistName;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    required this.patientName,
    required this.therapistName,
  });

  @override
  ConsumerState<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState
    extends ConsumerState<AppointmentDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();
  Timer? _debounce;
  String _lastSavedNote = '';
  bool _noteLoaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _debounce?.cancel();
    final delay = ref.read(noteAutoSaveDelayProvider);
    _debounce = Timer(Duration(milliseconds: delay), () {
      _saveNoteIfChanged();
    });
  }

  Future<void> _saveNoteIfChanged() async {
    final l10n = AppLocalizations.of(context);
    final note = _noteController.text.trim();
    if (note == _lastSavedNote) return;
    setState(() => _saving = true);
    await _saveNote(widget.appointment.id, note, context, l10n);
    await SessionService().upsertSession(
      appointmentId: widget.appointment.id,
      notes: note,
    );
    await SessionService().audit(
      appointmentId: widget.appointment.id,
      action: 'note_updated',
      details: note,
    );
    _lastSavedNote = note;
    setState(() => _saving = false);
    final notifEnabled = ref.read(notifEnabledProvider);
    if (notifEnabled) {
      await ref
          .read(localNotificationsProvider)
          .showNow(l10n.noteSaved, l10n.noteSavedFor(widget.patientName));
      await NotificationLogService().log(
        l10n.noteSaved,
        l10n.noteSavedFor(widget.patientName),
      );
    }
  }

  Future<void> _clearNote() async {
    _noteController.clear();
    await _saveNoteIfChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final time = _formatLocal(widget.appointment.scheduledAt, context);
    return AppScaffold(
      title: l10n.appointmentDetailsTitle,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.patientLabelValue(widget.patientName),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.therapistLabelValue(widget.therapistName),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.timeLabelValue(time),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.statusLabelValue(
                _statusLabel(l10n, widget.appointment.status),
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final updated = Appointment(
                  id: widget.appointment.id,
                  patientId: widget.appointment.patientId,
                  therapistId: widget.appointment.therapistId,
                  scheduledAt: widget.appointment.scheduledAt,
                  status: 'completed',
                );
                await ref.read(appointmentRepositoryProvider).update(updated);
                await SessionService().upsertSession(
                  appointmentId: widget.appointment.id,
                  attendance: true,
                );
                await SessionService().audit(
                  appointmentId: widget.appointment.id,
                  action: 'attendance_marked',
                  details: 'completed',
                );
                final dayKey = DateTime(
                  widget.appointment.scheduledAt.year,
                  widget.appointment.scheduledAt.month,
                  widget.appointment.scheduledAt.day,
                );
                ref.invalidate(appointmentsForDayProvider(dayKey));
                ref.read(selectedAppointmentsDayProvider.notifier).state =
                    dayKey;
                await ref
                    .read(localNotificationsProvider)
                    .showNow(l10n.attendanceMarked, l10n.attendanceMarked);
                await NotificationLogService().log(
                  l10n.attendanceMarked,
                  l10n.attendanceMarked,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.attendanceMarked)),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: Text(l10n.markPresent),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final updated = Appointment(
                  id: widget.appointment.id,
                  patientId: widget.appointment.patientId,
                  therapistId: widget.appointment.therapistId,
                  scheduledAt: widget.appointment.scheduledAt,
                  status: 'missed',
                );
                await ref.read(appointmentRepositoryProvider).update(updated);
                await SessionService().upsertSession(
                  appointmentId: widget.appointment.id,
                  attendance: false,
                );
                await SessionService().audit(
                  appointmentId: widget.appointment.id,
                  action: 'attendance_marked',
                  details: 'missed',
                );
                final dayKey = DateTime(
                  widget.appointment.scheduledAt.year,
                  widget.appointment.scheduledAt.month,
                  widget.appointment.scheduledAt.day,
                );
                ref.invalidate(appointmentsForDayProvider(dayKey));
                ref.read(selectedAppointmentsDayProvider.notifier).state =
                    dayKey;
                await ref
                    .read(localNotificationsProvider)
                    .showNow(l10n.absenceMarked, l10n.absenceMarked);
                await NotificationLogService().log(
                  l10n.absenceMarked,
                  l10n.absenceMarked,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.absenceMarked)));
                }
              },
              icon: const Icon(Icons.close),
              label: Text(l10n.markAbsent),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            FutureBuilder(
              future: Supabase.instance.client
                  .from('sessions')
                  .select()
                  .eq('appointment_id', widget.appointment.id)
                  .maybeSingle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(l10n.noSessionDetails);
                }
                final data = snapshot.data as Map<String, dynamic>;
                final attendance = data['attendance'] == true
                    ? l10n.attendancePresent
                    : l10n.attendanceAbsent;
                final doneAt = data['done_at'] as String?;
                final note = (data['notes'] as String?) ?? '';
                if (!_noteLoaded) {
                  _noteController.text = note;
                  _lastSavedNote = note.trim();
                  _noteLoaded = true;
                }
                final formattedDoneAt = _formatIsoLocal(doneAt, context);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sessionDetails,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.attendance(attendance)),
                    if (formattedDoneAt != null)
                      Text(l10n.sessionTime(formattedDoneAt)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.sessionNote,
                        suffixIcon: _saving
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clearNote,
                              ),
                      ),
                      onChanged: (_) => _scheduleSave(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _formatLocal(DateTime date, BuildContext context) {
  final local = date.toLocal();
  final time = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
  );
  final dateText = MaterialLocalizations.of(context).formatMediumDate(local);
  return '$dateText $time';
}

String? _formatIsoLocal(String? iso, BuildContext context) {
  if (iso == null || iso.isEmpty) return null;
  final dt = DateTime.tryParse(iso);
  if (dt == null) return null;
  return _formatLocal(dt, context);
}

Future<void> _saveNote(
  String appointmentId,
  String note,
  BuildContext context,
  AppLocalizations l10n,
) async {
  final existing = await Supabase.instance.client
      .from('sessions')
      .select('id')
      .eq('appointment_id', appointmentId)
      .maybeSingle();
  final existingId = existing?['id'] as String?;
  final sessionId = (existingId == null || existingId.isEmpty)
      ? const Uuid().v4()
      : existingId;
  final nowIso = DateTime.now().toUtc().toIso8601String();
  await Supabase.instance.client.from('sessions').upsert({
    'id': sessionId,
    'appointment_id': appointmentId,
    'notes': note.trim(),
    'updated_at': nowIso,
    if (existing == null) 'created_at': nowIso,
  }, onConflict: 'appointment_id');
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.noteSaved)));
  }
}

String _statusLabel(AppLocalizations l10n, String status) {
  switch (status) {
    case 'completed':
      return l10n.filterCompleted;
    case 'missed':
      return l10n.filterMissed;
    case 'canceled':
      return l10n.filterCanceled;
    default:
      return l10n.filterScheduled;
  }
}
