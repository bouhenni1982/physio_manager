import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/constants/role.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../appointments/presentation/appointments_screen.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../patients/presentation/patients_screen.dart';
import '../../patients/presentation/patient_details_screen.dart';
import '../../patients/presentation/patient_providers.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../therapists/presentation/therapists_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../auth/presentation/auth_providers.dart';
import 'dashboard_tabs_prefs.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final roleAsync = ref.watch(currentUserRoleProvider);
    final role = roleAsync.valueOrNull ?? authUser?.role ?? UserRole.therapist.value;
    final isAdmin = role == UserRole.admin.value;
    final tabPrefs = ref.watch(
      dashboardTabsProvider(authUser?.id ?? 'guest'),
    );
    final tabs = _applyPrefs(_buildTabs(l10n, isAdmin), tabPrefs);
    final safeIndex = tabs.isEmpty ? 0 : (_index >= tabs.length ? tabs.length - 1 : _index);

    return Scaffold(
      body: IndexedStack(index: safeIndex, children: tabs.map((t) => t.screen).toList()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: tabs.map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label)).toList(),
      ),
    );
  }

  List<_TabItem> _buildTabs(AppLocalizations l10n, bool isAdmin) {
    final base = <_TabItem>[
      _TabItem(id: 'today', label: l10n.dashboardToday, icon: Icons.today, screen: const _DayView()),
      _TabItem(id: 'appointments', label: l10n.dashboardAppointments, icon: Icons.calendar_month, screen: const AppointmentsScreen()),
      _TabItem(id: 'patients', label: l10n.dashboardPatients, icon: Icons.people, screen: const PatientsScreen()),
    ];

    if (isAdmin) {
      base.addAll([
        _TabItem(id: 'therapists', label: l10n.dashboardTherapists, icon: Icons.medical_services, screen: const TherapistsScreen()),
        _TabItem(id: 'stats', label: l10n.dashboardStats, icon: Icons.bar_chart, screen: const StatsScreen()),
        _TabItem(id: 'settings', label: l10n.dashboardSettings, icon: Icons.settings, screen: const SettingsScreen()),
      ]);
    } else {
      base.add(
        _TabItem(id: 'settings', label: l10n.dashboardSettings, icon: Icons.settings, screen: const SettingsScreen()),
      );
    }

    return base;
  }

  List<_TabItem> _applyPrefs(
    List<_TabItem> defaults,
    DashboardTabsState prefs,
  ) {
    final map = {for (final t in defaults) t.id: t};
    final order = prefs.order.where(map.containsKey).toList();
    final missing = map.keys.where((k) => !order.contains(k));
    final merged = [...order, ...missing];
    final visible = merged
        .where((id) => !prefs.hidden.contains(id))
        .map((id) => map[id]!)
        .toList();
    if (visible.isEmpty) {
      return [defaults.first];
    }
    return visible;
  }
}

class _TabItem {
  final String id;
  final String label;
  final IconData icon;
  final Widget screen;

  const _TabItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.screen,
  });
}

class _DayView extends ConsumerStatefulWidget {
  const _DayView();

  @override
  ConsumerState<_DayView> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<_DayView> {
  late DateTime _day;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appointmentsData = ref.watch(appointmentsForDayProvider(_day));
    final patientsData = ref.watch(patientsProvider);

    return AppScaffold(
      title: l10n.todaySessions,
      body: appointmentsData.when(
        data: (appointments) {
          return patientsData.when(
            data: (patients) {
              final patientNames = {
                for (final p in patients) p.id: p.fullName,
              };
              final sorted = [...appointments]
                ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
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
                          onPressed: () => setState(() {
                            _day = _day.subtract(const Duration(days: 1));
                          }),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              MaterialLocalizations.of(context).formatFullDate(_day),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _day = _day.add(const Duration(days: 1));
                          }),
                          icon: const Icon(Icons.chevron_right),
                        ),
                        IconButton(
                          tooltip: l10n.pickDate,
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _day,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _day = DateTime(picked.year, picked.month, picked.day);
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: sorted.isEmpty
                        ? EmptyStateView(
                            title: l10n.noSessionsToday,
                            icon: Icons.event_busy_outlined,
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: sorted.length,
                            itemBuilder: (context, index) {
                              final a = sorted[index];
                              final name = patientNames[a.patientId] ?? l10n.unknownPatient;
                              final time = MaterialLocalizations.of(context).formatTimeOfDay(
                                TimeOfDay.fromDateTime(a.scheduledAt.toLocal()),
                                alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
                              );
                              return _SessionCard(
                                name: name,
                                time: time,
                                status: a.status,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PatientDetailsScreen(patientId: a.patientId),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.loadPatientsFailed)),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadTodayAppointmentsFailed)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.invalidate(appointmentsForDayProvider(_day)),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String name;
  final String time;
  final String status;
  final VoidCallback onTap;

  const _SessionCard({
    required this.name,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusText = switch (status) {
      'completed' => l10n.filterCompleted,
      'missed' => l10n.filterMissed,
      'canceled' => l10n.filterCanceled,
      _ => l10n.filterScheduled,
    };
    final statusColor = AppTheme.statusColor(status);
    final statusBg = AppTheme.statusBgColor(status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colored left strip
              Container(
                width: 6,
                height: 72,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Time badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Color(0xFF0B6E8A),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0B6E8A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
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
              const Padding(
                padding: EdgeInsets.only(right: 8, top: 24),
                child: Icon(Icons.chevron_right, color: Color(0xFF90A4AE)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

