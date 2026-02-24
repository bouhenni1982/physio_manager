import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:physio_manager/l10n/generated/app_localizations.dart';
import '../../../core/constants/role.dart';
import '../../../core/storage/autocomplete_repository.dart';
import '../../../core/storage/autocomplete_providers.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../appointments/domain/appointment.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../therapists/presentation/therapist_providers.dart';
import '../domain/patient.dart';
import 'patient_providers.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  static const String routeName = '/patients/form';

  final Patient? patient;

  const PatientFormScreen({super.key, this.patient});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _age = TextEditingController();
  final _diagnosis = TextEditingController();
  final _medicalHistory = TextEditingController();
  final _suggestedSessions = TextEditingController();
  final _doctorName = TextEditingController();
  final _phone = TextEditingController();

  String? _therapistId;
  String _gender = 'male';
  String _status = 'active';
  bool _isSaving = false;
  bool _createInitialAppointment = true;
  DateTime _initialAppointmentAt = DateTime.now().add(const Duration(hours: 1));
  String? _prescriptionImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    if (p != null) {
      _fullName.text = p.fullName;
      _age.text = p.age?.toString() ?? '';
      _diagnosis.text = p.diagnosis ?? '';
      _medicalHistory.text = p.medicalHistory ?? '';
      _suggestedSessions.text = p.suggestedSessions?.toString() ?? '';
      _doctorName.text = p.doctorName ?? '';
      _phone.text = p.phone ?? '';
      _therapistId = p.therapistId;
      _gender = p.gender;
      _status = p.status;
      _prescriptionImagePath = p.prescriptionImagePath;
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _age.dispose();
    _diagnosis.dispose();
    _medicalHistory.dispose();
    _suggestedSessions.dispose();
    _doctorName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickPrescriptionImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final ext = p.extension(image.path).isEmpty
        ? '.jpg'
        : p.extension(image.path);
    final filename = 'rx_${const Uuid().v4()}$ext';
    final dest = File(p.join(dir.path, filename));
    await File(image.path).copy(dest.path);
    if (!mounted) return;
    setState(() => _prescriptionImagePath = dest.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.patient != null;
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final isAdmin = currentUser?.role == UserRole.admin.value;

    return AppScaffold(
      title: isEdit ? l10n.patientFormTitleEdit : l10n.patientFormTitleAdd,
      body: ref
          .watch(therapistsProvider)
          .when(
            data: (therapists) {
              if (therapists.isEmpty && !isAdmin) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.noTherapistsYet),
                  ),
                );
              }

              if (_therapistId == null) {
                String? myTherapistId;
                if (currentUser != null) {
                  for (final t in therapists) {
                    if (t.userId == currentUser.id) {
                      myTherapistId = t.id;
                      break;
                    }
                  }
                }
                _therapistId = myTherapistId ?? (isAdmin ? null : therapists.first.id);
              } else if (!isAdmin && currentUser != null) {
                for (final t in therapists) {
                  if (t.userId == currentUser.id) {
                    _therapistId = t.id;
                    break;
                  }
                }
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _fullName,
                      decoration: InputDecoration(labelText: l10n.fullNameLabel),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return l10n.fullNameRequired;
                        if (value.length < 3) return l10n.nameTooShort;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.phoneLabel),
                    ),
                    const SizedBox(height: 12),
                    _AutoTextField(
                      label: l10n.ageLabel,
                      controller: _age,
                      type: 'age',
                      keyboardType: TextInputType.number,
                      repo: ref.read(autocompleteRepositoryProvider),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return null;
                        final age = int.tryParse(value);
                        if (age == null) return l10n.ageMustBeNumber;
                        if (age < 0 || age > 120) return l10n.ageInvalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      items: [
                        DropdownMenuItem(value: 'male', child: Text(l10n.filterMale)),
                        DropdownMenuItem(value: 'female', child: Text(l10n.filterFemale)),
                        DropdownMenuItem(value: 'child', child: Text(l10n.filterChild)),
                      ],
                      onChanged: _isSaving
                          ? null
                          : (v) => setState(() => _gender = v ?? 'male'),
                      decoration: InputDecoration(labelText: l10n.genderLabel),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      items: [
                        DropdownMenuItem(
                          value: 'active',
                          child: Text(l10n.statusActive),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text(l10n.statusCompleted),
                        ),
                        DropdownMenuItem(
                          value: 'suspended',
                          child: Text(l10n.statusSuspended),
                        ),
                      ],
                      onChanged: _isSaving
                          ? null
                          : (v) => setState(() => _status = v ?? 'active'),
                      decoration: InputDecoration(
                        labelText: l10n.patientStatusLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AutoTextField(
                      label: l10n.diagnosisLabel,
                      controller: _diagnosis,
                      type: 'diagnosis',
                      repo: ref.read(autocompleteRepositoryProvider),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _medicalHistory,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: l10n.medicalHistoryLabel),
                    ),
                    const SizedBox(height: 12),
                    _PrescriptionImageField(
                      imagePath: _prescriptionImagePath,
                      onPick: _pickPrescriptionImage,
                      onRemove: () =>
                          setState(() => _prescriptionImagePath = null),
                    ),
                    const SizedBox(height: 12),
                    _AutoTextField(
                      label: l10n.suggestedSessionsLabel,
                      controller: _suggestedSessions,
                      type: 'sessions',
                      keyboardType: TextInputType.number,
                      repo: ref.read(autocompleteRepositoryProvider),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return null;
                        final count = int.tryParse(value);
                        if (count == null) {
                          return l10n.sessionsMustBeNumber;
                        }
                        if (count < 1 || count > 300) {
                          return l10n.sessionsInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _therapistId,
                      items: <DropdownMenuItem<String>>[
                        if (isAdmin)
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text(l10n.noTherapistOption),
                          ),
                        ...therapists.map(
                          (t) => DropdownMenuItem<String>(
                            value: t.id,
                            child: Text(t.fullName),
                          ),
                        ),
                      ],
                      onChanged: (_isSaving || !isAdmin)
                          ? null
                          : (v) => setState(() => _therapistId = v),
                      decoration: InputDecoration(labelText: l10n.therapistLabel),
                      validator: (v) {
                        if (isAdmin) return null;
                        return (v == null || v.isEmpty)
                            ? l10n.therapistRequired
                            : null;
                      },
                    ),
                    if (!isEdit) ...[
                      const SizedBox(height: 12),
                      SwitchListTile(
                        value: _createInitialAppointment,
                        onChanged: _isSaving
                            ? null
                            : (v) =>
                                  setState(() => _createInitialAppointment = v),
                        title: Text(l10n.createInitialAppointment),
                        subtitle: Text(l10n.createInitialAppointmentSubtitle),
                      ),
                      if (_createInitialAppointment)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.firstAppointmentDateTime),
                          subtitle: Text(
                            _formatDateTime(context, _initialAppointmentAt),
                          ),
                          trailing: const Icon(Icons.calendar_month),
                          onTap: _isSaving
                              ? null
                              : () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _initialAppointmentAt,
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 1),
                                    ),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date == null || !context.mounted) return;
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      _initialAppointmentAt,
                                    ),
                                  );
                                  if (time == null) return;
                                  setState(() {
                                    _initialAppointmentAt = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                },
                        ),
                    ],
                    const SizedBox(height: 12),
                    _AutoTextField(
                      label: l10n.doctorNameLabel,
                      controller: _doctorName,
                      type: 'doctor',
                      repo: ref.read(autocompleteRepositoryProvider),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: _isSaving ? null : () => _save(isEdit),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.save),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.loadTherapistsFailed)),
          ),
    );
  }

  Future<void> _save(bool isEdit) async {
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      if (!isEdit &&
          ref.read(authStateProvider).valueOrNull?.role != UserRole.admin.value &&
          (_therapistId == null || _therapistId!.isEmpty)) {
        throw Exception('therapist_required');
      }

      final repo = ref.read(patientRepositoryProvider);
      final auto = ref.read(autocompleteRepositoryProvider);
      final id = widget.patient?.id ?? const Uuid().v4();

      final patient = Patient(
        id: id,
        fullName: _fullName.text.trim(),
        age: int.tryParse(_age.text.trim()),
        gender: _gender,
        status: _status,
        diagnosis: _diagnosis.text.trim().isEmpty
            ? null
            : _diagnosis.text.trim(),
        medicalHistory: _medicalHistory.text.trim().isEmpty
            ? null
            : _medicalHistory.text.trim(),
        suggestedSessions: int.tryParse(_suggestedSessions.text.trim()),
        therapistId: (_therapistId ?? '').trim(),
        doctorName: _doctorName.text.trim().isEmpty
            ? null
            : _doctorName.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        prescriptionImagePath: _prescriptionImagePath,
      );

      if (_diagnosis.text.trim().isNotEmpty) {
        await auto.record('diagnosis', _diagnosis.text.trim());
      }
      if (_doctorName.text.trim().isNotEmpty) {
        await auto.record('doctor', _doctorName.text.trim());
      }
      if (_age.text.trim().isNotEmpty) {
        await auto.record('age', _age.text.trim());
      }
      if (_suggestedSessions.text.trim().isNotEmpty) {
        await auto.record('sessions', _suggestedSessions.text.trim());
      }

      if (isEdit) {
        await repo.update(patient);
      } else {
        await repo.create(patient);
        if (_createInitialAppointment && patient.therapistId.isNotEmpty) {
          final appointmentRepo = ref.read(appointmentRepositoryProvider);
          final appointment = Appointment(
            id: const Uuid().v4(),
            patientId: patient.id,
            therapistId: patient.therapistId,
            scheduledAt: _initialAppointmentAt,
            status: 'scheduled',
          );
          await appointmentRepo.create(appointment);
          ref.invalidate(
            appointmentsForDayProvider(
              DateTime(
                _initialAppointmentAt.year,
                _initialAppointmentAt.month,
                _initialAppointmentAt.day,
              ),
            ),
          );
        }
      }

      ref.invalidate(patientsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? l10n.updatedPatient
                : (_createInitialAppointment
                      ? l10n.addedPatientWithFirstAppointment
                      : l10n.addedPatient),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains('therapist_required')
          ? l10n.therapistRequiredFirst
          : l10n.savePatientFailed(_shortErr(e));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

String _formatDateTime(BuildContext context, DateTime dt) {
  final local = dt.toLocal();
  final date = MaterialLocalizations.of(context).formatMediumDate(local);
  final time = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
  );
  return '$date $time';
}

class _AutoTextField extends StatelessWidget {
  final String label;
  final String type;
  final TextEditingController controller;
  final AutocompleteRepository repo;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AutoTextField({
    required this.label,
    required this.type,
    required this.controller,
    required this.repo,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (value) async {
        return repo.search(type, value.text.trim());
      },
      onSelected: (v) => controller.text = v,
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        fieldController.text = controller.text;
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label),
          validator: validator,
          onChanged: (v) => controller.text = v,
        );
      },
    );
  }
}

class _PrescriptionImageField extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _PrescriptionImageField({
    required this.imagePath,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filePath = imagePath;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.prescriptionImageTitle),
            const SizedBox(height: 8),
            if (filePath != null && File(filePath).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(filePath),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Text(l10n.noImage),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPick,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(l10n.takePhoto),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.remove),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _shortErr(Object e) {
  final s = e.toString().replaceAll('\n', ' ').trim();
  if (s.length <= 110) return s;
  return '${s.substring(0, 110)}...';
}

