// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'physio_manager';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get syncing => 'Synchronisation…';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get therapistNameLabel => 'Nom du kinésithérapeute';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get onlyAdminCreatesAccounts =>
      'Les comptes sont créés par l’admin uniquement';

  @override
  String get reauthTitle => 'Session verrouillée';

  @override
  String reauthSubtitle(Object email) {
    return 'Continuer avec $email';
  }

  @override
  String get reauthButton => 'Déverrouiller la session';

  @override
  String get reauthNeedsInternet =>
      'Internet est requis pour déverrouiller la session';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutSubtitle => 'Terminer la session actuelle sur cet appareil';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerButton => 'S’inscrire';

  @override
  String get accountCreated => 'Compte créé avec succès';

  @override
  String get signUpConfirmEmail =>
      'Compte créé. Veuillez confirmer l’e-mail puis vous connecter.';

  @override
  String get signUpAuthSaveFailed =>
      'Échec de création dans Auth. Vérifiez Supabase Auth.';

  @override
  String get signUpRateLimit =>
      'Limite d’e-mails atteinte. Réessayez plus tard.';

  @override
  String get signUpEmailNotConfirmed =>
      'L’e-mail doit être confirmé avant la connexion.';

  @override
  String get signUpInvalidApiKey =>
      'Clé API Supabase invalide dans l’application.';

  @override
  String get signUpEmailUsed => 'E-mail déjà enregistré.';

  @override
  String get signUpInvalidEmail => 'Format d’e-mail invalide.';

  @override
  String get signUpPasswordInvalid =>
      'Le mot de passe ne respecte pas les conditions.';

  @override
  String signUpFailed(Object error) {
    return 'Échec de création : $error';
  }

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get enterEmail => 'Entrez votre e-mail';

  @override
  String get sendResetLink => 'Envoyer le lien';

  @override
  String get sending => 'Envoi en cours...';

  @override
  String get resetLinkSent => 'Lien de réinitialisation envoyé';

  @override
  String get resetLinkFailed => 'Échec de l’envoi du lien';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordMin =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordsNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get passwordUpdateFailed => 'Échec de la mise à jour';

  @override
  String get save => 'Enregistrer';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get update => 'Mettre à jour';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get notificationsEnabledTitle => 'Activer les notifications';

  @override
  String get notificationsEnabledSubtitle =>
      'Activer/désactiver les notifications locales';

  @override
  String reminderBeforeAppointment(Object minutes) {
    return '$minutes min avant le rendez-vous';
  }

  @override
  String get notificationLogTitle => 'Historique des notifications';

  @override
  String get notificationLogSubtitle => 'Voir les notifications récentes';

  @override
  String get notificationLogEmpty => 'Aucune notification pour l’instant';

  @override
  String get notificationLogLoadFailed => 'Échec du chargement de l’historique';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get languageTitle => 'Langue de l’application';

  @override
  String get changePasswordMenuTitle => 'Changer le mot de passe';

  @override
  String get changePasswordMenuSubtitle => 'Mettre à jour le mot de passe';

  @override
  String get noteAutoSaveTitle => 'Délai d’enregistrement automatique';

  @override
  String noteAutoSaveSubtitle(Object ms) {
    return 'Après ${ms}ms d’inactivité';
  }

  @override
  String get syncEnabledTitle => 'Activer la synchronisation';

  @override
  String get syncEnabledSubtitle => 'Sync auto toutes les 5 minutes + Realtime';

  @override
  String get lastSyncTitle => 'Dernière synchronisation';

  @override
  String get lastSyncNever => 'Pas encore synchronisé';

  @override
  String get lastSyncLoading => 'Chargement...';

  @override
  String get lastSyncUnavailable => 'Indisponible';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get syncDone => 'Synchronisation terminée';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get useDeviceLanguage => 'Utiliser la langue de l’appareil';

  @override
  String get langArabic => 'Arabe';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get chooseReminder => 'Choisir le rappel';

  @override
  String get chooseNoteDelay => 'Choisir le délai';

  @override
  String get minutesUnit => 'min';

  @override
  String get millisecondsUnit => 'ms';

  @override
  String get therapistsTitle => 'Kinésithérapeutes';

  @override
  String get addTherapist => 'Ajouter un kiné';

  @override
  String get therapistFormTitleAdd => 'Ajouter un kiné';

  @override
  String get therapistFormTitleEdit => 'Modifier le kiné';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get userIdLabel => 'ID utilisateur (Supabase Auth)';

  @override
  String get adminRoleLabel => 'Rôle admin';

  @override
  String get primary => 'Principal';

  @override
  String get therapist => 'Kiné';

  @override
  String get makeAdmin => 'Rendre admin';

  @override
  String get removeAdmin => 'Retirer admin';

  @override
  String get maxAdmins => 'Maximum d’admins : 2';

  @override
  String get minOneAdmin => 'Au moins un admin est requis';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String confirmMakeAdmin(Object name) {
    return 'Accorder admin à $name ?';
  }

  @override
  String confirmRemoveAdmin(Object name) {
    return 'Retirer admin de $name ?';
  }

  @override
  String adminGranted(Object name) {
    return 'Admin accordé à $name';
  }

  @override
  String adminRemoved(Object name) {
    return 'Admin retiré à $name';
  }

  @override
  String updateAdminFailed(Object error) {
    return 'Échec de mise à jour admin : $error';
  }

  @override
  String get loadTherapistsFailed => 'Échec du chargement';

  @override
  String get inviteTherapistTitle => 'Inviter un kiné';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get nameRequired => 'Nom requis';

  @override
  String get emailRequired => 'E-mail requis';

  @override
  String get invalidEmail => 'E-mail invalide';

  @override
  String get tempPasswordLabel => 'Mot de passe temporaire';

  @override
  String get tempPasswordMin => 'Le mot de passe doit contenir 8 caractères';

  @override
  String get createTherapistSuccess => 'Compte créé';

  @override
  String get createTherapist => 'Créer un compte';

  @override
  String get creating => 'Création...';

  @override
  String get inviteNote =>
      'Note : cet écran dépend de la fonction admin-create-user.';

  @override
  String get inviteNoPermission => 'Vous n’avez pas la permission';

  @override
  String get inviteServerKeyMissing => 'Erreur serveur : clé manquante';

  @override
  String get inviteSessionExpired => 'Session expirée. Reconnectez-vous';

  @override
  String get inviteInvalidPayload =>
      'Vérifiez nom, e-mail et mot de passe (8 caractères)';

  @override
  String get inviteCreateFailed => 'Échec de création dans Supabase';

  @override
  String get inviteEmailUsed => 'E-mail déjà utilisé';

  @override
  String inviteFailed(Object error) {
    return 'Échec de création : $error';
  }

  @override
  String get createRemainingSessionsLabel =>
      'Créer automatiquement les séances restantes';

  @override
  String remainingSessionsHint(Object count) {
    return 'Séances restantes à créer : $count';
  }

  @override
  String get noRemainingSessionsHint =>
      'Aucune séance restante pour ce patient';

  @override
  String get repeatByWeekdays => 'Répéter par jours';

  @override
  String get repeatByDates => 'Répéter par dates spécifiques';

  @override
  String get customDatesLabel => 'Dates personnalisées (YYYY-MM-DD)';

  @override
  String get customDatesHint =>
      'Entrez des dates séparées par des virgules ou des espaces';

  @override
  String get invalidRepeatSelection =>
      'Choisissez des paramètres de répétition valides';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get sessionsStats => 'Stats des séances';

  @override
  String get totalSessions => 'Total des séances';

  @override
  String get sessionsMale => 'Séances hommes';

  @override
  String get sessionsFemale => 'Séances femmes';

  @override
  String get sessionsChild => 'Séances enfants';

  @override
  String get sessionsRatio => 'Répartition des séances';

  @override
  String get patientsStats => 'Stats des patients';

  @override
  String get totalPatients => 'Total patients';

  @override
  String get patientsMale => 'Patients hommes';

  @override
  String get patientsFemale => 'Patients femmes';

  @override
  String get patientsChild => 'Patients enfants';

  @override
  String get patientsRatio => 'Répartition des patients';

  @override
  String statsLoadFailed(Object error) {
    return 'Échec chargement stats : $error';
  }

  @override
  String get statsByTherapist => 'Par kiné';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get overall => 'Global';

  @override
  String get yearLabel => 'Année';

  @override
  String get monthLabel => 'Mois';

  @override
  String get male => 'Hommes';

  @override
  String get female => 'Femmes';

  @override
  String get child => 'Enfants';

  @override
  String totalLabel(Object total) {
    return 'Total\n$total';
  }

  @override
  String get patientsTitle => 'Patients';

  @override
  String get patientSearchHint => 'Rechercher par nom, diagnostic ou médecin';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterMale => 'Homme';

  @override
  String get filterFemale => 'Femme';

  @override
  String get filterChild => 'Enfant';

  @override
  String get currentlyTreating => 'En traitement';

  @override
  String get finishedTreatment => 'Traitement terminé';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String patientAgeDiagnosis(Object age, Object diagnosis) {
    return 'Âge : $age • Diagnostic : $diagnosis';
  }

  @override
  String patientTherapist(Object name) {
    return 'Kiné : $name';
  }

  @override
  String get unassignedTherapist => 'Non planifié / sans kiné';

  @override
  String get details => 'Détails';

  @override
  String get loadPatientsFailed => 'Échec du chargement des patients';

  @override
  String get deletePatientTitle => 'Supprimer le patient';

  @override
  String get deletePatientConfirm => 'Supprimer ce patient ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get patientFormTitleAdd => 'Ajouter un patient';

  @override
  String get patientFormTitleEdit => 'Modifier le patient';

  @override
  String get noTherapistsYet => 'Aucun kiné. Ajoutez-en un d’abord.';

  @override
  String get fullNameRequired => 'Nom complet requis';

  @override
  String get nameTooShort => 'Nom trop court';

  @override
  String get ageLabel => 'Âge';

  @override
  String get ageMustBeNumber => 'L’âge doit être un nombre';

  @override
  String get ageInvalid => 'Âge invalide';

  @override
  String get genderLabel => 'Sexe';

  @override
  String get patientStatusLabel => 'Statut du patient';

  @override
  String get statusNotStarted => 'Pas encore commencé';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusSuspended => 'Suspendu';

  @override
  String get diagnosisLabel => 'Diagnostic';

  @override
  String get advancedFilters => 'Filtres avancés';

  @override
  String get diagnosisFilterLabel => 'Filtrer par diagnostic';

  @override
  String get doctorFilterLabel => 'Filtrer par médecin';

  @override
  String get recurrenceLabel => 'Récurrence';

  @override
  String get recurrenceWeekly => 'Hebdomadaire';

  @override
  String get recurrenceWeekdays => 'Jours spécifiques';

  @override
  String get weekdayMon => 'Lun';

  @override
  String get weekdayTue => 'Mar';

  @override
  String get weekdayWed => 'Mer';

  @override
  String get weekdayThu => 'Jeu';

  @override
  String get weekdayFri => 'Ven';

  @override
  String get weekdaySat => 'Sam';

  @override
  String get weekdaySun => 'Dim';

  @override
  String get medicalHistoryLabel => 'Antécédents médicaux';

  @override
  String get suggestedSessionsLabel => 'Séances proposées';

  @override
  String get sessionsMustBeNumber => 'Le nombre doit être un nombre';

  @override
  String get sessionsInvalid => 'Nombre de séances invalide';

  @override
  String get therapistLabel => 'Kiné';

  @override
  String get noTherapistOption => 'Sans kiné';

  @override
  String get therapistRequired => 'Choisir un kiné';

  @override
  String get createInitialAppointment => 'Créer le premier rendez-vous';

  @override
  String get createInitialAppointmentSubtitle => 'Assigner au kiné sélectionné';

  @override
  String get createAllAppointments => 'Créer tous les rendez-vous';

  @override
  String get createAllAppointmentsSubtitle => 'Rendez-vous hebdomadaires';

  @override
  String get firstAppointmentDateTime => 'Date/heure du premier rendez-vous';

  @override
  String get doctorNameLabel => 'Médecin traitant';

  @override
  String get updatedPatient => 'Patient mis à jour';

  @override
  String get addedPatientWithFirstAppointment =>
      'Patient ajouté avec premier rendez-vous';

  @override
  String get addedPatient => 'Patient ajouté';

  @override
  String get therapistRequiredFirst => 'Choisir le kiné d’abord';

  @override
  String savePatientFailed(Object error) {
    return 'Échec d’enregistrement : $error';
  }

  @override
  String get prescriptionImageTitle => 'Ordonnance';

  @override
  String get noImage => 'Aucune image';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get remove => 'Retirer';

  @override
  String get patientDetailsTitle => 'Détails du patient';

  @override
  String get loadPatientDetailsFailed => 'Échec chargement détails';

  @override
  String get patientAuditTitle => 'Historique des modifications';

  @override
  String get patientAuditEmpty => 'Aucune modification enregistrée';

  @override
  String get auditCreated => 'Patient créé';

  @override
  String get auditUpdated => 'Patient modifié';

  @override
  String get auditDeleted => 'Patient supprimé';

  @override
  String ageValue(Object age) {
    return 'Âge : $age';
  }

  @override
  String genderValue(Object gender) {
    return 'Sexe : $gender';
  }

  @override
  String diagnosisValue(Object diagnosis) {
    return 'Diagnostic : $diagnosis';
  }

  @override
  String medicalHistoryValue(Object history) {
    return 'Antécédents : $history';
  }

  @override
  String doctorValue(Object doctor) {
    return 'Médecin : $doctor';
  }

  @override
  String phoneValue(Object phone) {
    return 'Téléphone : $phone';
  }

  @override
  String get callPatient => 'Appeler le patient';

  @override
  String get callTherapist => 'Appeler le kiné';

  @override
  String get callFailed => 'Impossible de lancer l\'appel';

  @override
  String get prescriptionTitle => 'Ordonnance';

  @override
  String get completed => 'Terminé';

  @override
  String get missed => 'Absent';

  @override
  String get remaining => 'Restant';

  @override
  String get newAppointmentForPatient => 'Nouveau rendez-vous';

  @override
  String get editPatientData => 'Modifier le patient';

  @override
  String get upcomingAppointments => 'Rendez-vous à venir';

  @override
  String get noUpcomingAppointments => 'Aucun rendez-vous à venir';

  @override
  String get sessionsHistory => 'Historique des séances';

  @override
  String get noSessionsYet => 'Aucune séance';

  @override
  String get attendancePresent => 'Présent';

  @override
  String get attendanceAbsent => 'Absent';

  @override
  String get attendanceUnknown => 'Non confirmé';

  @override
  String appointmentSubtitle(
    Object attendance,
    Object note,
    Object scheduled,
    Object status,
  ) {
    return 'Rendez-vous : $scheduled\nStatut : $status • Présence : $attendance\nNote : $note';
  }

  @override
  String get scheduled => 'Planifié';

  @override
  String get canceled => 'Annulé';

  @override
  String get appointmentsTitle => 'Rendez-vous';

  @override
  String get noPatientsForAppointments =>
      'Ajoutez d\'abord un patient avant de créer un rendez-vous';

  @override
  String get pickDate => 'Choisir la date';

  @override
  String get unknownPatient => 'Patient inconnu';

  @override
  String therapistWithTime(Object name, Object time) {
    return 'Kiné : $name • $time';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get loadAppointmentsFailed => 'Échec chargement rendez-vous';

  @override
  String get addAppointment => 'Ajouter un rendez-vous';

  @override
  String get filterAllLabel => 'Tous';

  @override
  String get filterScheduled => 'Planifié';

  @override
  String get filterCompleted => 'Terminé';

  @override
  String get filterMissed => 'Absent';

  @override
  String get filterCanceled => 'Annulé';

  @override
  String get appointmentFormTitleAdd => 'Ajouter un rendez-vous';

  @override
  String get appointmentFormTitleEdit => 'Modifier le rendez-vous';

  @override
  String get patientLabel => 'Patient';

  @override
  String get therapistLabelShort => 'Kiné';

  @override
  String get appointmentDateTime => 'Date/heure du rendez-vous';

  @override
  String get dateLabel => 'Date (YYYY-MM-DD)';

  @override
  String get timeLabel => 'Heure (HH:mm)';

  @override
  String get statusLabel => 'Statut';

  @override
  String get pickPatientTherapist => 'Choisissez patient et kiné';

  @override
  String get appointmentUpdated => 'Rendez-vous modifié';

  @override
  String get appointmentCreated => 'Rendez-vous créé';

  @override
  String appointmentUpdatedWithReminder(Object minutes) {
    return 'Rendez-vous modifié (rappel : $minutes min)';
  }

  @override
  String appointmentCreatedWithReminder(Object minutes) {
    return 'Rendez-vous créé dans $minutes min';
  }

  @override
  String get reminderTitle => 'Rappel de rendez-vous';

  @override
  String reminderBody(Object minutes) {
    return 'Vous avez un rendez-vous dans $minutes minutes';
  }

  @override
  String reminderBodyNoName(Object minutes, Object time) {
    return 'Votre rendez-vous à $time (dans $minutes min)';
  }

  @override
  String reminderBodyWithName(Object minutes, Object name, Object time) {
    return 'Rendez-vous pour $name à $time (dans $minutes min)';
  }

  @override
  String get syncCompleteTitle => 'Synchronisation terminée';

  @override
  String get syncCompleteBody => 'Données mises à jour avec succès';

  @override
  String get invalidDate => 'Format de date invalide';

  @override
  String get invalidTime => 'Format d’heure invalide';

  @override
  String get invalidTimeValue => 'Heure invalide';

  @override
  String get appointmentDetailsTitle => 'Détails du rendez-vous';

  @override
  String patientLabelValue(Object name) {
    return 'Patient : $name';
  }

  @override
  String therapistLabelValue(Object name) {
    return 'Kiné : $name';
  }

  @override
  String timeLabelValue(Object time) {
    return 'Heure : $time';
  }

  @override
  String statusLabelValue(Object status) {
    return 'Statut : $status';
  }

  @override
  String get markPresent => 'Marquer présent';

  @override
  String get markAbsent => 'Marquer absence';

  @override
  String get noteSaved => 'Note enregistrée';

  @override
  String noteSavedFor(Object name) {
    return 'Note enregistrée pour $name';
  }

  @override
  String get attendanceMarked => 'Présence marquée';

  @override
  String get absenceMarked => 'Absence marquée';

  @override
  String get sessionDetails => 'Détails de la séance';

  @override
  String attendance(Object value) {
    return 'Présence : $value';
  }

  @override
  String sessionTime(Object time) {
    return 'Heure : $time';
  }

  @override
  String get sessionNote => 'Note de séance';

  @override
  String get noSessionDetails => 'Pas encore de détails';

  @override
  String get dashboardToday => 'Aujourd’hui';

  @override
  String get dashboardAppointments => 'Rendez-vous';

  @override
  String get dashboardPatients => 'Patients';

  @override
  String get dashboardTherapists => 'Kinés';

  @override
  String get dashboardStats => 'Statistiques';

  @override
  String get dashboardSettings => 'Paramètres';

  @override
  String get dashboardCustomizeTitle => 'Personnaliser le tableau de bord';

  @override
  String get dashboardCustomizeSubtitle =>
      'Afficher/masquer et réordonner les onglets';

  @override
  String get todaySessions => 'Séances du jour';

  @override
  String get noSessionsToday => 'Aucune séance aujourd’hui';

  @override
  String get loadTodayPatientsFailed => 'Échec chargement patients';

  @override
  String get loadTodayAppointmentsFailed => 'Échec chargement rendez-vous';

  @override
  String timeStatusLine(Object status, Object time) {
    return 'Heure : $time • Statut : $status';
  }
}
