import 'package:flutter/material.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/need_login.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch patient profiles when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientprofileProvider>().fetchPatientprofiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return isAuthenticated
        ? Column(
            children: [
              Text("Patient Profile"),
              Consumer<PatientprofileProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return CircularProgressIndicator();
                  } else if (provider.patientprofiles.isEmpty) {
                    return Text("No patient profiles found.");
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.patientprofiles.length,
                      itemBuilder: (context, index) {
                        final profile = provider.patientprofiles[index];
                        return ListTile(
                          title: Text(profile.person.fullName ?? 'Unknown'),
                          subtitle: Text(profile.relation ?? 'Unknown'),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          )
        : const NeedLogin();
  }
}
