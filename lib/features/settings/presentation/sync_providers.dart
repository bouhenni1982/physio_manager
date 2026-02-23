import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/sync_coordinator.dart';

class SyncEnabledNotifier extends StateNotifier<bool> {
  SyncEnabledNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('sync_enabled') ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sync_enabled', enabled);
    state = enabled;
  }
}

final syncEnabledProvider = StateNotifierProvider<SyncEnabledNotifier, bool>((ref) {
  return SyncEnabledNotifier();
});

final lastSyncProvider = FutureProvider<int>((ref) async {
  return SyncCoordinator.instance.getLastSyncMs();
});
