import '../storage/local_db.dart';
import 'realtime_service.dart';
import 'sync_manager.dart';
import '../debug/network_error.dart';
import 'connectivity_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class SyncCoordinator {
  SyncCoordinator._();

  static final SyncCoordinator instance = SyncCoordinator._();

  SyncManager? _sync;
  RealtimeService? _realtime;
  bool _enabled = true;
  bool _realtimeStarted = false;
  ProviderContainer? _container;

  Future<void> init(
    LocalDbService db, {
    bool enabled = true,
    ProviderContainer? container,
  }) async {
    _enabled = enabled;
    _sync = SyncManager(db);
    _realtime = RealtimeService(db);
    _container = container;
    if (_enabled) {
      await _runWithRetry();
      _sync!.startPeriodic(interval: const Duration(minutes: 5));
      await _startRealtimeIfOnline();
    } else {
      _setStatus(ConnectivityState.online);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    if (_sync == null || _realtime == null) return;
    if (enabled) {
      await _runWithRetry();
      _sync!.startPeriodic(interval: const Duration(minutes: 5));
      await _startRealtimeIfOnline();
    } else {
      _sync!.dispose();
      _realtime!.dispose();
    }
  }

  Future<void> syncNow() async {
    if (_sync == null) return;
    await _runWithRetry();
  }

  Future<int> getLastSyncMs() async {
    if (_sync == null) return 0;
    return _sync!.getLastSyncMs();
  }

  Future<void> _runWithRetry() async {
    if (_sync == null) return;
    _setStatus(ConnectivityState.syncing);
    const delays = [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)];
    for (var i = 0; i <= delays.length; i++) {
      try {
        await _sync!.syncAll();
        _setStatus(ConnectivityState.online);
        return;
      } catch (e) {
        if (isNetworkError(e)) {
          _setStatus(ConnectivityState.offline);
          if (i < delays.length) {
            await Future.delayed(delays[i]);
            continue;
          }
          return;
        }
        // Non-network sync errors must not force offline mode or block the app.
        _setStatus(ConnectivityState.online);
        return;
      }
    }
  }

  Future<void> _startRealtimeIfOnline() async {
    if (_realtimeStarted || _realtime == null) return;
    if (_container == null) return;
    final status = _container!.read(connectivityStatusProvider);
    if (status != ConnectivityState.online) return;
    try {
      await _realtime!.start();
      _realtimeStarted = true;
    } catch (e) {
      if (isNetworkError(e)) {
        _setStatus(ConnectivityState.offline);
      } else {
        // Realtime failures unrelated to network must not force offline UX.
        _setStatus(ConnectivityState.online);
      }
    }
  }

  void _setStatus(ConnectivityState state) {
    final container = _container;
    if (container == null) return;
    container.read(connectivityStatusProvider.notifier).setState(state);
  }
}
