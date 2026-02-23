import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/therapist.dart';
import 'therapist_providers.dart';

class TherapistFormScreen extends ConsumerStatefulWidget {
  static const String routeName = '/therapists/form';

  final Therapist? therapist;

  const TherapistFormScreen({super.key, this.therapist});

  @override
  ConsumerState<TherapistFormScreen> createState() =>
      _TherapistFormScreenState();
}

class _TherapistFormScreenState extends ConsumerState<TherapistFormScreen> {
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _userId = TextEditingController();
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    final t = widget.therapist;
    if (t != null) {
      _fullName.text = t.fullName;
      _phone.text = t.phone ?? '';
      _userId.text = t.userId;
      _isPrimary = t.isPrimary;
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _userId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.therapist != null;
    return AppScaffold(
      title: isEdit ? l10n.therapistFormTitleEdit : l10n.therapistFormTitleAdd,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _fullName,
            decoration: InputDecoration(labelText: l10n.fullNameLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.phoneLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _userId,
            decoration: InputDecoration(labelText: l10n.userIdLabel),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _isPrimary,
            onChanged: (v) => setState(() => _isPrimary = v),
            title: Text(l10n.adminRoleLabel),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(therapistRepositoryProvider);
              final all = await ref.read(therapistsProvider.future);
              final adminCount = all.where((t) => t.isPrimary).length;
              final id = widget.therapist?.id ?? const Uuid().v4();
              final wasPrimary = widget.therapist?.isPrimary ?? false;
              if (!wasPrimary && _isPrimary && adminCount >= 2) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.maxAdmins)));
                }
                return;
              }
              if (wasPrimary && !_isPrimary && adminCount <= 1) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.minOneAdmin)));
                }
                return;
              }
              final therapist = Therapist(
                id: id,
                userId: _userId.text.trim(),
                fullName: _fullName.text.trim(),
                phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
                isPrimary: _isPrimary,
              );
              if (isEdit) {
                await repo.update(therapist);
              } else {
                await repo.create(therapist);
              }
              if (_isPrimary != wasPrimary) {
                await repo.setAdmin(id, _isPrimary);
              }
              ref.invalidate(therapistsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
