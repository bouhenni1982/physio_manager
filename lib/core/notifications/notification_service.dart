abstract class NotificationService {
  Future<void> init();
  Future<void> requestPermissions();
  Future<void> scheduleReminder(String id, DateTime when, String title, String body);
  Future<void> showNow(String title, String body);
  Future<void> cancel(String id);
}
