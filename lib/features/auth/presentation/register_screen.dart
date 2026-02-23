import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import 'auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: l10n.registerTitle,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _fullName,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.fullNameLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.emailLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.passwordLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.confirmPasswordLabel),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (_password.text != _confirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.passwordsNotMatch)),
                    );
                    return;
                  }
                  try {
                    await ref
                        .read(authRepositoryProvider)
                        .signUp(_fullName.text.trim(), _email.text.trim(), _password.text);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.accountCreated)),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      final msg = _mapSignUpError(l10n, e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                      if (msg == l10n.signUpConfirmEmail) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text(l10n.registerButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _mapSignUpError(AppLocalizations l10n, Object e) {
  final m = e.toString().toLowerCase();
  if (m.contains('signup_requires_email_confirmation')) {
    return l10n.signUpConfirmEmail;
  }
  if (m.contains('database error saving new user')) {
    return l10n.signUpAuthSaveFailed;
  }
  if (m.contains('email rate limit exceeded')) {
    return l10n.signUpRateLimit;
  }
  if (m.contains('email not confirmed')) {
    return l10n.signUpEmailNotConfirmed;
  }
  if (m.contains('invalid api key')) {
    return l10n.signUpInvalidApiKey;
  }
  if (m.contains('user already registered') || m.contains('already registered')) {
    return l10n.signUpEmailUsed;
  }
  if (m.contains('invalid email')) {
    return l10n.signUpInvalidEmail;
  }
  if (m.contains('password')) {
    return l10n.signUpPasswordInvalid;
  }
  return l10n.signUpFailed(_compactError(e.toString()));
}

String _compactError(String raw) {
  final oneLine = raw.replaceAll('\n', ' ').trim();
  if (oneLine.length <= 140) return oneLine;
  return '${oneLine.substring(0, 140)}...';
}

