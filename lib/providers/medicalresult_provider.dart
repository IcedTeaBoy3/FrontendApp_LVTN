import 'package:flutter/material.dart';
import 'package:frontend_app/services/medicalresult_service.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/medicalresult.dart';

class MedicalresultProvider extends ChangeNotifier {
  List<MedicalResult> _medicalresults = [];
  Patientprofile? _selectedPatientProfile;
  bool _isLoading = false;

  List<MedicalResult> get medicalresults => _medicalresults;
  Patientprofile? get selectedPatientProfile => _selectedPatientProfile;
  bool get isLoading => _isLoading;

  set selectedPatientProfile(Patientprofile? profile) {
    _selectedPatientProfile = profile;
    notifyListeners();
  }

  Future<void> fetchPatientMedicalResults() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await MedicalResultService.getPatientMedicalResults(
        _selectedPatientProfile!.patientProfileId,
      );
      if (response.status == 'success') {
        _medicalresults = response.data ?? [];
      }
    } catch (e) {
      throw Exception('Error fetching medical results: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
