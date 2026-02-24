// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'physio_manager';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get syncing => 'مزامنة…';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get therapistNameLabel => 'اسم المختص';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get invalidCredentials => 'بيانات غير صحيحة';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get onlyAdminCreatesAccounts =>
      'إنشاء الحسابات يتم من طرف المسؤول فقط';

  @override
  String get reauthTitle => 'الجلسة مقفلة';

  @override
  String reauthSubtitle(Object email) {
    return 'المتابعة بالحساب $email';
  }

  @override
  String get reauthButton => 'فتح الجلسة';

  @override
  String get reauthNeedsInternet => 'يلزم اتصال الإنترنت لفتح الجلسة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutSubtitle => 'إنهاء الجلسة الحالية على هذا الجهاز';

  @override
  String get registerTitle => 'تسجيل جديد';

  @override
  String get registerButton => 'تسجيل';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get signUpConfirmEmail =>
      'تم إنشاء الحساب. يرجى تأكيد البريد الإلكتروني ثم تسجيل الدخول.';

  @override
  String get signUpAuthSaveFailed =>
      'فشل إنشاء الحساب في نظام المصادقة. تحقق من إعدادات Auth في Supabase.';

  @override
  String get signUpRateLimit =>
      'تم تجاوز حد محاولات البريد. انتظر قليلًا ثم أعد المحاولة.';

  @override
  String get signUpEmailNotConfirmed =>
      'الحساب يحتاج تأكيد البريد الإلكتروني قبل تسجيل الدخول.';

  @override
  String get signUpInvalidApiKey =>
      'مفتاح Supabase غير صحيح في إعدادات التطبيق.';

  @override
  String get signUpEmailUsed => 'هذا البريد مسجل مسبقًا.';

  @override
  String get signUpInvalidEmail => 'صيغة البريد الإلكتروني غير صحيحة.';

  @override
  String get signUpPasswordInvalid => 'كلمة المرور لا تحقق الشروط المطلوبة.';

  @override
  String signUpFailed(Object error) {
    return 'تعذر إنشاء الحساب: $error';
  }

  @override
  String get resetPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get sendResetLink => 'إرسال الرابط';

  @override
  String get sending => 'جارٍ الإرسال...';

  @override
  String get resetLinkSent => 'تم إرسال رابط إعادة تعيين كلمة المرور';

  @override
  String get resetLinkFailed => 'تعذر إرسال الرابط';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get passwordMin => 'كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور';

  @override
  String get passwordUpdateFailed => 'تعذر تحديث كلمة المرور';

  @override
  String get save => 'حفظ';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get update => 'تحديث';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get notificationsEnabledTitle => 'تفعيل الإشعارات';

  @override
  String get notificationsEnabledSubtitle => 'تشغيل/إيقاف الإشعارات المحلية';

  @override
  String reminderBeforeAppointment(Object minutes) {
    return 'قبل الموعد بـ $minutes دقيقة';
  }

  @override
  String get notificationLogTitle => 'سجل الإشعارات';

  @override
  String get notificationLogSubtitle => 'عرض الإشعارات الأخيرة داخل التطبيق';

  @override
  String get notificationLogEmpty => 'لا توجد إشعارات بعد';

  @override
  String get notificationLogLoadFailed => 'تعذر تحميل السجل';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get languageTitle => 'لغة التطبيق';

  @override
  String get changePasswordMenuTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordMenuSubtitle => 'تعديل كلمة المرور الحالية';

  @override
  String get noteAutoSaveTitle => 'مدة حفظ الملاحظة تلقائيًا';

  @override
  String noteAutoSaveSubtitle(Object ms) {
    return 'بعد التوقف بـ ${ms}ms';
  }

  @override
  String get syncEnabledTitle => 'تفعيل المزامنة';

  @override
  String get syncEnabledSubtitle => 'مزامنة تلقائية كل 5 دقائق + Realtime';

  @override
  String get lastSyncTitle => 'آخر مزامنة';

  @override
  String get lastSyncNever => 'لم تتم مزامنة بعد';

  @override
  String get lastSyncLoading => 'جارٍ التحميل...';

  @override
  String get lastSyncUnavailable => 'غير متاح';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get syncDone => 'تمت المزامنة';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get useDeviceLanguage => 'استخدام لغة الجهاز';

  @override
  String get langArabic => 'العربية';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'English';

  @override
  String get chooseReminder => 'اختر مدة التذكير';

  @override
  String get chooseNoteDelay => 'اختر مدة حفظ الملاحظة';

  @override
  String get minutesUnit => 'دقيقة';

  @override
  String get millisecondsUnit => 'مللي ثانية';

  @override
  String get therapistsTitle => 'إدارة المختصين';

  @override
  String get addTherapist => 'إضافة مختص جديد';

  @override
  String get therapistFormTitleAdd => 'إضافة مختص';

  @override
  String get therapistFormTitleEdit => 'تعديل مختص';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get userIdLabel => 'User ID (من Supabase Auth)';

  @override
  String get adminRoleLabel => 'صلاحية المسؤول';

  @override
  String get primary => 'رئيسي';

  @override
  String get therapist => 'مختص';

  @override
  String get makeAdmin => 'تعيين كمسؤول';

  @override
  String get removeAdmin => 'إزالة صلاحية المسؤول';

  @override
  String get maxAdmins => 'الحد الأقصى للمسؤولين هو 2';

  @override
  String get minOneAdmin => 'يجب أن يبقى مسؤول واحد على الأقل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String confirmMakeAdmin(Object name) {
    return 'هل تريد منح $name صلاحية المسؤول؟';
  }

  @override
  String confirmRemoveAdmin(Object name) {
    return 'هل تريد إزالة صلاحية المسؤول من $name؟';
  }

  @override
  String adminGranted(Object name) {
    return 'تم منح $name صلاحية المسؤول';
  }

  @override
  String adminRemoved(Object name) {
    return 'تمت إزالة صلاحية المسؤول من $name';
  }

  @override
  String updateAdminFailed(Object error) {
    return 'تعذر تحديث صلاحية المسؤول: $error';
  }

  @override
  String get loadTherapistsFailed => 'تعذر تحميل المختصين';

  @override
  String get inviteTherapistTitle => 'دعوة مختص جديد';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get emailRequired => 'البريد مطلوب';

  @override
  String get invalidEmail => 'بريد غير صالح';

  @override
  String get tempPasswordLabel => 'كلمة المرور المؤقتة';

  @override
  String get tempPasswordMin => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get createTherapistSuccess => 'تم إنشاء حساب المختص بنجاح';

  @override
  String get createTherapist => 'إنشاء حساب مختص';

  @override
  String get creating => 'جارٍ الإنشاء...';

  @override
  String get inviteNote =>
      'ملاحظة: هذه الشاشة تعتمد على Edge Function باسم admin-create-user.';

  @override
  String get inviteNoPermission => 'لا تملك صلاحية إنشاء مختصين';

  @override
  String get inviteServerKeyMissing =>
      'خطأ إعدادات السيرفر: مفتاح الخدمة غير مضبوط';

  @override
  String get inviteSessionExpired => 'انتهت الجلسة، سجّل الدخول مرة أخرى';

  @override
  String get inviteInvalidPayload =>
      'تأكد من الاسم والبريد وكلمة المرور (8 أحرف على الأقل)';

  @override
  String get inviteCreateFailed => 'تعذر إنشاء الحساب في Supabase';

  @override
  String get inviteEmailUsed => 'البريد الإلكتروني مستخدم مسبقًا';

  @override
  String inviteFailed(Object error) {
    return 'تعذر إنشاء الحساب: $error';
  }

  @override
  String get statsTitle => 'الإحصائيات';

  @override
  String get sessionsStats => 'إحصائيات الجلسات';

  @override
  String get totalSessions => 'عدد الجلسات الإجمالي';

  @override
  String get sessionsMale => 'عدد الجلسات للرجال';

  @override
  String get sessionsFemale => 'عدد الجلسات للنساء';

  @override
  String get sessionsChild => 'عدد الجلسات للأطفال';

  @override
  String get sessionsRatio => 'نسب الجلسات';

  @override
  String get patientsStats => 'إحصائيات المرضى';

  @override
  String get totalPatients => 'عدد المرضى الكلي';

  @override
  String get patientsMale => 'عدد المرضى الرجال';

  @override
  String get patientsFemale => 'عدد المرضى النساء';

  @override
  String get patientsChild => 'عدد المرضى الأطفال';

  @override
  String get patientsRatio => 'نسب المرضى';

  @override
  String statsLoadFailed(Object error) {
    return 'تعذر تحميل الإحصائيات: $error';
  }

  @override
  String get statsByTherapist => 'حسب المختص';

  @override
  String get monthly => 'شهري';

  @override
  String get yearly => 'سنوي';

  @override
  String get overall => 'كلّي';

  @override
  String get yearLabel => 'السنة';

  @override
  String get monthLabel => 'الشهر';

  @override
  String get male => 'رجال';

  @override
  String get female => 'نساء';

  @override
  String get child => 'أطفال';

  @override
  String totalLabel(Object total) {
    return 'المجموع\n$total';
  }

  @override
  String get patientsTitle => 'المرضى';

  @override
  String get patientSearchHint => 'بحث بالاسم أو التشخيص أو الطبيب';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterMale => 'ذكر';

  @override
  String get filterFemale => 'أنثى';

  @override
  String get filterChild => 'طفل';

  @override
  String get currentlyTreating => 'يعالجون الآن';

  @override
  String get finishedTreatment => 'أنهوا العلاج';

  @override
  String get noResults => 'لا توجد نتائج مطابقة';

  @override
  String patientAgeDiagnosis(Object age, Object diagnosis) {
    return 'العمر: $age • التشخيص: $diagnosis';
  }

  @override
  String patientTherapist(Object name) {
    return 'المختص: $name';
  }

  @override
  String get unassignedTherapist => 'غير مبرمج/بدون مختص';

  @override
  String get details => 'تفاصيل';

  @override
  String get loadPatientsFailed => 'تعذر تحميل المرضى';

  @override
  String get deletePatientTitle => 'حذف المريض';

  @override
  String get deletePatientConfirm => 'هل تريد حذف هذا المريض؟';

  @override
  String get delete => 'حذف';

  @override
  String get patientFormTitleAdd => 'إضافة مريض';

  @override
  String get patientFormTitleEdit => 'تعديل مريض';

  @override
  String get noTherapistsYet =>
      'لا يوجد مختصون بعد. أضف مختصًا أولًا قبل إنشاء مريض.';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get nameTooShort => 'الاسم قصير جدًا';

  @override
  String get ageLabel => 'العمر';

  @override
  String get ageMustBeNumber => 'العمر يجب أن يكون رقمًا';

  @override
  String get ageInvalid => 'العمر غير صالح';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get patientStatusLabel => 'حالة المريض';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusCompleted => 'منتهي';

  @override
  String get statusSuspended => 'معلق';

  @override
  String get diagnosisLabel => 'التشخيص';

  @override
  String get advancedFilters => 'فلاتر متقدمة';

  @override
  String get diagnosisFilterLabel => 'تصفية حسب التشخيص';

  @override
  String get doctorFilterLabel => 'تصفية حسب الطبيب';

  @override
  String get recurrenceLabel => 'تكرار المواعيد';

  @override
  String get recurrenceWeekly => 'أسبوعي';

  @override
  String get recurrenceWeekdays => 'أيام محددة';

  @override
  String get weekdayMon => 'الإثنين';

  @override
  String get weekdayTue => 'الثلاثاء';

  @override
  String get weekdayWed => 'الأربعاء';

  @override
  String get weekdayThu => 'الخميس';

  @override
  String get weekdayFri => 'الجمعة';

  @override
  String get weekdaySat => 'السبت';

  @override
  String get weekdaySun => 'الأحد';

  @override
  String get medicalHistoryLabel => 'السوابق الطبية';

  @override
  String get suggestedSessionsLabel => 'عدد الجلسات المقترحة';

  @override
  String get sessionsMustBeNumber => 'عدد الجلسات يجب أن يكون رقمًا';

  @override
  String get sessionsInvalid => 'عدد الجلسات غير صالح';

  @override
  String get therapistLabel => 'المختص المعالج';

  @override
  String get noTherapistOption => 'بدون مختص';

  @override
  String get therapistRequired => 'اختر المختص المعالج';

  @override
  String get createInitialAppointment => 'إنشاء موعد أول للمريض';

  @override
  String get createInitialAppointmentSubtitle =>
      'توزيع الموعد مباشرة على المختص المحدد';

  @override
  String get createAllAppointments => 'إنشاء جميع المواعيد حسب عدد الجلسات';

  @override
  String get createAllAppointmentsSubtitle => 'سيتم جدولة المواعيد أسبوعيًا';

  @override
  String get firstAppointmentDateTime => 'تاريخ ووقت الموعد الأول';

  @override
  String get doctorNameLabel => 'اسم الطبيب المعالج';

  @override
  String get updatedPatient => 'تم تحديث المريض';

  @override
  String get addedPatientWithFirstAppointment =>
      'تمت إضافة المريض مع موعده الأول';

  @override
  String get addedPatient => 'تمت إضافة المريض';

  @override
  String get therapistRequiredFirst => 'اختر المختص المعالج أولاً';

  @override
  String savePatientFailed(Object error) {
    return 'تعذر حفظ بيانات المريض: $error';
  }

  @override
  String get prescriptionImageTitle => 'صورة الوصفة الطبية';

  @override
  String get noImage => 'لا توجد صورة بعد';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get remove => 'إزالة';

  @override
  String get patientDetailsTitle => 'تفاصيل المريض';

  @override
  String get loadPatientDetailsFailed => 'تعذر تحميل تفاصيل المريض';

  @override
  String get patientAuditTitle => 'سجل تغييرات المريض';

  @override
  String get patientAuditEmpty => 'لا توجد تغييرات مسجلة بعد';

  @override
  String get auditCreated => 'تم إنشاء المريض';

  @override
  String get auditUpdated => 'تم تعديل المريض';

  @override
  String get auditDeleted => 'تم حذف المريض';

  @override
  String ageValue(Object age) {
    return 'العمر: $age';
  }

  @override
  String genderValue(Object gender) {
    return 'الجنس: $gender';
  }

  @override
  String diagnosisValue(Object diagnosis) {
    return 'التشخيص: $diagnosis';
  }

  @override
  String medicalHistoryValue(Object history) {
    return 'السوابق الطبية: $history';
  }

  @override
  String doctorValue(Object doctor) {
    return 'الطبيب: $doctor';
  }

  @override
  String phoneValue(Object phone) {
    return 'الهاتف: $phone';
  }

  @override
  String get callPatient => 'اتصال بالمريض';

  @override
  String get callTherapist => 'اتصال بالمختص';

  @override
  String get callFailed => 'تعذر بدء الاتصال';

  @override
  String get prescriptionTitle => 'الوصفة الطبية';

  @override
  String get completed => 'مكتمل';

  @override
  String get missed => 'غياب';

  @override
  String get remaining => 'المتبقي';

  @override
  String get newAppointmentForPatient => 'موعد جديد لهذا المريض';

  @override
  String get editPatientData => 'تعديل بيانات المريض';

  @override
  String get upcomingAppointments => 'المواعيد القادمة';

  @override
  String get noUpcomingAppointments => 'لا توجد مواعيد قادمة';

  @override
  String get sessionsHistory => 'سجل الجلسات';

  @override
  String get noSessionsYet => 'لا يوجد سجل جلسات بعد';

  @override
  String get attendancePresent => 'حضر';

  @override
  String get attendanceAbsent => 'غياب';

  @override
  String get attendanceUnknown => 'غير مؤكد';

  @override
  String appointmentSubtitle(
    Object attendance,
    Object note,
    Object scheduled,
    Object status,
  ) {
    return 'الموعد: $scheduled\nالحالة: $status • الحضور: $attendance\nملاحظة: $note';
  }

  @override
  String get scheduled => 'مجدول';

  @override
  String get canceled => 'ملغى';

  @override
  String get appointmentsTitle => 'المواعيد';

  @override
  String get noPatientsForAppointments => 'أضف مريضًا أولاً قبل إنشاء موعد';

  @override
  String get pickDate => 'اختيار تاريخ';

  @override
  String get unknownPatient => 'مريض غير معروف';

  @override
  String therapistWithTime(Object name, Object time) {
    return 'المختص: $name • $time';
  }

  @override
  String get edit => 'تعديل';

  @override
  String get deleteAction => 'حذف';

  @override
  String get loadAppointmentsFailed => 'تعذر تحميل المواعيد';

  @override
  String get addAppointment => 'إضافة موعد جديد';

  @override
  String get filterAllLabel => 'الكل';

  @override
  String get filterScheduled => 'مجدول';

  @override
  String get filterCompleted => 'مكتمل';

  @override
  String get filterMissed => 'غياب';

  @override
  String get filterCanceled => 'ملغى';

  @override
  String get appointmentFormTitleAdd => 'إضافة موعد';

  @override
  String get appointmentFormTitleEdit => 'تعديل موعد';

  @override
  String get patientLabel => 'المريض';

  @override
  String get therapistLabelShort => 'المختص';

  @override
  String get appointmentDateTime => 'تاريخ ووقت الموعد';

  @override
  String get dateLabel => 'التاريخ (YYYY-MM-DD)';

  @override
  String get timeLabel => 'الوقت (HH:mm)';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get pickPatientTherapist => 'اختر المريض والمختص أولاً';

  @override
  String get appointmentUpdated => 'تم تعديل الموعد';

  @override
  String get appointmentCreated => 'تم إنشاء موعد';

  @override
  String appointmentUpdatedWithReminder(Object minutes) {
    return 'تم تعديل الموعد (تذكير: $minutes دقيقة)';
  }

  @override
  String appointmentCreatedWithReminder(Object minutes) {
    return 'تم إنشاء موعد بعد $minutes دقيقة';
  }

  @override
  String get reminderTitle => 'تذكير بالموعد';

  @override
  String reminderBody(Object minutes) {
    return 'لديك موعد بعد $minutes دقيقة';
  }

  @override
  String reminderBodyNoName(Object minutes, Object time) {
    return 'موعدك الساعة $time (بعد $minutes دقيقة)';
  }

  @override
  String reminderBodyWithName(Object minutes, Object name, Object time) {
    return 'موعد $name الساعة $time (بعد $minutes دقيقة)';
  }

  @override
  String get syncCompleteTitle => 'تمت المزامنة';

  @override
  String get syncCompleteBody => 'تم تحديث البيانات بنجاح';

  @override
  String get invalidDate => 'صيغة التاريخ غير صحيحة';

  @override
  String get invalidTime => 'صيغة الوقت غير صحيحة';

  @override
  String get invalidTimeValue => 'الوقت غير صالح';

  @override
  String get appointmentDetailsTitle => 'تفاصيل الموعد';

  @override
  String patientLabelValue(Object name) {
    return 'المريض: $name';
  }

  @override
  String therapistLabelValue(Object name) {
    return 'المختص: $name';
  }

  @override
  String timeLabelValue(Object time) {
    return 'الوقت: $time';
  }

  @override
  String statusLabelValue(Object status) {
    return 'الحالة: $status';
  }

  @override
  String get markPresent => 'تأشير حضور';

  @override
  String get markAbsent => 'تسجيل غياب';

  @override
  String get noteSaved => 'تم حفظ الملاحظة';

  @override
  String noteSavedFor(Object name) {
    return 'تم حفظ ملاحظة جلسة $name';
  }

  @override
  String get attendanceMarked => 'تم تأشير الحضور';

  @override
  String get absenceMarked => 'تم تسجيل الغياب';

  @override
  String get sessionDetails => 'تفاصيل الجلسة';

  @override
  String attendance(Object value) {
    return 'الحضور: $value';
  }

  @override
  String sessionTime(Object time) {
    return 'الوقت: $time';
  }

  @override
  String get sessionNote => 'ملاحظة الجلسة';

  @override
  String get noSessionDetails => 'لا توجد تفاصيل جلسة بعد';

  @override
  String get dashboardToday => 'اليوم';

  @override
  String get dashboardAppointments => 'المواعيد';

  @override
  String get dashboardPatients => 'المرضى';

  @override
  String get dashboardTherapists => 'المختصون';

  @override
  String get dashboardStats => 'الإحصائيات';

  @override
  String get dashboardSettings => 'الإعدادات';

  @override
  String get dashboardCustomizeTitle => 'تخصيص الشاشة الرئيسية';

  @override
  String get dashboardCustomizeSubtitle => 'إظهار/إخفاء وترتيب التبويبات';

  @override
  String get todaySessions => 'جلسات اليوم';

  @override
  String get noSessionsToday => 'لا توجد جلسات في هذا اليوم';

  @override
  String get loadTodayPatientsFailed => 'تعذر تحميل المرضى';

  @override
  String get loadTodayAppointmentsFailed => 'تعذر تحميل مواعيد اليوم';

  @override
  String timeStatusLine(Object status, Object time) {
    return 'الوقت: $time • الحالة: $status';
  }
}
