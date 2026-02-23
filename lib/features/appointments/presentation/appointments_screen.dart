import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../patients/presentation/patient_providers.dart';
import '../../therapists/presentation/therapist_providers.dart';
import 'appointments_providers.dart';
import 'appointment_form_screen.dart';
import 'appointment_details_screen.dart';
import 'appointment_filter_provider.dart';

class AppointmentsScreen extends ConsumerWidget {
  static const String routeName = '/appointments';

  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statusFilter = ref.watch(appointmentStatusFilterProvider);
    final selectedDay = ref.watch(selectedAppointmentsDayProvider);
    final data = ref.watch(appointmentsForDayProvider(selectedDay));
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final therapists = ref.watch(therapistsProvider).valueOrNull ?? const [];
    final patientMap = {for (final p in patients) p.id: p.fullName};
    final therapistMap = {for (final t in therapists) t.id: t.fullName};
    return AppScaffold(
      title: l10n.appointmentsTitle,
      body: data.when(
        data: (items) {
          final filtered = statusFilter == 'all'
              ? items
              : items.where((a) => a.status == statusFilter).toList();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(selectedAppointmentsDayProvider.notifier)
                            .state = selectedDay.subtract(
                          const Duration(days: 1),
                        );
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatFullDate(selectedDay),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(selectedAppointmentsDayProvider.notifier)
                            .state = selectedDay.add(
                          const Duration(days: 1),
                        );
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    IconButton(
                      tooltip: l10n.pickDate,
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDay,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          ref
                              .read(selectedAppointmentsDayProvider.notifier)
                              .state = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                          );
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
              _StatusFilterChips(
                selected: statusFilter,
                onSelected: (value) =>
                    ref.read(appointmentStatusFilterProvider.notifier).state =
                        value,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final patientName = patientMap[item.patientId];
                    final therapistName = therapistMap[item.therapistId];
                    final statusColor = AppTheme.statusColor(item.status);
                    final statusBg = AppTheme.statusBgColor(item.status);
                    final time = MaterialLocalizations.of(context)
                        .formatTimeOfDay(
                          TimeOfDay.fromDateTime(item.scheduledAt.toLocal()),
                          alwaysUse24HourFormat: MediaQuery.of(
                            context,
                          ).alwaysUse24HourFormat,
                        );
                    final statusLabel = switch (item.status) {
                      'completed' => l10n.filterCompleted,
                      'missed' => l10n.filterMissed,
                      'canceled' => l10n.filterCanceled,
                      _ => l10n.filterScheduled,
                    };
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentDetailsScreen(
                                appointment: item,
                                patientName: patientName ?? l10n.unknownPatient,
                                therapistName: therapistName ?? '-',
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Colored left bar
                                Container(
                                  width: 6,
                                  color: statusColor,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          patientName ?? l10n.unknownPatient,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          therapistName ?? '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            // Time pill
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color:
                                                    const Color(0xFFE0F2F8),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 11,
                                                    color: Color(0xFF0B6E8A),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    time,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF0B6E8A),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Status chip
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: statusBg,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                statusLabel,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Menu button
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AppointmentFormScreen(
                                                  appointment: item),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      await ref
                                          .read(appointmentRepositoryProvider)
                                          .delete(item.id);
                                      await ref
                                          .read(localNotificationsProvider)
                                          .cancel(item.id);
                                      ref.invalidate(
                                        appointmentsForDayProvider(selectedDay),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(l10n.edit),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(l10n.deleteAction),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert,
                                      color: Color(0xFF90A4AE)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadAppointmentsFailed)),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addAppointment,
        onPressed: () =>
            Navigator.pushNamed(context, AppointmentFormScreen.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatusFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _StatusFilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <String, String>{
      'all': l10n.filterAllLabel,
      'scheduled': l10n.filterScheduled,
      'completed': l10n.filterCompleted,
      'missed': l10n.filterMissed,
      'canceled': l10n.filterCanceled,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: items.entries.map((e) {
          final isSelected = selected == e.key;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(e.value),
              selected: isSelected,
              onSelected: (_) => onSelected(e.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}
