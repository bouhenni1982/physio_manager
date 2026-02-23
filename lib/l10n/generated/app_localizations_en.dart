// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'physio_manager';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get syncing => 'Syncing…';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get therapistNameLabel => 'Therapist name';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get onlyAdminCreatesAccounts => 'Accounts are created by admin only';

  @override
  String get reauthTitle => 'Session locked';

  @override
  String reauthSubtitle(Object email) {
    return 'Continue as $email';
  }

  @override
  String get reauthButton => 'Unlock session';

  @override
  String get reauthNeedsInternet =>
      'Internet is required to unlock the session';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutSubtitle => 'End current session on this device';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerButton => 'Sign up';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get signUpConfirmEmail =>
      'Account created. Please confirm your email and sign in.';

  @override
  String get signUpAuthSaveFailed =>
      'Failed to create account in Auth. Check Supabase Auth settings.';

  @override
  String get signUpRateLimit =>
      'Email rate limit exceeded. Please try again later.';

  @override
  String get signUpEmailNotConfirmed =>
      'Email must be confirmed before sign in.';

  @override
  String get signUpInvalidApiKey => 'Invalid Supabase API key in app settings.';

  @override
  String get signUpEmailUsed => 'Email already registered.';

  @override
  String get signUpInvalidEmail => 'Invalid email format.';

  @override
  String get signUpPasswordInvalid => 'Password does not meet requirements.';

  @override
  String signUpFailed(Object error) {
    return 'Failed to create account: $error';
  }

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get sendResetLink => 'Send link';

  @override
  String get sending => 'Sending...';

  @override
  String get resetLinkSent => 'Password reset link sent';

  @override
  String get resetLinkFailed => 'Failed to send link';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get passwordMin => 'Password must be at least 8 characters';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get passwordUpdateFailed => 'Failed to update password';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get update => 'Update';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notificationsEnabledTitle => 'Enable notifications';

  @override
  String get notificationsEnabledSubtitle => 'Turn local notifications on/off';

  @override
  String reminderBeforeAppointment(Object minutes) {
    return '$minutes minutes before appointment';
  }

  @override
  String get notificationLogTitle => 'Notification log';

  @override
  String get notificationLogSubtitle => 'View recent notifications';

  @override
  String get notificationLogEmpty => 'No notifications yet';

  @override
  String get notificationLogLoadFailed => 'Failed to load log';

  @override
  String get clearAll => 'Clear all';

  @override
  String get languageTitle => 'App language';

  @override
  String get changePasswordMenuTitle => 'Change password';

  @override
  String get changePasswordMenuSubtitle => 'Update current password';

  @override
  String get noteAutoSaveTitle => 'Auto-save note delay';

  @override
  String noteAutoSaveSubtitle(Object ms) {
    return 'After ${ms}ms of inactivity';
  }

  @override
  String get syncEnabledTitle => 'Enable sync';

  @override
  String get syncEnabledSubtitle => 'Auto sync every 5 minutes + Realtime';

  @override
  String get lastSyncTitle => 'Last sync';

  @override
  String get lastSyncNever => 'Not synced yet';

  @override
  String get lastSyncLoading => 'Loading...';

  @override
  String get lastSyncUnavailable => 'Unavailable';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncDone => 'Sync completed';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get langArabic => 'Arabic';

  @override
  String get langFrench => 'French';

  @override
  String get langEnglish => 'English';

  @override
  String get chooseReminder => 'Choose reminder time';

  @override
  String get chooseNoteDelay => 'Choose note save delay';

  @override
  String get minutesUnit => 'min';

  @override
  String get millisecondsUnit => 'ms';

  @override
  String get therapistsTitle => 'Therapists';

  @override
  String get addTherapist => 'Add new therapist';

  @override
  String get therapistFormTitleAdd => 'Add therapist';

  @override
  String get therapistFormTitleEdit => 'Edit therapist';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get userIdLabel => 'User ID (Supabase Auth)';

  @override
  String get adminRoleLabel => 'Admin role';

  @override
  String get primary => 'Primary';

  @override
  String get therapist => 'Therapist';

  @override
  String get makeAdmin => 'Make admin';

  @override
  String get removeAdmin => 'Remove admin';

  @override
  String get maxAdmins => 'Maximum admins is 2';

  @override
  String get minOneAdmin => 'At least one admin is required';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String confirmMakeAdmin(Object name) {
    return 'Grant admin to $name?';
  }

  @override
  String confirmRemoveAdmin(Object name) {
    return 'Remove admin from $name?';
  }

  @override
  String adminGranted(Object name) {
    return 'Granted admin to $name';
  }

  @override
  String adminRemoved(Object name) {
    return 'Removed admin from $name';
  }

  @override
  String updateAdminFailed(Object error) {
    return 'Failed to update admin role: $error';
  }

  @override
  String get loadTherapistsFailed => 'Failed to load therapists';

  @override
  String get inviteTherapistTitle => 'Invite therapist';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get tempPasswordLabel => 'Temporary password';

  @override
  String get tempPasswordMin => 'Password must be at least 8 characters';

  @override
  String get createTherapistSuccess => 'Therapist account created';

  @override
  String get createTherapist => 'Create therapist';

  @override
  String get creating => 'Creating...';

  @override
  String get inviteNote =>
      'Note: This screen depends on the admin-create-user Edge Function.';

  @override
  String get inviteNoPermission => 'You don\'t have permission';

  @override
  String get inviteServerKeyMissing =>
      'Server config error: service key missing';

  @override
  String get inviteSessionExpired => 'Session expired. Please sign in again';

  @override
  String get inviteInvalidPayload =>
      'Check name, email and password (min 8 chars)';

  @override
  String get inviteCreateFailed => 'Failed to create account in Supabase';

  @override
  String get inviteEmailUsed => 'Email already used';

  @override
  String inviteFailed(Object error) {
    return 'Failed to create account: $error';
  }

  @override
  String get statsTitle => 'Statistics';

  @override
  String get sessionsStats => 'Sessions stats';

  @override
  String get totalSessions => 'Total sessions';

  @override
  String get sessionsMale => 'Sessions (male)';

  @override
  String get sessionsFemale => 'Sessions (female)';

  @override
  String get sessionsChild => 'Sessions (child)';

  @override
  String get sessionsRatio => 'Sessions ratio';

  @override
  String get patientsStats => 'Patients stats';

  @override
  String get totalPatients => 'Total patients';

  @override
  String get patientsMale => 'Male patients';

  @override
  String get patientsFemale => 'Female patients';

  @override
  String get patientsChild => 'Child patients';

  @override
  String get patientsRatio => 'Patients ratio';

  @override
  String statsLoadFailed(Object error) {
    return 'Failed to load stats: $error';
  }

  @override
  String get statsByTherapist => 'By therapist';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get overall => 'Overall';

  @override
  String get yearLabel => 'Year';

  @override
  String get monthLabel => 'Month';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get child => 'Child';

  @override
  String totalLabel(Object total) {
    return 'Total\n$total';
  }

  @override
  String get patientsTitle => 'Patients';

  @override
  String get patientSearchHint => 'Search by name, diagnosis, or doctor';

  @override
  String get filterAll => 'All';

  @override
  String get filterMale => 'Male';

  @override
  String get filterFemale => 'Female';

  @override
  String get filterChild => 'Child';

  @override
  String get currentlyTreating => 'Currently treating';

  @override
  String get finishedTreatment => 'Finished treatment';

  @override
  String get noResults => 'No results';

  @override
  String patientAgeDiagnosis(Object age, Object diagnosis) {
    return 'Age: $age • Diagnosis: $diagnosis';
  }

  @override
  String patientTherapist(Object name) {
    return 'Therapist: $name';
  }

  @override
  String get details => 'Details';

  @override
  String get loadPatientsFailed => 'Failed to load patients';

  @override
  String get deletePatientTitle => 'Delete patient';

  @override
  String get deletePatientConfirm => 'Do you want to delete this patient?';

  @override
  String get delete => 'Delete';

  @override
  String get patientFormTitleAdd => 'Add patient';

  @override
  String get patientFormTitleEdit => 'Edit patient';

  @override
  String get noTherapistsYet => 'No therapists yet. Add a therapist first.';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get ageLabel => 'Age';

  @override
  String get ageMustBeNumber => 'Age must be a number';

  @override
  String get ageInvalid => 'Invalid age';

  @override
  String get genderLabel => 'Gender';

  @override
  String get patientStatusLabel => 'Patient status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get diagnosisLabel => 'Diagnosis';

  @override
  String get advancedFilters => 'Advanced filters';

  @override
  String get diagnosisFilterLabel => 'Filter by diagnosis';

  @override
  String get doctorFilterLabel => 'Filter by doctor';

  @override
  String get recurrenceLabel => 'Recurrence';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceWeekdays => 'Specific weekdays';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get medicalHistoryLabel => 'Medical history';

  @override
  String get suggestedSessionsLabel => 'Suggested sessions';

  @override
  String get sessionsMustBeNumber => 'Sessions must be a number';

  @override
  String get sessionsInvalid => 'Invalid sessions count';

  @override
  String get therapistLabel => 'Therapist';

  @override
  String get therapistRequired => 'Select therapist';

  @override
  String get createInitialAppointment => 'Create first appointment';

  @override
  String get createInitialAppointmentSubtitle =>
      'Assign appointment to selected therapist';

  @override
  String get createAllAppointments => 'Create all appointments by sessions';

  @override
  String get createAllAppointmentsSubtitle =>
      'Appointments will be scheduled weekly';

  @override
  String get firstAppointmentDateTime => 'First appointment date/time';

  @override
  String get doctorNameLabel => 'Doctor name';

  @override
  String get updatedPatient => 'Patient updated';

  @override
  String get addedPatientWithFirstAppointment =>
      'Patient added with first appointment';

  @override
  String get addedPatient => 'Patient added';

  @override
  String get therapistRequiredFirst => 'Select therapist first';

  @override
  String savePatientFailed(Object error) {
    return 'Failed to save patient: $error';
  }

  @override
  String get prescriptionImageTitle => 'Prescription image';

  @override
  String get noImage => 'No image yet';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get remove => 'Remove';

  @override
  String get patientDetailsTitle => 'Patient details';

  @override
  String get loadPatientDetailsFailed => 'Failed to load patient details';

  @override
  String get patientAuditTitle => 'Patient change log';

  @override
  String get patientAuditEmpty => 'No changes recorded yet';

  @override
  String get auditCreated => 'Patient created';

  @override
  String get auditUpdated => 'Patient updated';

  @override
  String get auditDeleted => 'Patient deleted';

  @override
  String ageValue(Object age) {
    return 'Age: $age';
  }

  @override
  String genderValue(Object gender) {
    return 'Gender: $gender';
  }

  @override
  String diagnosisValue(Object diagnosis) {
    return 'Diagnosis: $diagnosis';
  }

  @override
  String medicalHistoryValue(Object history) {
    return 'Medical history: $history';
  }

  @override
  String doctorValue(Object doctor) {
    return 'Doctor: $doctor';
  }

  @override
  String phoneValue(Object phone) {
    return 'Phone: $phone';
  }

  @override
  String get callPatient => 'Call patient';

  @override
  String get callTherapist => 'Call therapist';

  @override
  String get callFailed => 'Could not start phone call';

  @override
  String get prescriptionTitle => 'Prescription';

  @override
  String get completed => 'Completed';

  @override
  String get missed => 'Missed';

  @override
  String get remaining => 'Remaining';

  @override
  String get newAppointmentForPatient => 'New appointment for this patient';

  @override
  String get editPatientData => 'Edit patient';

  @override
  String get upcomingAppointments => 'Upcoming appointments';

  @override
  String get noUpcomingAppointments => 'No upcoming appointments';

  @override
  String get sessionsHistory => 'Session history';

  @override
  String get noSessionsYet => 'No sessions yet';

  @override
  String get attendancePresent => 'Present';

  @override
  String get attendanceAbsent => 'Absent';

  @override
  String get attendanceUnknown => 'Unknown';

  @override
  String appointmentSubtitle(
    Object attendance,
    Object note,
    Object scheduled,
    Object status,
  ) {
    return 'Appointment: $scheduled\nStatus: $status • Attendance: $attendance\nNote: $note';
  }

  @override
  String get scheduled => 'Scheduled';

  @override
  String get canceled => 'Canceled';

  @override
  String get appointmentsTitle => 'Appointments';

  @override
  String get pickDate => 'Pick date';

  @override
  String get unknownPatient => 'Unknown patient';

  @override
  String therapistWithTime(Object name, Object time) {
    return 'Therapist: $name • $time';
  }

  @override
  String get edit => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get loadAppointmentsFailed => 'Failed to load appointments';

  @override
  String get addAppointment => 'Add appointment';

  @override
  String get filterAllLabel => 'All';

  @override
  String get filterScheduled => 'Scheduled';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterMissed => 'Missed';

  @override
  String get filterCanceled => 'Canceled';

  @override
  String get appointmentFormTitleAdd => 'Add appointment';

  @override
  String get appointmentFormTitleEdit => 'Edit appointment';

  @override
  String get patientLabel => 'Patient';

  @override
  String get therapistLabelShort => 'Therapist';

  @override
  String get appointmentDateTime => 'Appointment date/time';

  @override
  String get dateLabel => 'Date (YYYY-MM-DD)';

  @override
  String get timeLabel => 'Time (HH:mm)';

  @override
  String get statusLabel => 'Status';

  @override
  String get pickPatientTherapist => 'Select patient and therapist first';

  @override
  String get appointmentUpdated => 'Appointment updated';

  @override
  String get appointmentCreated => 'Appointment created';

  @override
  String appointmentUpdatedWithReminder(Object minutes) {
    return 'Appointment updated (reminder: $minutes min)';
  }

  @override
  String appointmentCreatedWithReminder(Object minutes) {
    return 'Appointment created after $minutes min';
  }

  @override
  String get reminderTitle => 'Appointment reminder';

  @override
  String reminderBody(Object minutes) {
    return 'You have an appointment in $minutes minutes';
  }

  @override
  String reminderBodyNoName(Object minutes, Object time) {
    return 'Your appointment at $time (in $minutes min)';
  }

  @override
  String reminderBodyWithName(Object minutes, Object name, Object time) {
    return 'Appointment for $name at $time (in $minutes min)';
  }

  @override
  String get syncCompleteTitle => 'Sync completed';

  @override
  String get syncCompleteBody => 'Data updated successfully';

  @override
  String get invalidDate => 'Invalid date format';

  @override
  String get invalidTime => 'Invalid time format';

  @override
  String get invalidTimeValue => 'Invalid time';

  @override
  String get appointmentDetailsTitle => 'Appointment details';

  @override
  String patientLabelValue(Object name) {
    return 'Patient: $name';
  }

  @override
  String therapistLabelValue(Object name) {
    return 'Therapist: $name';
  }

  @override
  String timeLabelValue(Object time) {
    return 'Time: $time';
  }

  @override
  String statusLabelValue(Object status) {
    return 'Status: $status';
  }

  @override
  String get markPresent => 'Mark present';

  @override
  String get markAbsent => 'Mark absent';

  @override
  String get noteSaved => 'Note saved';

  @override
  String noteSavedFor(Object name) {
    return 'Session note saved for $name';
  }

  @override
  String get attendanceMarked => 'Attendance marked';

  @override
  String get absenceMarked => 'Absence marked';

  @override
  String get sessionDetails => 'Session details';

  @override
  String attendance(Object value) {
    return 'Attendance: $value';
  }

  @override
  String sessionTime(Object time) {
    return 'Time: $time';
  }

  @override
  String get sessionNote => 'Session note';

  @override
  String get noSessionDetails => 'No session details yet';

  @override
  String get dashboardToday => 'Today';

  @override
  String get dashboardAppointments => 'Appointments';

  @override
  String get dashboardPatients => 'Patients';

  @override
  String get dashboardTherapists => 'Therapists';

  @override
  String get dashboardStats => 'Statistics';

  @override
  String get dashboardSettings => 'Settings';

  @override
  String get dashboardCustomizeTitle => 'Customize dashboard';

  @override
  String get dashboardCustomizeSubtitle => 'Show/hide and reorder tabs';

  @override
  String get todaySessions => 'Today\'s sessions';

  @override
  String get noSessionsToday => 'No sessions today';

  @override
  String get loadTodayPatientsFailed => 'Failed to load patients';

  @override
  String get loadTodayAppointmentsFailed =>
      'Failed to load today\'s appointments';

  @override
  String timeStatusLine(Object status, Object time) {
    return 'Time: $time • Status: $status';
  }
}
