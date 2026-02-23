import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/change_password_screen.dart';
import '../../features/auth/presentation/reauth_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/patients/presentation/patients_screen.dart';
import '../../features/patients/presentation/patient_form_screen.dart';
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/appointments/presentation/appointment_form_screen.dart';
import '../../features/appointments/presentation/appointment_details_screen.dart';
import '../../features/appointments/domain/appointment.dart';
import '../../features/therapists/presentation/therapists_screen.dart';
import '../../features/therapists/presentation/therapist_form_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/notification_log_screen.dart';
import '../../features/dashboard/presentation/dashboard_customize_screen.dart';

class AppRouter {
  static const String initialRoute = LoginScreen.routeName;

  static final Map<String, WidgetBuilder> routes = {
    LoginScreen.routeName: (_) => const LoginScreen(),
    RegisterScreen.routeName: (_) => const RegisterScreen(),
    ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
    ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
    ReauthScreen.routeName: (_) => const ReauthScreen(),
    DashboardScreen.routeName: (_) => const DashboardScreen(),
    PatientsScreen.routeName: (_) => const PatientsScreen(),
    PatientFormScreen.routeName: (_) => const PatientFormScreen(),
    AppointmentsScreen.routeName: (_) => const AppointmentsScreen(),
    AppointmentFormScreen.routeName: (_) => const AppointmentFormScreen(),
    AppointmentDetailsScreen.routeName: (_) => AppointmentDetailsScreen(
      appointment: Appointment(
        id: '',
        patientId: '',
        therapistId: '',
        scheduledAt: DateTime(2000),
        status: 'scheduled',
      ),
      patientName: '',
      therapistName: '',
    ),
    TherapistsScreen.routeName: (_) => const TherapistsScreen(),
    TherapistFormScreen.routeName: (_) => const TherapistFormScreen(),
    StatsScreen.routeName: (_) => const StatsScreen(),
    SettingsScreen.routeName: (_) => const SettingsScreen(),
    NotificationLogScreen.routeName: (_) => const NotificationLogScreen(),
    DashboardCustomizeScreen.routeName: (_) => const DashboardCustomizeScreen(),
  };
}
