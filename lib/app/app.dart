import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../core/debug/error_reporter.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/reauth_screen.dart';
import '../features/auth/presentation/session_unlock_provider.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/settings/presentation/locale_provider.dart';

class PhysioApp extends ConsumerWidget {
  const PhysioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(errorReporterProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'physio_manager',
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const _AuthGate(),
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      builder: (context, child) {
        if (error == null) return child ?? const SizedBox.shrink();
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            ref.read(errorReporterProvider.notifier).clear(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final unlockState = ref.watch(sessionUnlockProvider);
    return authState.when(
      data: (user) {
        if (user == null) return const LoginScreen();
        if (unlockState == SessionUnlockState.locked) {
          return const ReauthScreen();
        }
        return const DashboardScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const LoginScreen(),
    );
  }
}
