import 'package:go_router/go_router.dart';
import 'package:frontend_app/screens/login/login_screen.dart';
import 'package:frontend_app/screens/home/home_screen.dart';
import 'package:frontend_app/screens/error/error_screen.dart';
import 'package:frontend_app/screens/register/register_screen.dart';
import 'package:frontend_app/screens/clinicDetail/clinic_detail_screen.dart';
import 'package:frontend_app/screens/doctorDetail/doctor_detail_screen.dart';
import 'package:frontend_app/screens/addedit_patientprofile_screen/addedit_patientprofile_screen.dart';
import 'package:frontend_app/screens/verifyOtp/verify_otp_screen.dart';
import 'package:frontend_app/models/clinic.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/screens/bookingAppointment/booking_appointment_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeScreen(),
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
                  final schedule = state.extra as Schedule?;
                  final slot = state.extra as Slot?;
                  return BookingAppointmentScreen(
                    doctorId: doctorId,
                    selectedSchedule: schedule,
                    selectedSlot: slot,
                  );
                },
              )
            ],
          ),
          GoRoute(
            name: 'addPatientProfile',
            path: 'addPatientProfile',
            builder: (context, state) {
              final editedPatientProfile = state.extra as Patientprofile?;
              return AddEditPatientProfileScreen(
                editedPatientprofile: editedPatientProfile,
              );
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
