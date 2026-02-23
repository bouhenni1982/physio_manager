import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import 'notification_log_providers.dart';

class NotificationLogScreen extends ConsumerWidget {
  static const String routeName = '/settings/notifications/log';

  const NotificationLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final logs = ref.watch(notificationLogProvider);
    return AppScaffold(
      title: l10n.notificationLogTitle,
      body: logs.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.notificationLogEmpty));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final ts = (item['created_at'] as int?) ?? 0;
              final time = DateTime.fromMillisecondsSinceEpoch(ts).toLocal();
              return ListTile(
                title: Text(item['title'] as String? ?? ''),
                subtitle: Text(item['body'] as String? ?? ''),
                trailing: Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.notificationLogLoadFailed)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final service = ref.read(notificationLogServiceProvider);
          await service.clearAll();
          ref.invalidate(notificationLogProvider);
        },
        icon: const Icon(Icons.delete),
        label: Text(l10n.clearAll),
      ),
    );
  }
}
