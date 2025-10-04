import 'package:flutter/material.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/need_login.dart';

import 'package:frontend_app/screens/appointment/widgets/apppointment_list.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return isAuthenticated
        ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(child: ApppointmentList()),
              ],
            ),
          )
        : const NeedLogin();
  }
}
