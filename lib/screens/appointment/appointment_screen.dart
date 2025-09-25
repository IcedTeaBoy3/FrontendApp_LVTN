import 'package:flutter/material.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/need_login.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return isAuthenticated
        ? Column(
            children: [
              Text("Appointment Screen - User is logged in "),
            ],
          )
        : const NeedLogin();
  }
}
