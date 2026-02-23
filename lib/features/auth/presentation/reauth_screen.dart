import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/debug/network_error.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_action_bar.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import 'auth_providers.dart';
import 'session_unlock_provider.dart';

class ReauthScreen extends ConsumerStatefulWidget {
  static const String routeName = '/reauth';

  const ReauthScreen({super.key});

  @override
  ConsumerState<ReauthScreen> createState() => _ReauthScreenState();
}

class _ReauthScreenState extends ConsumerState<ReauthScreen> {
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (_loading) return;
    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null || email.isEmpty) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(email, _password.text);
      ref.read(sessionUnlockProvider.notifier).unlock();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
    } catch (e) {
      if (!mounted) return;
      final msg = isNetworkError(e)
          ? l10n.reauthNeedsInternet
          : l10n.invalidCredentials;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final email = Supabase.instance.client.auth.currentUser?.email ?? '-';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF073B4C), Color(0xFF0B6E8A), Color(0xFF2BBFA4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.reauthTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.reauthSubtitle(email),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _submit(l10n),
                    ),
                    const SizedBox(height: 16),
                    PrimaryActionBar(
                      loading: _loading,
                      label: l10n.reauthButton,
                      onPressed: () => _submit(l10n),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
