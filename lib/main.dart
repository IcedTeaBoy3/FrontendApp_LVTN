import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:frontend_app/providers/schedule_provider.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/providers/address_provider.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/providers/ethnic_provider.dart';
import 'package:frontend_app/providers/notification_provider.dart';
import 'package:frontend_app/screens/my_app.dart';
import 'package:frontend_app/services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  ApiClient.init(authProvider);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => EthnicityProvider()),
        ChangeNotifierProvider(create: (_) => SpecialtyProvider()),
        ChangeNotifierProvider(create: (_) => ClinicProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => PatientprofileProvider()),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProxyProvider<NotificationProvider, AppointmentProvider>(
          create: (context) => AppointmentProvider(
            Provider.of<NotificationProvider>(context, listen: false),
          ),
          update: (context, notificationProvider, appointmentProvider) {
            // Chỉ cập nhật notificationProvider chứ không tạo instance mới
            appointmentProvider!
                .updateNotificationProvider(notificationProvider);
            return appointmentProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
