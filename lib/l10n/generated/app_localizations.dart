import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'physio_manager'**
  String get appTitle;

  /// No description provided for @online.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get offline;

  /// No description provided for @syncing.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة…'**
  String get syncing;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @therapistNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المختص'**
  String get therapistNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @invalidCredentials.
  ///
  /// In ar, this message translates to:
  /// **'بيانات غير صحيحة'**
  String get invalidCredentials;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @onlyAdminCreatesAccounts.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحسابات يتم من طرف المسؤول فقط'**
  String get onlyAdminCreatesAccounts;

  /// No description provided for @reauthTitle.
  ///
  /// In ar, this message translates to:
  /// **'الجلسة مقفلة'**
  String get reauthTitle;

  /// No description provided for @reauthSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة بالحساب {email}'**
  String reauthSubtitle(Object email);

  /// No description provided for @reauthButton.
  ///
  /// In ar, this message translates to:
  /// **'فتح الجلسة'**
  String get reauthButton;

  /// No description provided for @reauthNeedsInternet.
  ///
  /// In ar, this message translates to:
  /// **'يلزم اتصال الإنترنت لفتح الجلسة'**
  String get reauthNeedsInternet;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الجلسة الحالية على هذا الجهاز'**
  String get logoutSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل جديد'**
  String get registerTitle;

  /// No description provided for @registerButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل'**
  String get registerButton;

  /// No description provided for @accountCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح'**
  String get accountCreated;

  /// No description provided for @signUpConfirmEmail.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب. يرجى تأكيد البريد الإلكتروني ثم تسجيل الدخول.'**
  String get signUpConfirmEmail;

  /// No description provided for @signUpAuthSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إنشاء الحساب في نظام المصادقة. تحقق من إعدادات Auth في Supabase.'**
  String get signUpAuthSaveFailed;

  /// No description provided for @signUpRateLimit.
  ///
  /// In ar, this message translates to:
  /// **'تم تجاوز حد محاولات البريد. انتظر قليلًا ثم أعد المحاولة.'**
  String get signUpRateLimit;

  /// No description provided for @signUpEmailNotConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'الحساب يحتاج تأكيد البريد الإلكتروني قبل تسجيل الدخول.'**
  String get signUpEmailNotConfirmed;

  /// No description provided for @signUpInvalidApiKey.
  ///
  /// In ar, this message translates to:
  /// **'مفتاح Supabase غير صحيح في إعدادات التطبيق.'**
  String get signUpInvalidApiKey;

  /// No description provided for @signUpEmailUsed.
  ///
  /// In ar, this message translates to:
  /// **'هذا البريد مسجل مسبقًا.'**
  String get signUpEmailUsed;

  /// No description provided for @signUpInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'صيغة البريد الإلكتروني غير صحيحة.'**
  String get signUpInvalidEmail;

  /// No description provided for @signUpPasswordInvalid.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور لا تحقق الشروط المطلوبة.'**
  String get signUpPasswordInvalid;

  /// No description provided for @signUpFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الحساب: {error}'**
  String signUpFailed(Object error);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'استعادة كلمة المرور'**
  String get resetPasswordTitle;

  /// No description provided for @enterEmail.
  ///
  /// In ar, this message translates to:
  /// **'أدخل البريد الإلكتروني'**
  String get enterEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرابط'**
  String get sendResetLink;

  /// No description provided for @sending.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الإرسال...'**
  String get sending;

  /// No description provided for @resetLinkSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط إعادة تعيين كلمة المرور'**
  String get resetLinkSent;

  /// No description provided for @resetLinkFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال الرابط'**
  String get resetLinkFailed;

  /// No description provided for @changePasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePasswordTitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordMin.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور 8 أحرف على الأقل'**
  String get passwordMin;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get passwordsNotMatch;

  /// No description provided for @passwordUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث كلمة المرور'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث كلمة المرور'**
  String get passwordUpdateFailed;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الحفظ...'**
  String get saving;

  /// No description provided for @update.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get update;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @notificationsEnabledTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get notificationsEnabledTitle;

  /// No description provided for @notificationsEnabledSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل/إيقاف الإشعارات المحلية'**
  String get notificationsEnabledSubtitle;

  /// No description provided for @reminderBeforeAppointment.
  ///
  /// In ar, this message translates to:
  /// **'قبل الموعد بـ {minutes} دقيقة'**
  String reminderBeforeAppointment(Object minutes);

  /// No description provided for @notificationLogTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الإشعارات'**
  String get notificationLogTitle;

  /// No description provided for @notificationLogSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض الإشعارات الأخيرة داخل التطبيق'**
  String get notificationLogSubtitle;

  /// No description provided for @notificationLogEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات بعد'**
  String get notificationLogEmpty;

  /// No description provided for @notificationLogLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل السجل'**
  String get notificationLogLoadFailed;

  /// No description provided for @clearAll.
  ///
  /// In ar, this message translates to:
  /// **'مسح الكل'**
  String get clearAll;

  /// No description provided for @languageTitle.
  ///
  /// In ar, this message translates to:
  /// **'لغة التطبيق'**
  String get languageTitle;

  /// No description provided for @changePasswordMenuTitle.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePasswordMenuTitle;

  /// No description provided for @changePasswordMenuSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل كلمة المرور الحالية'**
  String get changePasswordMenuSubtitle;

  /// No description provided for @noteAutoSaveTitle.
  ///
  /// In ar, this message translates to:
  /// **'مدة حفظ الملاحظة تلقائيًا'**
  String get noteAutoSaveTitle;

  /// No description provided for @noteAutoSaveSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'بعد التوقف بـ {ms}ms'**
  String noteAutoSaveSubtitle(Object ms);

  /// No description provided for @syncEnabledTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل المزامنة'**
  String get syncEnabledTitle;

  /// No description provided for @syncEnabledSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة تلقائية كل 5 دقائق + Realtime'**
  String get syncEnabledSubtitle;

  /// No description provided for @lastSyncTitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر مزامنة'**
  String get lastSyncTitle;

  /// No description provided for @lastSyncNever.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم مزامنة بعد'**
  String get lastSyncNever;

  /// No description provided for @lastSyncLoading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل...'**
  String get lastSyncLoading;

  /// No description provided for @lastSyncUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get lastSyncUnavailable;

  /// No description provided for @syncNow.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة الآن'**
  String get syncNow;

  /// No description provided for @syncDone.
  ///
  /// In ar, this message translates to:
  /// **'تمت المزامنة'**
  String get syncDone;

  /// No description provided for @chooseLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get chooseLanguage;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In ar, this message translates to:
  /// **'استخدام لغة الجهاز'**
  String get useDeviceLanguage;

  /// No description provided for @langArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langFrench.
  ///
  /// In ar, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @chooseReminder.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدة التذكير'**
  String get chooseReminder;

  /// No description provided for @chooseNoteDelay.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدة حفظ الملاحظة'**
  String get chooseNoteDelay;

  /// No description provided for @minutesUnit.
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get minutesUnit;

  /// No description provided for @millisecondsUnit.
  ///
  /// In ar, this message translates to:
  /// **'مللي ثانية'**
  String get millisecondsUnit;

  /// No description provided for @therapistsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المختصين'**
  String get therapistsTitle;

  /// No description provided for @addTherapist.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مختص جديد'**
  String get addTherapist;

  /// No description provided for @therapistFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مختص'**
  String get therapistFormTitleAdd;

  /// No description provided for @therapistFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مختص'**
  String get therapistFormTitleEdit;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In ar, this message translates to:
  /// **'User ID (من Supabase Auth)'**
  String get userIdLabel;

  /// No description provided for @adminRoleLabel.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية المسؤول'**
  String get adminRoleLabel;

  /// No description provided for @primary.
  ///
  /// In ar, this message translates to:
  /// **'رئيسي'**
  String get primary;

  /// No description provided for @therapist.
  ///
  /// In ar, this message translates to:
  /// **'مختص'**
  String get therapist;

  /// No description provided for @makeAdmin.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كمسؤول'**
  String get makeAdmin;

  /// No description provided for @removeAdmin.
  ///
  /// In ar, this message translates to:
  /// **'إزالة صلاحية المسؤول'**
  String get removeAdmin;

  /// No description provided for @maxAdmins.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى للمسؤولين هو 2'**
  String get maxAdmins;

  /// No description provided for @minOneAdmin.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يبقى مسؤول واحد على الأقل'**
  String get minOneAdmin;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirmMakeAdmin.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد منح {name} صلاحية المسؤول؟'**
  String confirmMakeAdmin(Object name);

  /// No description provided for @confirmRemoveAdmin.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد إزالة صلاحية المسؤول من {name}؟'**
  String confirmRemoveAdmin(Object name);

  /// No description provided for @adminGranted.
  ///
  /// In ar, this message translates to:
  /// **'تم منح {name} صلاحية المسؤول'**
  String adminGranted(Object name);

  /// No description provided for @adminRemoved.
  ///
  /// In ar, this message translates to:
  /// **'تمت إزالة صلاحية المسؤول من {name}'**
  String adminRemoved(Object name);

  /// No description provided for @updateAdminFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث صلاحية المسؤول: {error}'**
  String updateAdminFailed(Object error);

  /// No description provided for @loadTherapistsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المختصين'**
  String get loadTherapistsFailed;

  /// No description provided for @inviteTherapistTitle.
  ///
  /// In ar, this message translates to:
  /// **'دعوة مختص جديد'**
  String get inviteTherapistTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullNameLabel;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم مطلوب'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد مطلوب'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'بريد غير صالح'**
  String get invalidEmail;

  /// No description provided for @tempPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور المؤقتة'**
  String get tempPasswordLabel;

  /// No description provided for @tempPasswordMin.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 8 أحرف على الأقل'**
  String get tempPasswordMin;

  /// No description provided for @createTherapistSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء حساب المختص بنجاح'**
  String get createTherapistSuccess;

  /// No description provided for @createTherapist.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب مختص'**
  String get createTherapist;

  /// No description provided for @creating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الإنشاء...'**
  String get creating;

  /// No description provided for @inviteNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة: هذه الشاشة تعتمد على Edge Function باسم admin-create-user.'**
  String get inviteNote;

  /// No description provided for @inviteNoPermission.
  ///
  /// In ar, this message translates to:
  /// **'لا تملك صلاحية إنشاء مختصين'**
  String get inviteNoPermission;

  /// No description provided for @inviteServerKeyMissing.
  ///
  /// In ar, this message translates to:
  /// **'خطأ إعدادات السيرفر: مفتاح الخدمة غير مضبوط'**
  String get inviteServerKeyMissing;

  /// No description provided for @inviteSessionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الجلسة، سجّل الدخول مرة أخرى'**
  String get inviteSessionExpired;

  /// No description provided for @inviteInvalidPayload.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من الاسم والبريد وكلمة المرور (8 أحرف على الأقل)'**
  String get inviteInvalidPayload;

  /// No description provided for @inviteCreateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الحساب في Supabase'**
  String get inviteCreateFailed;

  /// No description provided for @inviteEmailUsed.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مستخدم مسبقًا'**
  String get inviteEmailUsed;

  /// No description provided for @inviteFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الحساب: {error}'**
  String inviteFailed(Object error);

  /// No description provided for @statsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get statsTitle;

  /// No description provided for @sessionsStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات الجلسات'**
  String get sessionsStats;

  /// No description provided for @totalSessions.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات الإجمالي'**
  String get totalSessions;

  /// No description provided for @sessionsMale.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات للرجال'**
  String get sessionsMale;

  /// No description provided for @sessionsFemale.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات للنساء'**
  String get sessionsFemale;

  /// No description provided for @sessionsChild.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات للأطفال'**
  String get sessionsChild;

  /// No description provided for @sessionsRatio.
  ///
  /// In ar, this message translates to:
  /// **'نسب الجلسات'**
  String get sessionsRatio;

  /// No description provided for @patientsStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات المرضى'**
  String get patientsStats;

  /// No description provided for @totalPatients.
  ///
  /// In ar, this message translates to:
  /// **'عدد المرضى الكلي'**
  String get totalPatients;

  /// No description provided for @patientsMale.
  ///
  /// In ar, this message translates to:
  /// **'عدد المرضى الرجال'**
  String get patientsMale;

  /// No description provided for @patientsFemale.
  ///
  /// In ar, this message translates to:
  /// **'عدد المرضى النساء'**
  String get patientsFemale;

  /// No description provided for @patientsChild.
  ///
  /// In ar, this message translates to:
  /// **'عدد المرضى الأطفال'**
  String get patientsChild;

  /// No description provided for @patientsRatio.
  ///
  /// In ar, this message translates to:
  /// **'نسب المرضى'**
  String get patientsRatio;

  /// No description provided for @statsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل الإحصائيات: {error}'**
  String statsLoadFailed(Object error);

  /// No description provided for @statsByTherapist.
  ///
  /// In ar, this message translates to:
  /// **'حسب المختص'**
  String get statsByTherapist;

  /// No description provided for @monthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In ar, this message translates to:
  /// **'سنوي'**
  String get yearly;

  /// No description provided for @overall.
  ///
  /// In ar, this message translates to:
  /// **'كلّي'**
  String get overall;

  /// No description provided for @yearLabel.
  ///
  /// In ar, this message translates to:
  /// **'السنة'**
  String get yearLabel;

  /// No description provided for @monthLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get monthLabel;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'رجال'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'نساء'**
  String get female;

  /// No description provided for @child.
  ///
  /// In ar, this message translates to:
  /// **'أطفال'**
  String get child;

  /// No description provided for @totalLabel.
  ///
  /// In ar, this message translates to:
  /// **'المجموع\n{total}'**
  String totalLabel(Object total);

  /// No description provided for @patientsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المرضى'**
  String get patientsTitle;

  /// No description provided for @patientSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث بالاسم أو التشخيص أو الطبيب'**
  String get patientSearchHint;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterMale.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get filterMale;

  /// No description provided for @filterFemale.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get filterFemale;

  /// No description provided for @filterChild.
  ///
  /// In ar, this message translates to:
  /// **'طفل'**
  String get filterChild;

  /// No description provided for @currentlyTreating.
  ///
  /// In ar, this message translates to:
  /// **'يعالجون الآن'**
  String get currentlyTreating;

  /// No description provided for @finishedTreatment.
  ///
  /// In ar, this message translates to:
  /// **'أنهوا العلاج'**
  String get finishedTreatment;

  /// No description provided for @noResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get noResults;

  /// No description provided for @patientAgeDiagnosis.
  ///
  /// In ar, this message translates to:
  /// **'العمر: {age} • التشخيص: {diagnosis}'**
  String patientAgeDiagnosis(Object age, Object diagnosis);

  /// No description provided for @patientTherapist.
  ///
  /// In ar, this message translates to:
  /// **'المختص: {name}'**
  String patientTherapist(Object name);

  /// No description provided for @unassignedTherapist.
  ///
  /// In ar, this message translates to:
  /// **'غير مبرمج/بدون مختص'**
  String get unassignedTherapist;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل'**
  String get details;

  /// No description provided for @loadPatientsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المرضى'**
  String get loadPatientsFailed;

  /// No description provided for @deletePatientTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف المريض'**
  String get deletePatientTitle;

  /// No description provided for @deletePatientConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا المريض؟'**
  String get deletePatientConfirm;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @patientFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مريض'**
  String get patientFormTitleAdd;

  /// No description provided for @patientFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مريض'**
  String get patientFormTitleEdit;

  /// No description provided for @noTherapistsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد مختصون بعد. أضف مختصًا أولًا قبل إنشاء مريض.'**
  String get noTherapistsYet;

  /// No description provided for @fullNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل مطلوب'**
  String get fullNameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'الاسم قصير جدًا'**
  String get nameTooShort;

  /// No description provided for @ageLabel.
  ///
  /// In ar, this message translates to:
  /// **'العمر'**
  String get ageLabel;

  /// No description provided for @ageMustBeNumber.
  ///
  /// In ar, this message translates to:
  /// **'العمر يجب أن يكون رقمًا'**
  String get ageMustBeNumber;

  /// No description provided for @ageInvalid.
  ///
  /// In ar, this message translates to:
  /// **'العمر غير صالح'**
  String get ageInvalid;

  /// No description provided for @genderLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get genderLabel;

  /// No description provided for @patientStatusLabel.
  ///
  /// In ar, this message translates to:
  /// **'حالة المريض'**
  String get patientStatusLabel;

  /// No description provided for @statusNotStarted.
  ///
  /// In ar, this message translates to:
  /// **'لم يبدأ العلاج'**
  String get statusNotStarted;

  /// No description provided for @statusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'منتهي'**
  String get statusCompleted;

  /// No description provided for @statusSuspended.
  ///
  /// In ar, this message translates to:
  /// **'معلق'**
  String get statusSuspended;

  /// No description provided for @diagnosisLabel.
  ///
  /// In ar, this message translates to:
  /// **'التشخيص'**
  String get diagnosisLabel;

  /// No description provided for @advancedFilters.
  ///
  /// In ar, this message translates to:
  /// **'فلاتر متقدمة'**
  String get advancedFilters;

  /// No description provided for @diagnosisFilterLabel.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب التشخيص'**
  String get diagnosisFilterLabel;

  /// No description provided for @doctorFilterLabel.
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الطبيب'**
  String get doctorFilterLabel;

  /// No description provided for @recurrenceLabel.
  ///
  /// In ar, this message translates to:
  /// **'تكرار المواعيد'**
  String get recurrenceLabel;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعي'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceWeekdays.
  ///
  /// In ar, this message translates to:
  /// **'أيام محددة'**
  String get recurrenceWeekdays;

  /// No description provided for @weekdayMon.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get weekdaySun;

  /// No description provided for @medicalHistoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'السوابق الطبية'**
  String get medicalHistoryLabel;

  /// No description provided for @suggestedSessionsLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات المقترحة'**
  String get suggestedSessionsLabel;

  /// No description provided for @sessionsMustBeNumber.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات يجب أن يكون رقمًا'**
  String get sessionsMustBeNumber;

  /// No description provided for @sessionsInvalid.
  ///
  /// In ar, this message translates to:
  /// **'عدد الجلسات غير صالح'**
  String get sessionsInvalid;

  /// No description provided for @therapistLabel.
  ///
  /// In ar, this message translates to:
  /// **'المختص المعالج'**
  String get therapistLabel;

  /// No description provided for @noTherapistOption.
  ///
  /// In ar, this message translates to:
  /// **'بدون مختص'**
  String get noTherapistOption;

  /// No description provided for @therapistRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختر المختص المعالج'**
  String get therapistRequired;

  /// No description provided for @createInitialAppointment.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء موعد أول للمريض'**
  String get createInitialAppointment;

  /// No description provided for @createInitialAppointmentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'توزيع الموعد مباشرة على المختص المحدد'**
  String get createInitialAppointmentSubtitle;

  /// No description provided for @createAllAppointments.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء جميع المواعيد حسب عدد الجلسات'**
  String get createAllAppointments;

  /// No description provided for @createAllAppointmentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سيتم جدولة المواعيد أسبوعيًا'**
  String get createAllAppointmentsSubtitle;

  /// No description provided for @firstAppointmentDateTime.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ ووقت الموعد الأول'**
  String get firstAppointmentDateTime;

  /// No description provided for @doctorNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الطبيب المعالج'**
  String get doctorNameLabel;

  /// No description provided for @updatedPatient.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المريض'**
  String get updatedPatient;

  /// No description provided for @addedPatientWithFirstAppointment.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المريض مع موعده الأول'**
  String get addedPatientWithFirstAppointment;

  /// No description provided for @addedPatient.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المريض'**
  String get addedPatient;

  /// No description provided for @therapistRequiredFirst.
  ///
  /// In ar, this message translates to:
  /// **'اختر المختص المعالج أولاً'**
  String get therapistRequiredFirst;

  /// No description provided for @savePatientFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ بيانات المريض: {error}'**
  String savePatientFailed(Object error);

  /// No description provided for @prescriptionImageTitle.
  ///
  /// In ar, this message translates to:
  /// **'صورة الوصفة الطبية'**
  String get prescriptionImageTitle;

  /// No description provided for @noImage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صورة بعد'**
  String get noImage;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get takePhoto;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get remove;

  /// No description provided for @patientDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المريض'**
  String get patientDetailsTitle;

  /// No description provided for @loadPatientDetailsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل تفاصيل المريض'**
  String get loadPatientDetailsFailed;

  /// No description provided for @patientAuditTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل تغييرات المريض'**
  String get patientAuditTitle;

  /// No description provided for @patientAuditEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تغييرات مسجلة بعد'**
  String get patientAuditEmpty;

  /// No description provided for @auditCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء المريض'**
  String get auditCreated;

  /// No description provided for @auditUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل المريض'**
  String get auditUpdated;

  /// No description provided for @auditDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المريض'**
  String get auditDeleted;

  /// No description provided for @ageValue.
  ///
  /// In ar, this message translates to:
  /// **'العمر: {age}'**
  String ageValue(Object age);

  /// No description provided for @genderValue.
  ///
  /// In ar, this message translates to:
  /// **'الجنس: {gender}'**
  String genderValue(Object gender);

  /// No description provided for @diagnosisValue.
  ///
  /// In ar, this message translates to:
  /// **'التشخيص: {diagnosis}'**
  String diagnosisValue(Object diagnosis);

  /// No description provided for @medicalHistoryValue.
  ///
  /// In ar, this message translates to:
  /// **'السوابق الطبية: {history}'**
  String medicalHistoryValue(Object history);

  /// No description provided for @doctorValue.
  ///
  /// In ar, this message translates to:
  /// **'الطبيب: {doctor}'**
  String doctorValue(Object doctor);

  /// No description provided for @phoneValue.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف: {phone}'**
  String phoneValue(Object phone);

  /// No description provided for @callPatient.
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالمريض'**
  String get callPatient;

  /// No description provided for @callTherapist.
  ///
  /// In ar, this message translates to:
  /// **'اتصال بالمختص'**
  String get callTherapist;

  /// No description provided for @callFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر بدء الاتصال'**
  String get callFailed;

  /// No description provided for @prescriptionTitle.
  ///
  /// In ar, this message translates to:
  /// **'الوصفة الطبية'**
  String get prescriptionTitle;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get completed;

  /// No description provided for @missed.
  ///
  /// In ar, this message translates to:
  /// **'غياب'**
  String get missed;

  /// No description provided for @remaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get remaining;

  /// No description provided for @newAppointmentForPatient.
  ///
  /// In ar, this message translates to:
  /// **'موعد جديد لهذا المريض'**
  String get newAppointmentForPatient;

  /// No description provided for @editPatientData.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات المريض'**
  String get editPatientData;

  /// No description provided for @upcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد القادمة'**
  String get upcomingAppointments;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد قادمة'**
  String get noUpcomingAppointments;

  /// No description provided for @sessionsHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الجلسات'**
  String get sessionsHistory;

  /// No description provided for @noSessionsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سجل جلسات بعد'**
  String get noSessionsYet;

  /// No description provided for @attendancePresent.
  ///
  /// In ar, this message translates to:
  /// **'حضر'**
  String get attendancePresent;

  /// No description provided for @attendanceAbsent.
  ///
  /// In ar, this message translates to:
  /// **'غياب'**
  String get attendanceAbsent;

  /// No description provided for @attendanceUnknown.
  ///
  /// In ar, this message translates to:
  /// **'غير مؤكد'**
  String get attendanceUnknown;

  /// No description provided for @appointmentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الموعد: {scheduled}\nالحالة: {status} • الحضور: {attendance}\nملاحظة: {note}'**
  String appointmentSubtitle(
    Object attendance,
    Object note,
    Object scheduled,
    Object status,
  );

  /// No description provided for @scheduled.
  ///
  /// In ar, this message translates to:
  /// **'مجدول'**
  String get scheduled;

  /// No description provided for @canceled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get canceled;

  /// No description provided for @appointmentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد'**
  String get appointmentsTitle;

  /// No description provided for @noPatientsForAppointments.
  ///
  /// In ar, this message translates to:
  /// **'أضف مريضًا أولاً قبل إنشاء موعد'**
  String get noPatientsForAppointments;

  /// No description provided for @pickDate.
  ///
  /// In ar, this message translates to:
  /// **'اختيار تاريخ'**
  String get pickDate;

  /// No description provided for @unknownPatient.
  ///
  /// In ar, this message translates to:
  /// **'مريض غير معروف'**
  String get unknownPatient;

  /// No description provided for @therapistWithTime.
  ///
  /// In ar, this message translates to:
  /// **'المختص: {name} • {time}'**
  String therapistWithTime(Object name, Object time);

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @deleteAction.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get deleteAction;

  /// No description provided for @loadAppointmentsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المواعيد'**
  String get loadAppointmentsFailed;

  /// No description provided for @addAppointment.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد جديد'**
  String get addAppointment;

  /// No description provided for @filterAllLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAllLabel;

  /// No description provided for @filterScheduled.
  ///
  /// In ar, this message translates to:
  /// **'مجدول'**
  String get filterScheduled;

  /// No description provided for @filterCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get filterCompleted;

  /// No description provided for @filterMissed.
  ///
  /// In ar, this message translates to:
  /// **'غياب'**
  String get filterMissed;

  /// No description provided for @filterCanceled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get filterCanceled;

  /// No description provided for @appointmentFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد'**
  String get appointmentFormTitleAdd;

  /// No description provided for @appointmentFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل موعد'**
  String get appointmentFormTitleEdit;

  /// No description provided for @patientLabel.
  ///
  /// In ar, this message translates to:
  /// **'المريض'**
  String get patientLabel;

  /// No description provided for @therapistLabelShort.
  ///
  /// In ar, this message translates to:
  /// **'المختص'**
  String get therapistLabelShort;

  /// No description provided for @appointmentDateTime.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ ووقت الموعد'**
  String get appointmentDateTime;

  /// No description provided for @dateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ (YYYY-MM-DD)'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوقت (HH:mm)'**
  String get timeLabel;

  /// No description provided for @statusLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get statusLabel;

  /// No description provided for @pickPatientTherapist.
  ///
  /// In ar, this message translates to:
  /// **'اختر المريض والمختص أولاً'**
  String get pickPatientTherapist;

  /// No description provided for @appointmentUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الموعد'**
  String get appointmentUpdated;

  /// No description provided for @appointmentCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء موعد'**
  String get appointmentCreated;

  /// No description provided for @appointmentUpdatedWithReminder.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الموعد (تذكير: {minutes} دقيقة)'**
  String appointmentUpdatedWithReminder(Object minutes);

  /// No description provided for @appointmentCreatedWithReminder.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء موعد بعد {minutes} دقيقة'**
  String appointmentCreatedWithReminder(Object minutes);

  /// No description provided for @reminderTitle.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بالموعد'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In ar, this message translates to:
  /// **'لديك موعد بعد {minutes} دقيقة'**
  String reminderBody(Object minutes);

  /// No description provided for @reminderBodyNoName.
  ///
  /// In ar, this message translates to:
  /// **'موعدك الساعة {time} (بعد {minutes} دقيقة)'**
  String reminderBodyNoName(Object minutes, Object time);

  /// No description provided for @reminderBodyWithName.
  ///
  /// In ar, this message translates to:
  /// **'موعد {name} الساعة {time} (بعد {minutes} دقيقة)'**
  String reminderBodyWithName(Object minutes, Object name, Object time);

  /// No description provided for @syncCompleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'تمت المزامنة'**
  String get syncCompleteTitle;

  /// No description provided for @syncCompleteBody.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث البيانات بنجاح'**
  String get syncCompleteBody;

  /// No description provided for @invalidDate.
  ///
  /// In ar, this message translates to:
  /// **'صيغة التاريخ غير صحيحة'**
  String get invalidDate;

  /// No description provided for @invalidTime.
  ///
  /// In ar, this message translates to:
  /// **'صيغة الوقت غير صحيحة'**
  String get invalidTime;

  /// No description provided for @invalidTimeValue.
  ///
  /// In ar, this message translates to:
  /// **'الوقت غير صالح'**
  String get invalidTimeValue;

  /// No description provided for @appointmentDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الموعد'**
  String get appointmentDetailsTitle;

  /// No description provided for @patientLabelValue.
  ///
  /// In ar, this message translates to:
  /// **'المريض: {name}'**
  String patientLabelValue(Object name);

  /// No description provided for @therapistLabelValue.
  ///
  /// In ar, this message translates to:
  /// **'المختص: {name}'**
  String therapistLabelValue(Object name);

  /// No description provided for @timeLabelValue.
  ///
  /// In ar, this message translates to:
  /// **'الوقت: {time}'**
  String timeLabelValue(Object time);

  /// No description provided for @statusLabelValue.
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {status}'**
  String statusLabelValue(Object status);

  /// No description provided for @markPresent.
  ///
  /// In ar, this message translates to:
  /// **'تأشير حضور'**
  String get markPresent;

  /// No description provided for @markAbsent.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل غياب'**
  String get markAbsent;

  /// No description provided for @noteSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملاحظة'**
  String get noteSaved;

  /// No description provided for @noteSavedFor.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ ملاحظة جلسة {name}'**
  String noteSavedFor(Object name);

  /// No description provided for @attendanceMarked.
  ///
  /// In ar, this message translates to:
  /// **'تم تأشير الحضور'**
  String get attendanceMarked;

  /// No description provided for @absenceMarked.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الغياب'**
  String get absenceMarked;

  /// No description provided for @sessionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الجلسة'**
  String get sessionDetails;

  /// No description provided for @attendance.
  ///
  /// In ar, this message translates to:
  /// **'الحضور: {value}'**
  String attendance(Object value);

  /// No description provided for @sessionTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت: {time}'**
  String sessionTime(Object time);

  /// No description provided for @sessionNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة الجلسة'**
  String get sessionNote;

  /// No description provided for @noSessionDetails.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تفاصيل جلسة بعد'**
  String get noSessionDetails;

  /// No description provided for @dashboardToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get dashboardToday;

  /// No description provided for @dashboardAppointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد'**
  String get dashboardAppointments;

  /// No description provided for @dashboardPatients.
  ///
  /// In ar, this message translates to:
  /// **'المرضى'**
  String get dashboardPatients;

  /// No description provided for @dashboardTherapists.
  ///
  /// In ar, this message translates to:
  /// **'المختصون'**
  String get dashboardTherapists;

  /// No description provided for @dashboardStats.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get dashboardStats;

  /// No description provided for @dashboardSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get dashboardSettings;

  /// No description provided for @dashboardCustomizeTitle.
  ///
  /// In ar, this message translates to:
  /// **'تخصيص الشاشة الرئيسية'**
  String get dashboardCustomizeTitle;

  /// No description provided for @dashboardCustomizeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إظهار/إخفاء وترتيب التبويبات'**
  String get dashboardCustomizeSubtitle;

  /// No description provided for @todaySessions.
  ///
  /// In ar, this message translates to:
  /// **'جلسات اليوم'**
  String get todaySessions;

  /// No description provided for @noSessionsToday.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جلسات في هذا اليوم'**
  String get noSessionsToday;

  /// No description provided for @loadTodayPatientsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المرضى'**
  String get loadTodayPatientsFailed;

  /// No description provided for @loadTodayAppointmentsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل مواعيد اليوم'**
  String get loadTodayAppointmentsFailed;

  /// No description provided for @timeStatusLine.
  ///
  /// In ar, this message translates to:
  /// **'الوقت: {time} • الحالة: {status}'**
  String timeStatusLine(Object status, Object time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
