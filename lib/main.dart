import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './themes/theme.dart';
import 'package:frontend_app/routes/app_routes.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpecialtyProvider()),
        ChangeNotifierProvider(create: (_) => ClinicProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      title: 'Meidcare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      themeMode: ThemeMode.system,
    );
  }
}
