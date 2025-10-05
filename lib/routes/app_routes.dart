import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🧱 Models
import 'package:frontend_app/models/clinic.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/models/patientprofile.dart';

// 🧭 Screens
import 'package:frontend_app/screens/login/login_screen.dart';
import 'package:frontend_app/screens/home/home_screen.dart';
import 'package:frontend_app/screens/error/error_screen.dart';
import 'package:frontend_app/screens/register/register_screen.dart';
import 'package:frontend_app/screens/clinicDetail/clinic_detail_screen.dart';
import 'package:frontend_app/screens/doctorDetail/doctor_detail_screen.dart';
import 'package:frontend_app/screens/addeditpatientprofile/addedit_patientprofile_screen.dart';
import 'package:frontend_app/screens/verifyOtp/verify_otp_screen.dart';
import 'package:frontend_app/screens/bookingAppointment/booking_appointment_screen.dart';
import 'package:frontend_app/screens/cccdScanner/cccd_scanner_screen.dart';
import 'package:frontend_app/screens/detailPatientProfile/detail_patientprofile_screen.dart';
import 'package:frontend_app/screens/detailAppointment/detail_appointment_screen.dart';
import 'package:frontend_app/screens/search/search_screen.dart';

/// 🌐 AppRoutes quản lý toàn bộ định tuyến
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
          debugPrint('Initial Home Index: $initialIndex');
          return HomeScreen(initialIndex: initialIndex);
        },
        routes: [
          // 🔍 Search
          GoRoute(
            name: 'search',
            path: 'search',
            builder: (context, state) {
              final query = state.uri.queryParameters['query'] ?? '';
              return SearchScreen(query: query);
            },
          ),

          // 🏥 Clinic detail
          GoRoute(
            name: 'clinicDetail',
            path: 'clinic',
            builder: (context, state) {
              final clinic = state.extra as Clinic;
              return ClinicDetailScreen(clinic: clinic);
            },
          ),

          // 👨‍⚕️ Doctor detail
          GoRoute(
            name: 'doctorDetail',
            path: 'doctor/:doctorId',
            builder: (context, state) {
              final doctorId = state.pathParameters['doctorId']!;
              final from = state.uri.queryParameters['from'];
              return DoctorDetailScreen(doctorId: doctorId, from: from);
            },
            routes: [
              // 📅 Booking from doctor detail
              GoRoute(
                name: 'booking',
                path: 'booking',
                builder: (context, state) {
                  final doctorId = state.pathParameters['doctorId']!;
                  return BookingAppointmentScreen(doctorId: doctorId);
                },
              ),
            ],
          ),

          // 🧾 Appointment detail
          GoRoute(
            name: 'detailAppointment',
            path: 'detailAppointment',
            builder: (context, state) {
              final appointment = state.extra as Appointment;
              return DetailAppointmentScreen(appointment: appointment);
            },
          ),

          // 👤 Patient profile detail
          GoRoute(
            name: 'detailPatientProfile',
            path: 'detailPatientProfile',
            builder: (context, state) {
              final patientProfile = state.extra as Patientprofile;
              return DetailPatientprofileScreen(patientProfile: patientProfile);
            },
          ),

          // ✏️ Add / Edit patient profile
          GoRoute(
            name: 'addEditPatientProfile',
            path: 'addEditPatientProfile',
            builder: (context, state) {
              final editedProfile = state.extra is Patientprofile
                  ? state.extra as Patientprofile
                  : null;

              final infoIdCard = state.uri.queryParameters['infoIdCard'];
              final from = state.uri.queryParameters['from'];

              return AddEditPatientProfileScreen(
                editedPatientprofile: editedProfile,
                infoIdCard: infoIdCard,
                from: from,
              );
            },
          ),

          // 🪪 CCCD scanner
          GoRoute(
            name: 'scanner',
            path: 'scanner',
            builder: (context, state) => const ScanCCCDScreen(),
          ),

          // 🔐 Login & Register flow
          GoRoute(
            name: 'login',
            path: 'login',
            builder: (context, state) {
              final email = state.extra as String?;
              return LoginScreen(email: email);
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
                      return VerifyOtpScreen(email: email!);
                    },
                  ),
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
