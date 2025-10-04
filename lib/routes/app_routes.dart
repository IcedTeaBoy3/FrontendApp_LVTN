import 'package:go_router/go_router.dart';
import 'package:frontend_app/screens/login/login_screen.dart';
import 'package:frontend_app/screens/home/home_screen.dart';
import 'package:frontend_app/screens/error/error_screen.dart';
import 'package:frontend_app/screens/register/register_screen.dart';
import 'package:frontend_app/screens/clinicDetail/clinic_detail_screen.dart';
import 'package:frontend_app/screens/doctorDetail/doctor_detail_screen.dart';
import 'package:frontend_app/screens/addeditpatientprofile/addedit_patientprofile_screen.dart';
import 'package:frontend_app/screens/verifyOtp/verify_otp_screen.dart';
import 'package:frontend_app/models/clinic.dart';
import 'package:frontend_app/models/patientprofile.dart';
// import 'package:frontend_app/models/schedule.dart';
// import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/screens/bookingAppointment/booking_appointment_screen.dart';
import 'package:frontend_app/screens/cccdScanner/cccd_scanner_screen.dart';
import 'package:frontend_app/screens/detailPatientProfile/detail_patientprofile_screen.dart';
import 'package:frontend_app/screens/detailAppointment/detail_appointment_screen.dart';
import 'package:frontend_app/models/appointment.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) {
          final initialIndex =
              int.tryParse(state.uri.queryParameters['initialIndex'] ?? '0') ??
                  0;
          print('Initial Index: $initialIndex');
          return HomeScreen(initialIndex: initialIndex);
        },
        routes: [
          GoRoute(
            name: 'clinicDetail',
            path: 'clinic',
            builder: (context, state) {
              final clinic = state.extra as Clinic;
              return ClinicDetailScreen(clinic: clinic);
            },
          ),
          GoRoute(
            name: 'doctorDetail',
            path: 'doctor/:doctorId',
            builder: (context, state) {
              final doctorId = state.pathParameters['doctorId']!;

              return DoctorDetailScreen(doctorId: doctorId);
            },
            routes: [
              GoRoute(
                name: 'booking',
                path: 'booking',
                builder: (context, state) {
                  final doctorId = state.pathParameters['doctorId']!;
                  return BookingAppointmentScreen(
                    doctorId: doctorId,
                  );
                },
              )
            ],
          ),
          GoRoute(
            name: 'detailAppointment',
            path: 'detailAppointment',
            builder: (context, state) {
              final appointment = state.extra as Appointment;
              return DetailAppointmentScreen(appointment: appointment);
            },
          ),
          GoRoute(
            name: 'detailPatientProfile',
            path: 'detailPatientProfile',
            builder: (context, state) {
              final patientProfile = state.extra as Patientprofile;
              return DetailPatientprofileScreen(patientProfile: patientProfile);
            },
          ),
          GoRoute(
            name: 'addEditPatientProfile',
            path: 'addEditPatientProfile',
            builder: (context, state) {
              final editedPatientProfile = state.extra is Patientprofile
                  ? state.extra as Patientprofile
                  : null;
              final infoIdCard = state.uri.queryParameters['infoIdCard'];
              final from = state.uri.queryParameters['from'];
              return AddEditPatientProfileScreen(
                editedPatientprofile: editedPatientProfile,
                infoIdCard: infoIdCard,
                from: from,
              );
            },
          ),
          GoRoute(
            path: 'scanner',
            name: 'scanner',
            builder: (context, state) {
              return const ScanCCCDScreen();
            },
          ),
          GoRoute(
            name: 'login',
            path: 'login',
            builder: (context, state) {
              final email = state.extra as String?;
              return LoginScreen(
                email: email,
              );
            },
            routes: [
              GoRoute(
                name: 'register',
                path: 'register',
                builder: (context, state) => const RegisterScreen(),
                routes: [
                  GoRoute(
                    name: 'verifyOtp',
                    path: 'verifyOtp',
                    builder: (context, state) {
                      final email = state.extra as String?;
                      return VerifyOtpScreen(
                        email: email!,
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
