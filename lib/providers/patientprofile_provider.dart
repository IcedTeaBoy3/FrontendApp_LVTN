import 'package:flutter/material.dart';
import 'package:frontend_app/services/patientprofile_service.dart';
import 'package:frontend_app/models/patientprofile.dart';

class PatientprofileProvider extends ChangeNotifier {
  List<Patientprofile> _patientprofiles = [];
  bool _isLoading = false;

  List<Patientprofile> get patientprofiles => _patientprofiles;
  bool get isLoading => _isLoading;

  Future<void> fetchPatientprofiles({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final profiles = await PatientprofileService.getAllUserPatientProfiles(
        page: page,
        limit: limit,
      );
      _patientprofiles = profiles;
    } catch (e) {
      // Handle error
      debugPrint('Error fetching patient profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
