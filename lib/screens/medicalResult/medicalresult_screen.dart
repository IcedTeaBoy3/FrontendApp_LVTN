import 'package:flutter/material.dart';
import 'package:frontend_app/providers/medicalresult_provider.dart';
import 'package:provider/provider.dart';
import './widgets/medicalresult_list.dart';

class MedicalResultScreen extends StatefulWidget {
  const MedicalResultScreen({super.key});

  @override
  State<MedicalResultScreen> createState() => _MedicalResultScreenState();
}

class _MedicalResultScreenState extends State<MedicalResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicalresultProvider>().fetchPatientMedicalResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProfile =
        context.read<MedicalresultProvider>().selectedPatientProfile;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kết quả khám bệnh - ${patientProfile?.person.fullName ?? ''}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: const MedicalResultList(),
    );
  }
}
