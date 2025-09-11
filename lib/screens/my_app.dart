import 'package:flutter/material.dart';
import 'package:frontend_app/themes/theme.dart';
import 'package:frontend_app/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meidcare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRoutes.router,
      themeMode: ThemeMode.system,
    );
  }
}
