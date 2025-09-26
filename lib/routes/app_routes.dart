import 'package:go_router/go_router.dart';
import 'package:frontend_app/screens/login/login_screen.dart';
import 'package:frontend_app/screens/home/home_screen.dart';
import 'package:frontend_app/screens/error/error_screen.dart';
import 'package:frontend_app/screens/register/register_screen.dart';
import 'package:frontend_app/screens/clinicDetail/clinic_detail_screen.dart';
import 'package:frontend_app/screens/doctorDetail/doctor_detail_screen.dart';
import 'package:frontend_app/screens/addPatientProfile/add_patient_profile.dart';
import 'package:frontend_app/screens/verifyOtp/verify_otp_screen.dart';
import 'package:frontend_app/models/clinic.dart';

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
          ),
          GoRoute(
            name: 'addPatientProfile',
            path: 'addPatientProfile',
            builder: (context, state) => const AddPatientProfile(),
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
