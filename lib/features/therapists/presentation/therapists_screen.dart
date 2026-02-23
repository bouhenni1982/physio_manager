import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/utils/phone_launcher.dart';
import '../../auth/presentation/auth_providers.dart';
import 'admin_invite_screen.dart';
import 'therapist_providers.dart';
import 'therapist_form_screen.dart';

class TherapistsScreen extends ConsumerWidget {
  static const String routeName = '/therapists';

  const TherapistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(therapistsProvider);
    return AppScaffold(
      title: l10n.therapistsTitle,
      body: data.when(
        data: (items) {
          final adminCount = items.where((e) => e.isPrimary).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminInviteScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addTherapist),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...items.map((item) {
                final initials = item.fullName
                    .trim()
                    .split(' ')
                    .where((w) => w.isNotEmpty)
                    .take(2)
                    .map((w) => w[0].toUpperCase())
                    .join();
                final roleColor = item.isPrimary
                    ? const Color(0xFF0B6E8A)
                    : const Color(0xFF2BBFA4);
                final roleBg = item.isPrimary
                    ? const Color(0xFFE0F2F8)
                    : const Color(0xFFE0FAF6);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TherapistFormScreen(therapist: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                roleColor.withValues(alpha: 0.15),
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: roleColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fullName,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: roleBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    item.isPrimary
                                        ? l10n.primary
                                        : l10n.therapist,
                                    style: TextStyle(
                                      color: roleColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if ((item.phone ?? '').trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.phoneValue(item.phone!),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone_outlined),
                            tooltip: l10n.callTherapist,
                            onPressed: (item.phone ?? '').trim().isEmpty
                                ? null
                                : () async {
                                    final ok = await launchPhone(item.phone!);
                                    if (!ok && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.callFailed)),
                                      );
                                    }
                                  },
                          ),
                          // Admin toggle icon
                          IconButton(
                            icon: Icon(
                              item.isPrimary
                                  ? Icons.admin_panel_settings
                                  : Icons.verified_user_outlined,
                              color: item.isPrimary
                                  ? const Color(0xFF0B6E8A)
                                  : Colors.grey,
                            ),
                            tooltip: item.isPrimary
                                ? l10n.removeAdmin
                                : l10n.makeAdmin,
                            onPressed: () async {
                              final makeAdmin = !item.isPrimary;
                              if (makeAdmin && adminCount >= 2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.maxAdmins)),
                                );
                                return;
                              }
                              if (!makeAdmin && adminCount <= 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.minOneAdmin)),
                                );
                                return;
                              }
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    makeAdmin
                                        ? l10n.makeAdmin
                                        : l10n.removeAdmin,
                                  ),
                                  content: Text(
                                    makeAdmin
                                        ? l10n.confirmMakeAdmin(item.fullName)
                                        : l10n.confirmRemoveAdmin(item.fullName),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(l10n.confirm),
                                    ),
                                  ],
                                ),
                              );
                              if (ok != true) return;
                              try {
                                await ref
                                    .read(therapistRepositoryProvider)
                                    .setAdmin(item.id, makeAdmin);
                                ref.invalidate(therapistsProvider);
                                ref.invalidate(currentUserRoleProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        makeAdmin
                                            ? l10n.adminGranted(item.fullName)
                                            : l10n.adminRemoved(item.fullName),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.updateAdminFailed(e.toString()),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          // Delete icon
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent, size: 20),
                            onPressed: () async {
                              await ref
                                  .read(therapistRepositoryProvider)
                                  .delete(item.id);
                              ref.invalidate(therapistsProvider);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadTherapistsFailed)),
      ),
      floatingActionButton: null,
    );
  }
}
