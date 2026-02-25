import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/utils/phone_launcher.dart';
import '../../therapists/presentation/therapist_providers.dart';
import 'patient_details_screen.dart';
import 'patient_providers.dart';
import 'patient_form_screen.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/patients';

  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  final _search = TextEditingController();
  final _diagnosisFilter = TextEditingController();
  final _doctorFilter = TextEditingController();
  String _genderFilter = 'all';
  String _statusFilter = 'all';

  @override
  void dispose() {
    _search.dispose();
    _diagnosisFilter.dispose();
    _doctorFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patientsData = ref.watch(patientsProvider);
    final therapistsData = ref.watch(therapistsProvider);

    return AppScaffold(
      title: l10n.patientsTitle,
      body: patientsData.when(
        data: (items) {
          final therapistNames = therapistsData.valueOrNull == null
              ? <String, String>{}
              : {
                  for (final t in therapistsData.value!) t.id: t.fullName,
                };

          final query = _search.text.trim().toLowerCase();
          final filtered = items.where((p) {
            if (_genderFilter != 'all' && p.gender != _genderFilter) return false;
            if (_statusFilter == 'active' && p.status != 'active') return false;
            if (_statusFilter == 'completed' && p.status != 'completed') {
              return false;
            }
            final diagnosis = (p.diagnosis ?? '').toLowerCase();
            final doctor = (p.doctorName ?? '').toLowerCase();
            final matchesQuery = query.isEmpty ||
                p.fullName.toLowerCase().contains(query) ||
                diagnosis.contains(query) ||
                doctor.contains(query);
            if (!matchesQuery) return false;
            final diagFilter = _diagnosisFilter.text.trim().toLowerCase();
            if (diagFilter.isNotEmpty && !diagnosis.contains(diagFilter)) {
              return false;
            }
            final docFilter = _doctorFilter.text.trim().toLowerCase();
            if (docFilter.isNotEmpty && !doctor.contains(docFilter)) {
              return false;
            }
            return true;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(patientsProvider);
              ref.invalidate(therapistsProvider);
              await ref.read(patientsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.patientSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _search.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(l10n.advancedFilters),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _statusFilter,
                            items: [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text(l10n.filterAll),
                              ),
                              DropdownMenuItem(
                                value: 'not_started',
                                child: Text(l10n.statusNotStarted),
                              ),
                              DropdownMenuItem(
                                value: 'active',
                                child: Text(l10n.currentlyTreating),
                              ),
                              DropdownMenuItem(
                                value: 'completed',
                                child: Text(l10n.finishedTreatment),
                              ),
                              DropdownMenuItem(
                                value: 'suspended',
                                child: Text(l10n.statusSuspended),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _statusFilter = v ?? 'all'),
                            decoration: InputDecoration(
                              labelText: l10n.patientStatusLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _diagnosisFilter,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.diagnosisFilterLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _doctorFilter,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.doctorFilterLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _GenderChip(
                      label: l10n.filterAll,
                      selected: _genderFilter == 'all',
                      onTap: () => setState(() => _genderFilter = 'all'),
                    ),
                    _GenderChip(
                      label: l10n.filterMale,
                      selected: _genderFilter == 'male',
                      onTap: () => setState(() => _genderFilter = 'male'),
                    ),
                    _GenderChip(
                      label: l10n.filterFemale,
                      selected: _genderFilter == 'female',
                      onTap: () => setState(() => _genderFilter = 'female'),
                    ),
                    _GenderChip(
                      label: l10n.filterChild,
                      selected: _genderFilter == 'child',
                      onTap: () => setState(() => _genderFilter = 'child'),
                    ),
                    _GenderChip(
                      label: l10n.currentlyTreating,
                      selected: _statusFilter == 'active',
                      onTap: () => setState(() => _statusFilter = 'active'),
                    ),
                    _GenderChip(
                      label: l10n.finishedTreatment,
                      selected: _statusFilter == 'completed',
                      onTap: () => setState(() => _statusFilter = 'completed'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  EmptyStateView(
                    title: l10n.noResults,
                    icon: Icons.manage_search,
                  ),
                ...filtered.map(
                  (item) {
                    final initials = item.fullName
                        .trim()
                        .split(' ')
                        .where((w) => w.isNotEmpty)
                        .take(2)
                        .map((w) => w[0].toUpperCase())
                        .join();
                    final statusLabel = switch (item.status) {
                      'not_started' => l10n.statusNotStarted,
                      'active' => l10n.statusActive,
                      'completed' => l10n.statusCompleted,
                      'suspended' => l10n.statusSuspended,
                      _ => item.status,
                    };
                    final statusColor = switch (item.status) {
                      'not_started' => const Color(0xFF6D4C41),
                      'active' => const Color(0xFF2E7D32),
                      'completed' => const Color(0xFF0B6E8A),
                      'suspended' => const Color(0xFFC62828),
                      _ => Colors.grey,
                    };
                    final statusBg = switch (item.status) {
                      'not_started' => const Color(0xFFEFEBE9),
                      'active' => const Color(0xFFE8F5E9),
                      'completed' => const Color(0xFFE0F2F8),
                      'suspended' => const Color(0xFFFFEBEE),
                      _ => Colors.grey.shade100,
                    };
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PatientDetailsScreen(patientId: item.id),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    const Color(0xFF0B6E8A).withValues(alpha: 0.15),
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Color(0xFF0B6E8A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.patientAgeDiagnosis(
                                        item.age?.toString() ?? '-',
                                        item.diagnosis ?? '-',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.patientTherapist(
                                        therapistNames[item.therapistId] ?? '-',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if ((item.phone ?? '').trim().isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.phoneValue(item.phone!),
                                        style: Theme.of(context).textTheme.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Status chip + actions column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  StatusChip(
                                    text: statusLabel,
                                    status: 'scheduled',
                                    foregroundColor: statusColor,
                                    backgroundColor: statusBg,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.phone_outlined,
                                            size: 18),
                                        tooltip: l10n.callPatient,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        onPressed: (item.phone ?? '').trim().isEmpty
                                            ? null
                                            : () async {
                                                final ok = await launchPhone(
                                                  item.phone!,
                                                );
                                                if (!ok && context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        l10n.callFailed,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined,
                                            size: 18),
                                        tooltip: l10n.edit,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PatientFormScreen(
                                                      patient: item),
                                            ),
                                          );
                                          ref.invalidate(patientsProvider);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                            color: Colors.redAccent),
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        onPressed: () =>
                                            _confirmDelete(item.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadPatientsFailed)),
      ),
      floatingActionButton: Semantics(
        button: true,
        label: l10n.patientFormTitleAdd,
        child: FloatingActionButton.extended(
          tooltip: l10n.patientFormTitleAdd,
          onPressed: () =>
              Navigator.pushNamed(context, PatientFormScreen.routeName),
          icon: const Icon(Icons.person_add),
          label: Text(l10n.patientFormTitleAdd),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(String id) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePatientTitle),
        content: Text(l10n.deletePatientConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (ok != true) return;
    await ref.read(patientRepositoryProvider).delete(id);
    ref.invalidate(patientsProvider);
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

