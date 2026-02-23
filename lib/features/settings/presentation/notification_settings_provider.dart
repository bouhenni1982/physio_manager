import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifEnabledNotifier extends StateNotifier<bool> {
  NotifEnabledNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('notif_enabled') ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', enabled);
    state = enabled;
  }
}

class ReminderMinutesNotifier extends StateNotifier<int> {
  ReminderMinutesNotifier() : super(30) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('reminder_minutes') ?? 30;
  }

  Future<void> setMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_minutes', minutes);
    state = minutes;
  }
}

final notifEnabledProvider = StateNotifierProvider<NotifEnabledNotifier, bool>((ref) {
  return NotifEnabledNotifier();
});

final reminderMinutesProvider = StateNotifierProvider<ReminderMinutesNotifier, int>((ref) {
  return ReminderMinutesNotifier();
});

class NoteAutoSaveDelayNotifier extends StateNotifier<int> {
  NoteAutoSaveDelayNotifier() : super(800) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('note_autosave_ms') ?? 800;
  }

  Future<void> setDelayMs(int ms) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('note_autosave_ms', ms);
    state = ms;
  }
}

final noteAutoSaveDelayProvider =
    StateNotifierProvider<NoteAutoSaveDelayNotifier, int>((ref) {
  return NoteAutoSaveDelayNotifier();
});
