import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/notifications/notification_log_service.dart';

final notificationLogServiceProvider = Provider<NotificationLogService>((ref) {
  return NotificationLogService();
});

final notificationLogProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(notificationLogServiceProvider);
  return service.list();
});
