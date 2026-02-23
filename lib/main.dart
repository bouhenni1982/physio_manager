import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/config/env.dart';
import 'core/network/sync_coordinator.dart';
import 'core/storage/local_db_instance.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/notifications/notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/debug/error_reporter.dart';
import 'core/network/connectivity_state.dart';
import 'core/debug/network_error.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    container.read(errorReporterProvider.notifier).report(details.exception);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    container.read(errorReporterProvider.notifier).report(error);
    return true;
  };

  runApp(UncontrolledProviderScope(
    container: container,
    child: const PhysioApp(),
  ));

  unawaited(_bootstrap(container));
}

Future<void> _bootstrap(ProviderContainer container) async {
  try {
    container.read(connectivityStatusProvider.notifier).setState(ConnectivityState.syncing);
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    final db = appLocalDb;
    NotificationScheduler.instance.init(db);
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('sync_enabled') ?? true;
    await SyncCoordinator.instance.init(db, enabled: enabled, container: container);

    final localNotifications = LocalNotificationService();
    await localNotifications.init();
  } catch (e) {
    container.read(errorReporterProvider.notifier).report(e);
    if (isNetworkError(e)) {
      container.read(connectivityStatusProvider.notifier).setState(ConnectivityState.offline);
    } else {
      // Non-network bootstrap errors should not show the app as offline.
      container.read(connectivityStatusProvider.notifier).setState(ConnectivityState.online);
    }
  }
}
