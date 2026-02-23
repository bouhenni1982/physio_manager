import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  LocalNotificationService._();

  static final LocalNotificationService _instance =
      LocalNotificationService._();
  factory LocalNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const int _maxAndroidNotificationId = 2147483647;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await init();
  }

  @override
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();

    tz.initializeTimeZones();
    try {
      final Object timezoneObj = await FlutterTimezone.getLocalTimezone();
      final String tzName = timezoneObj is TimezoneInfo
          ? timezoneObj.identifier
          : timezoneObj.toString();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    _initialized = true;
  }

  @override
  Future<void> requestPermissions() async {
    await _ensureInitialized();
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();
  }

  @override
  Future<void> showNow(String title, String body) async {
    await _ensureInitialized();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'physio_manager',
        'Physio Manager',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    try {
      await _plugin.show(
        _toNotificationId('instant_${title}_$body'),
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('Notification showNow failed: $e');
    }
  }

  @override
  Future<void> scheduleReminder(
    String id,
    DateTime when,
    String title,
    String body,
  ) async {
    await _ensureInitialized();
    final scheduled = tz.TZDateTime.from(when, tz.local);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'physio_manager_reminders',
        'Reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    try {
      await _plugin.zonedSchedule(
        _toNotificationId(id),
        title,
        body,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Notification schedule failed: $e');
    }
  }

  @override
  Future<void> cancel(String id) async {
    await _ensureInitialized();
    try {
      await _plugin.cancel(_toNotificationId(id));
    } catch (e) {
      // Workaround for Android cached-scheduled-notifications corruption in some plugin versions.
      debugPrint('Notification cancel failed (ignored): $e');
    }
  }

  int _toNotificationId(String id) {
    var hash = 0;
    for (final codeUnit in id.codeUnits) {
      hash = ((hash * 31) + codeUnit) & 0x7fffffff;
    }
    if (hash == 0) return 1;
    return hash % _maxAndroidNotificationId;
  }
}

