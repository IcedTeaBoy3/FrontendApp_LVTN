import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:frontend_app/providers/schedule_provider.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/screens/my_app.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app/services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  final authProvider = AuthProvider();
  ApiClient.init(authProvider);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => SpecialtyProvider()),
        ChangeNotifierProvider(create: (_) => ClinicProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => PatientprofileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
