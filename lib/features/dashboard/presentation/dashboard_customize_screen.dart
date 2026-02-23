import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/widgets/app_scaffold.dart';
import 'dashboard_tabs_prefs.dart';

class DashboardCustomizeScreen extends ConsumerWidget {
  static const routeName = '/dashboard/customize';

  const DashboardCustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return AppScaffold(
        title: l10n.dashboardCustomizeTitle,
        body: const SizedBox.shrink(),
      );
    }
    final prefs = ref.watch(dashboardTabsProvider(user.id));
    final notifier = ref.read(dashboardTabsProvider(user.id).notifier);
    final defaults = <String>[
      'today',
      'appointments',
      'patients',
      'therapists',
      'stats',
      'settings',
    ];
    final visible = (prefs.order.isEmpty ? defaults : prefs.order)
        .where(defaults.contains)
        .toList();
    for (final id in defaults) {
      if (!visible.contains(id)) visible.add(id);
    }

    return AppScaffold(
      title: l10n.dashboardCustomizeTitle,
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: visible.length,
        onReorder: (oldIndex, newIndex) async {
          if (newIndex > oldIndex) newIndex -= 1;
          final next = visible.toList();
          final item = next.removeAt(oldIndex);
          next.insert(newIndex, item);
          await notifier.setOrder(next);
        },
        itemBuilder: (context, index) {
          final id = visible[index];
          final isHidden = prefs.hidden.contains(id);
          return Card(
            key: ValueKey(id),
            child: SwitchListTile(
              value: !isHidden,
              onChanged: (v) async => notifier.setHidden(id, !v),
              title: Text(_labelFor(id, l10n)),
              secondary: const Icon(Icons.drag_indicator),
            ),
          );
        },
      ),
    );
  }

  String _labelFor(String id, AppLocalizations l10n) {
    return switch (id) {
      'today' => l10n.dashboardToday,
      'appointments' => l10n.dashboardAppointments,
      'patients' => l10n.dashboardPatients,
      'therapists' => l10n.dashboardTherapists,
      'stats' => l10n.dashboardStats,
      'settings' => l10n.dashboardSettings,
      _ => id,
    };
  }
}

