import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../storage/local_db.dart';
import 'local_notification_service.dart';
import 'notification_log_service.dart';

class NotificationScheduler {
  NotificationScheduler._();

  static final NotificationScheduler instance = NotificationScheduler._();

  final LocalNotificationService _local = LocalNotificationService();
  final NotificationLogService _log = NotificationLogService();
  bool _initialized = false;
  LocalDbService? _db;

  void init(LocalDbService db) {
    _db = db;
  }

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _local.init();
    _initialized = true;
  }

  Future<void> scheduleForAppointmentRow(Map<String, dynamic> row) async {
    final l10n = await _l10n();
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? true;
    if (!enabled) return;

    final minutes = prefs.getInt('reminder_minutes') ?? 30;
    final scheduledAt = _parseScheduledAt(row['scheduled_at']);
    if (scheduledAt == null) return;

    final remindAt = scheduledAt.subtract(Duration(minutes: minutes));
    if (remindAt.isBefore(DateTime.now())) return;

    await _ensureInit();
    final id = row['id'] as String?;
    if (id == null || id.isEmpty) return;

    final patientName = await _lookupPatientName(row['patient_id'] as String?);
    await _local.scheduleReminder(
      id,
      remindAt,
      l10n.reminderTitle,
      _formatBody(l10n, patientName, scheduledAt, minutes),
    );
    await _log.log(
      l10n.reminderTitle,
      _formatBody(l10n, patientName, scheduledAt, minutes),
    );
  }

  Future<void> cancelById(String id) async {
    if (id.isEmpty) return;
    await _ensureInit();
    await _local.cancel(id);
  }

  Future<void> showSyncComplete() async {
    final l10n = await _l10n();
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? true;
    if (!enabled) return;
    await _ensureInit();
    await _local.showNow(l10n.syncCompleteTitle, l10n.syncCompleteBody);
    await _log.log(l10n.syncCompleteTitle, l10n.syncCompleteBody);
  }

  DateTime? _parseScheduledAt(Object? value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Future<String?> _lookupPatientName(String? patientId) async {
    if (patientId == null || patientId.isEmpty) return null;
    final db = _db;
    if (db == null) return null;
    await db.init();
    final rows = await db.queryWhere(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['full_name'] as String?;
  }

  Future<AppLocalizations> _l10n() async {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return AppLocalizations.delegate.load(locale);
  }

  String _formatBody(
    AppLocalizations l10n,
    String? patientName,
    DateTime scheduledAt,
    int minutes,
  ) {
    final time =
        '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';
    if (patientName == null || patientName.isEmpty) {
      return l10n.reminderBodyNoName(time, minutes);
    }
    return l10n.reminderBodyWithName(patientName, time, minutes);
  }
}
