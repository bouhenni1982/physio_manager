import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import 'therapist_providers.dart';

class AdminInviteScreen extends ConsumerStatefulWidget {
  static const String routeName = '/therapists/invite';

  const AdminInviteScreen({super.key});

  @override
  ConsumerState<AdminInviteScreen> createState() => _AdminInviteScreenState();
}

class _AdminInviteScreenState extends ConsumerState<AdminInviteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: l10n.inviteTherapistTitle,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _fullName,
              decoration: InputDecoration(labelText: l10n.fullNameLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l10n.phoneLabel),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.emailLabel),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return l10n.emailRequired;
                if (!value.contains('@')) return l10n.invalidEmail;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.tempPasswordLabel),
              validator: (v) {
                final value = v ?? '';
                if (value.length < 8) {
                  return l10n.tempPasswordMin;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving
                  ? null
                  : () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      setState(() => _saving = true);
                      try {
                        await ref
                            .read(adminInviteServiceProvider)
                            .inviteTherapist(
                              fullName: _fullName.text,
                              phone: _phone.text,
                              email: _email.text,
                              password: _password.text,
                            );
                        ref.invalidate(therapistsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.createTherapistSuccess),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_mapInviteError(e, l10n))),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _saving = false);
                        }
                      }
                    },
              icon: const Icon(Icons.person_add),
              label: Text(_saving ? l10n.creating : l10n.createTherapist),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.inviteNote,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

String _mapInviteError(Object e, AppLocalizations l10n) {
  final raw = e.toString();
  if (raw.contains('forbidden_only_admin')) {
    return l10n.inviteNoPermission;
  }
  if (raw.contains('missing_service_role_key_secret')) {
    return l10n.inviteServerKeyMissing;
  }
  if (raw.contains('missing_auth') || raw.contains('unauthorized')) {
    return l10n.inviteSessionExpired;
  }
  if (raw.contains('invalid_payload')) {
    return l10n.inviteInvalidPayload;
  }
  if (raw.contains('create_user_failed')) {
    return l10n.inviteCreateFailed;
  }
  if (raw.toLowerCase().contains('user already registered') ||
      raw.toLowerCase().contains('already') ||
      raw.toLowerCase().contains('email')) {
    return l10n.inviteEmailUsed;
  }
  return l10n.inviteFailed(raw);
}
