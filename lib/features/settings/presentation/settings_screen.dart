import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/sync_coordinator.dart';
import '../../../core/widgets/app_scaffold.dart';
import 'sync_providers.dart';
import 'notification_settings_provider.dart';
import 'notification_log_screen.dart';
import '../../auth/presentation/change_password_screen.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/session_unlock_provider.dart';
import 'locale_provider.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../dashboard/presentation/dashboard_customize_screen.dart';
import '../../../core/widgets/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final syncEnabled = ref.watch(syncEnabledProvider);
    final lastSync = ref.watch(lastSyncProvider);
    final notifEnabled = ref.watch(notifEnabledProvider);
    final reminderMinutes = ref.watch(reminderMinutesProvider);
    final noteDelay = ref.watch(noteAutoSaveDelayProvider);
    final currentLocale = ref.watch(localeProvider);

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Notifications section ─────────────────────────────────────
          SectionHeader(label: l10n.notificationsEnabledTitle, icon: Icons.notifications_outlined),
          const SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: notifEnabled,
                  onChanged: (v) =>
                      ref.read(notifEnabledProvider.notifier).setEnabled(v),
                  title: Text(l10n.notificationsEnabledTitle),
                  subtitle: Text(l10n.notificationsEnabledSubtitle),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.reminderBeforeAppointment(reminderMinutes)),
                  subtitle: Text('$reminderMinutes ${l10n.minutesUnit}'),
                  trailing: const Icon(Icons.timer),
                  onTap: () async {
                    final selected = await showModalBottomSheet<int>(
                      context: context,
                      builder: (_) => const _ReminderPicker(),
                    );
                    if (selected != null) {
                      await ref
                          .read(reminderMinutesProvider.notifier)
                          .setMinutes(selected);
                    }
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.notificationLogTitle),
                  subtitle: Text(l10n.notificationLogSubtitle),
                  trailing: const Icon(Icons.notifications),
                  onTap: () =>
                      Navigator.pushNamed(context, NotificationLogScreen.routeName),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.noteAutoSaveTitle),
                  subtitle: Text(l10n.noteAutoSaveSubtitle(noteDelay)),
                  trailing: const Icon(Icons.edit_note),
                  onTap: () async {
                    final selected = await showModalBottomSheet<int>(
                      context: context,
                      builder: (_) => const _NoteDelayPicker(),
                    );
                    if (selected != null) {
                      await ref
                          .read(noteAutoSaveDelayProvider.notifier)
                          .setDelayMs(selected);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ── Sync section ──────────────────────────────────────────────
          SectionHeader(label: l10n.syncEnabledTitle, icon: Icons.sync_outlined),
          const SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: syncEnabled,
                  onChanged: (v) async {
                    await ref.read(syncEnabledProvider.notifier).setEnabled(v);
                    await SyncCoordinator.instance.setEnabled(v);
                  },
                  title: Text(l10n.syncEnabledTitle),
                  subtitle: Text(l10n.syncEnabledSubtitle),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                lastSync.when(
                  data: (ms) {
                    final text = ms == 0
                        ? l10n.lastSyncNever
                        : DateTime.fromMillisecondsSinceEpoch(
                            ms,
                          ).toLocal().toString();
                    return ListTile(
                      title: Text(l10n.lastSyncTitle),
                      subtitle: Text(text),
                      trailing: const Icon(Icons.history, color: Color(0xFF90A4AE)),
                    );
                  },
                  loading: () => ListTile(
                    title: Text(l10n.lastSyncTitle),
                    subtitle: Text(l10n.lastSyncLoading),
                  ),
                  error: (e, _) => ListTile(
                    title: Text(l10n.lastSyncTitle),
                    subtitle: Text(l10n.lastSyncUnavailable),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              await SyncCoordinator.instance.syncNow();
              ref.invalidate(lastSyncProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.syncDone)));
              }
            },
            icon: const Icon(Icons.sync),
            label: Text(l10n.syncNow),
          ),
          const SizedBox(height: 20),
          // ── Account section ───────────────────────────────────────────
          SectionHeader(label: l10n.changePasswordMenuTitle, icon: Icons.manage_accounts_outlined),
          const SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.languageTitle),
                  subtitle: Text(_localeLabel(currentLocale, l10n)),
                  trailing: const Icon(Icons.language),
                  onTap: () async {
                    final selected = await showModalBottomSheet<Locale?>(
                      context: context,
                      builder: (_) =>
                          _LocalePicker(currentLocale: currentLocale, l10n: l10n),
                    );
                    if (selected != null || currentLocale != selected) {
                      await ref.read(localeProvider.notifier).setLocale(selected);
                    }
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.changePasswordMenuTitle),
                  subtitle: Text(l10n.changePasswordMenuSubtitle),
                  trailing: const Icon(Icons.lock),
                  onTap: () =>
                      Navigator.pushNamed(context, ChangePasswordScreen.routeName),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.dashboardCustomizeTitle),
                  subtitle: Text(l10n.dashboardCustomizeSubtitle),
                  trailing: const Icon(Icons.dashboard_customize),
                  onTap: () => Navigator.pushNamed(
                    context,
                    DashboardCustomizeScreen.routeName,
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.logout),
                  subtitle: Text(l10n.logoutSubtitle),
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    await ref.read(authRepositoryProvider).signOut();
                    ref.read(sessionUnlockProvider.notifier).lock();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.routeName,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _LocalePicker extends StatelessWidget {
  final Locale? currentLocale;
  final AppLocalizations l10n;

  const _LocalePicker({required this.currentLocale, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final options = <Locale?>[
      const Locale('ar', 'DZ'),
      const Locale('fr', 'FR'),
      const Locale('en', 'US'),
    ];
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(l10n.chooseLanguage)),
          for (final locale in options)
            ListTile(
              title: Text(_localeLabel(locale, l10n)),
              trailing: locale == currentLocale
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.pop(context, locale),
            ),
          ListTile(
            title: Text(l10n.useDeviceLanguage),
            onTap: () => Navigator.pop(context, null),
          ),
        ],
      ),
    );
  }
}

String _localeLabel(Locale? locale, AppLocalizations l10n) {
  if (locale == null) return l10n.useDeviceLanguage;
  return switch (locale.languageCode) {
    'ar' => l10n.langArabic,
    'fr' => l10n.langFrench,
    'en' => l10n.langEnglish,
    _ => locale.languageCode,
  };
}

class _ReminderPicker extends StatelessWidget {
  const _ReminderPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const options = [5, 10, 15, 30, 60, 120];
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(l10n.chooseReminder)),
          for (final m in options)
            ListTile(
              title: Text('$m ${l10n.minutesUnit}'),
              onTap: () => Navigator.pop(context, m),
            ),
        ],
      ),
    );
  }
}

class _NoteDelayPicker extends StatelessWidget {
  const _NoteDelayPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const options = [300, 500, 800, 1200, 2000];
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(l10n.chooseNoteDelay)),
          for (final ms in options)
            ListTile(
              title: Text('$ms ${l10n.millisecondsUnit}'),
              onTap: () => Navigator.pop(context, ms),
            ),
        ],
      ),
    );
  }
}
