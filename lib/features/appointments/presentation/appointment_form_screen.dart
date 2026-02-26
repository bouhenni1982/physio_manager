import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../patients/presentation/patient_providers.dart';
import '../../patients/domain/patient.dart';
import '../../therapists/presentation/therapist_providers.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../features/settings/presentation/notification_settings_provider.dart';
import '../../../core/notifications/notification_log_service.dart';
import '../../../core/storage/autocomplete_repository.dart';
import '../../../core/storage/autocomplete_providers.dart';
import '../domain/appointment.dart';
import 'appointments_providers.dart';

class AppointmentFormScreen extends ConsumerStatefulWidget {
  static const String routeName = '/appointments/form';

  final Appointment? appointment;
  final String? initialPatientId;
  final String? initialTherapistId;

  const AppointmentFormScreen({
    super.key,
    this.appointment,
    this.initialPatientId,
    this.initialTherapistId,
  });

  @override
  ConsumerState<AppointmentFormScreen> createState() =>
      _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends ConsumerState<AppointmentFormScreen> {
  String? _patientId;
  String? _therapistId;
  DateTime _scheduledAt = DateTime.now();
  String _status = 'scheduled';
  bool _createSeries = false;
  String _repeatMode = 'weekdays';
  final Set<int> _repeatWeekdays = {};

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _customDatesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final a = widget.appointment;
    if (a != null) {
      _patientId = a.patientId;
      _therapistId = a.therapistId;
      _scheduledAt = a.scheduledAt;
      _status = a.status;
    } else {
      _patientId = widget.initialPatientId;
      _therapistId = widget.initialTherapistId;
    }

    _dateController.text = _formatDate(_scheduledAt);
    _timeController.text = _formatTime(_scheduledAt);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _customDatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.appointment != null;
    return AppScaffold(
      title: isEdit
          ? l10n.appointmentFormTitleEdit
          : l10n.appointmentFormTitleAdd,
      body: ref
          .watch(patientsProvider)
          .when(
            data: (patients) {
              Patient? selectedPatient;
              if (_patientId != null) {
                for (final p in patients) {
                  if (p.id == _patientId) {
                    selectedPatient = p;
                    break;
                  }
                }
              }
              final suggested = selectedPatient?.suggestedSessions;
              final remainingSuggested = suggested == null
                  ? 0
                  : (suggested > 0 ? (suggested - 1) : 0);
              return ref
                  .watch(therapistsProvider)
                  .when(
                    data: (therapists) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _patientId,
                            items: patients
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p.id,
                                    child: Text(p.fullName),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _patientId = v),
                            decoration: InputDecoration(
                              labelText: l10n.patientLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _therapistId,
                            items: therapists
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t.id,
                                    child: Text(t.fullName),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _therapistId = v),
                            decoration: InputDecoration(
                              labelText: l10n.therapistLabelShort,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            title: Text(l10n.appointmentDateTime),
                            subtitle: Text(
                              _formatDateTime(context, _scheduledAt),
                            ),
                            trailing: const Icon(Icons.calendar_month),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _scheduledAt,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (date == null || !context.mounted) return;
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                  _scheduledAt,
                                ),
                              );
                              if (time == null) return;
                              setState(() {
                                _scheduledAt = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                _dateController.text = _formatDate(
                                  _scheduledAt,
                                );
                                _timeController.text = _formatTime(
                                  _scheduledAt,
                                );
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _AutoTextField(
                            label: l10n.dateLabel,
                            controller: _dateController,
                            type: 'date',
                            keyboardType: TextInputType.datetime,
                            repo: ref.read(autocompleteRepositoryProvider),
                          ),
                          const SizedBox(height: 12),
                          _AutoTextField(
                            label: l10n.timeLabel,
                            controller: _timeController,
                            type: 'time',
                            keyboardType: TextInputType.datetime,
                            repo: ref.read(autocompleteRepositoryProvider),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _status,
                            items: [
                              DropdownMenuItem(
                                value: 'scheduled',
                                child: Text(l10n.filterScheduled),
                              ),
                              DropdownMenuItem(
                                value: 'completed',
                                child: Text(l10n.filterCompleted),
                              ),
                              DropdownMenuItem(
                                value: 'missed',
                                child: Text(l10n.filterMissed),
                              ),
                              DropdownMenuItem(
                                value: 'canceled',
                                child: Text(l10n.filterCanceled),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _status = v ?? 'scheduled'),
                            decoration: InputDecoration(
                              labelText: l10n.statusLabel,
                            ),
                          ),
                          if (!isEdit) ...[
                            const SizedBox(height: 12),
                            SwitchListTile(
                              value: _createSeries,
                              onChanged: remainingSuggested > 0
                                  ? (v) => setState(() => _createSeries = v)
                                  : null,
                              title: Text(l10n.createRemainingSessionsLabel),
                              subtitle: Text(
                                remainingSuggested > 0
                                    ? l10n
                                        .remainingSessionsHint(remainingSuggested)
                                    : l10n.noRemainingSessionsHint,
                              ),
                            ),
                            if (_createSeries) ...[
                              const SizedBox(height: 8),
                              SegmentedButton<String>(
                                segments: [
                                  ButtonSegment(
                                    value: 'weekdays',
                                    label: Text(l10n.repeatByWeekdays),
                                  ),
                                  ButtonSegment(
                                    value: 'dates',
                                    label: Text(l10n.repeatByDates),
                                  ),
                                ],
                                selected: {_repeatMode},
                                onSelectionChanged: (v) {
                                  setState(() => _repeatMode = v.first);
                                },
                              ),
                              const SizedBox(height: 12),
                              if (_repeatMode == 'weekdays')
                                _WeekdayPicker(
                                  selected: _repeatWeekdays,
                                  onChanged: (set) =>
                                      setState(() => _repeatWeekdays
                                        ..clear()
                                        ..addAll(set)),
                                ),
                              if (_repeatMode == 'dates') ...[
                                TextFormField(
                                  controller: _customDatesController,
                                  decoration: InputDecoration(
                                    labelText: l10n.customDatesLabel,
                                    helperText: l10n.customDatesHint,
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  maxLines: 3,
                                ),
                              ],
                            ],
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: () async {
                              if (_patientId == null || _therapistId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.pickPatientTherapist),
                                  ),
                                );
                                return;
                              }
                              if (!_applyManualDateTime(context, l10n)) return;

                              final repo = ref.read(
                                appointmentRepositoryProvider,
                              );
                              final auto = ref.read(
                                autocompleteRepositoryProvider,
                              );
                              final id =
                                  widget.appointment?.id ?? const Uuid().v4();
                              final appointment = Appointment(
                                id: id,
                                patientId: _patientId!,
                                therapistId: _therapistId!,
                                scheduledAt: _scheduledAt,
                                status: _status,
                              );
                              if (isEdit) {
                                await repo.update(appointment);
                                final notifEnabled = ref.read(
                                  notifEnabledProvider,
                                );
                                if (notifEnabled) {
                                  final minutes = ref.read(
                                    reminderMinutesProvider,
                                  );
                                  final msg = l10n
                                      .appointmentUpdatedWithReminder(minutes);
                                  await ref
                                      .read(localNotificationsProvider)
                                      .showNow(l10n.appointmentUpdated, msg);
                                  await NotificationLogService().log(
                                    l10n.appointmentUpdated,
                                    msg,
                                  );
                                }
                              } else {
                                await repo.create(appointment);
                                final notifEnabled = ref.read(
                                  notifEnabledProvider,
                                );
                                if (notifEnabled) {
                                  final minutes = ref.read(
                                    reminderMinutesProvider,
                                  );
                                  await ref
                                      .read(localNotificationsProvider)
                                      .showNow(
                                        l10n.appointmentCreated,
                                        l10n.appointmentCreatedWithReminder(
                                          minutes,
                                        ),
                                      );
                                  await NotificationLogService().log(
                                    l10n.appointmentCreated,
                                    l10n.appointmentCreatedWithReminder(
                                      minutes,
                                    ),
                                  );
                                }
                              }

                              if (!isEdit &&
                                  _createSeries &&
                                  remainingSuggested > 0) {
                                final extraDates = _buildSeriesDates(
                                  base: _scheduledAt,
                                  count: remainingSuggested,
                                  mode: _repeatMode,
                                  weekdays: _repeatWeekdays,
                                  customDates: _customDatesController.text,
                                );
                                if (extraDates == null) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.invalidRepeatSelection),
                                    ),
                                  );
                                  return;
                                }
                                for (final dt in extraDates) {
                                  final extraId = const Uuid().v4();
                                  final extra = Appointment(
                                    id: extraId,
                                    patientId: _patientId!,
                                    therapistId: _therapistId!,
                                    scheduledAt: dt,
                                    status: 'scheduled',
                                  );
                                  await repo.create(extra);
                                  final notifications = ref.read(
                                    localNotificationsProvider,
                                  );
                                  await notifications.cancel(extraId);
                                  final notifEnabled = ref.read(
                                    notifEnabledProvider,
                                  );
                                  if (notifEnabled) {
                                    final minutes = ref.read(
                                      reminderMinutesProvider,
                                    );
                                    final remindAt = dt.subtract(
                                      Duration(minutes: minutes),
                                    );
                                    await notifications.scheduleReminder(
                                      extraId,
                                      remindAt,
                                      l10n.reminderTitle,
                                      l10n.reminderBody(minutes),
                                    );
                                  }
                                }
                              }

                              final dateStr = _formatDate(_scheduledAt);
                              final timeStr = _formatTime(_scheduledAt);
                              await auto.record('date', dateStr);
                              await auto.record('time', timeStr);

                              final dayKey = DateTime(
                                _scheduledAt.year,
                                _scheduledAt.month,
                                _scheduledAt.day,
                              );
                              ref.invalidate(
                                appointmentsForDayProvider(dayKey),
                              );
                              ref
                                      .read(
                                        selectedAppointmentsDayProvider
                                            .notifier,
                                      )
                                      .state =
                                  dayKey;
                              final notifications = ref.read(
                                localNotificationsProvider,
                              );
                              await notifications.cancel(appointment.id);
                              final notifEnabled = ref.read(
                                notifEnabledProvider,
                              );
                              if (notifEnabled) {
                                final minutes = ref.read(
                                  reminderMinutesProvider,
                                );
                                final remindAt = _scheduledAt.subtract(
                                  Duration(minutes: minutes),
                                );
                                await notifications.scheduleReminder(
                                  appointment.id,
                                  remindAt,
                                  l10n.reminderTitle,
                                  l10n.reminderBody(minutes),
                                );
                              }
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Text(isEdit ? l10n.update : l10n.save),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) =>
                        Center(child: Text(l10n.loadTherapistsFailed)),
                  );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.loadPatientsFailed)),
          ),
    );
  }

  bool _applyManualDateTime(BuildContext context, AppLocalizations l10n) {
    final dateStr = _dateController.text.trim();
    final timeStr = _timeController.text.trim();
    if (dateStr.isEmpty && timeStr.isEmpty) return true;

    DateTime? datePart;
    if (dateStr.isNotEmpty) {
      datePart = DateTime.tryParse(dateStr);
      if (datePart == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidDate)));
        return false;
      }
    }

    int hour = _scheduledAt.hour;
    int minute = _scheduledAt.minute;
    if (timeStr.isNotEmpty) {
      final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(timeStr);
      if (match == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidTime)));
        return false;
      }
      hour = int.parse(match.group(1)!);
      minute = int.parse(match.group(2)!);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidTimeValue)));
        return false;
      }
    }

    final base = datePart ?? _scheduledAt;
    _scheduledAt = DateTime(base.year, base.month, base.day, hour, minute);
    return true;
  }
}

String _formatDateTime(BuildContext context, DateTime dateTime) {
  final local = dateTime.toLocal();
  final dateText = MaterialLocalizations.of(context).formatFullDate(local);
  final timeText = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
  );
  return '$dateText - $timeText';
}

String _formatDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

List<DateTime>? _buildSeriesDates({
  required DateTime base,
  required int count,
  required String mode,
  required Set<int> weekdays,
  required String customDates,
}) {
  if (count <= 0) return <DateTime>[];
  if (mode == 'weekdays') {
    if (weekdays.isEmpty) return null;
    final out = <DateTime>[];
    var cursor = base;
    while (out.length < count) {
      cursor = cursor.add(const Duration(days: 1));
      if (weekdays.contains(cursor.weekday)) {
        out.add(DateTime(
          cursor.year,
          cursor.month,
          cursor.day,
          base.hour,
          base.minute,
        ));
      }
    }
    return out;
  }

  // mode == 'dates'
  final parsed = _parseCustomDates(customDates);
  if (parsed.isEmpty) return null;
  parsed.sort();
  final out = <DateTime>[];
  for (final d in parsed) {
    if (d.isAfter(base)) {
      out.add(DateTime(d.year, d.month, d.day, base.hour, base.minute));
    }
    if (out.length == count) break;
  }
  if (out.length < count) return null;
  return out;
}

List<DateTime> _parseCustomDates(String input) {
  final cleaned = input.replaceAll('\r', ' ').replaceAll('\n', ' ');
  final parts = cleaned.split(RegExp(r'[,\s]+'));
  final dates = <DateTime>[];
  for (final p in parts) {
    if (p.trim().isEmpty) continue;
    final candidate = p.trim().replaceAll('/', '-');
    final dt = DateTime.tryParse(candidate);
    if (dt != null) {
      dates.add(DateTime(dt.year, dt.month, dt.day));
    }
  }
  return dates;
}

class _WeekdayPicker extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  const _WeekdayPicker({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = MaterialLocalizations.of(context).narrowWeekdays;
    // MaterialLocalizations: Sunday..Saturday
    const mapToDateTimeWeekday = [7, 1, 2, 3, 4, 5, 6];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (i) {
        final weekday = mapToDateTimeWeekday[i];
        final isSelected = selected.contains(weekday);
        return FilterChip(
          label: Text(labels[i]),
          selected: isSelected,
          onSelected: (v) {
            final next = Set<int>.from(selected);
            if (v) {
              next.add(weekday);
            } else {
              next.remove(weekday);
            }
            onChanged(next);
          },
        );
      }),
    );
  }
}

class _AutoTextField extends StatelessWidget {
  final String label;
  final String type;
  final TextEditingController controller;
  final AutocompleteRepository repo;
  final TextInputType? keyboardType;

  const _AutoTextField({
    required this.label,
    required this.type,
    required this.controller,
    required this.repo,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (value) async {
        return repo.search(type, value.text.trim());
      },
      onSelected: (v) => controller.text = v,
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        fieldController.text = controller.text;
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label),
          onChanged: (v) => controller.text = v,
        );
      },
    );
  }
}
