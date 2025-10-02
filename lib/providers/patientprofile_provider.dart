import 'package:flutter/material.dart';
import 'package:frontend_app/services/patientprofile_service.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/responseapi.dart';

class PatientprofileProvider extends ChangeNotifier {
  List<Patientprofile> _patientprofiles = [];
  bool _isLoading = false;

  List<Patientprofile> get patientprofiles => _patientprofiles;
  bool get isLoading => _isLoading;

  Future<void> fetchPatientprofiles({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await PatientprofileService.getAllUserPatientProfiles(
        page: page,
        limit: limit,
      );
      if (result.status == 'success' && result.data != null) {
        _patientprofiles = result.data!;
      }
    } catch (e) {
      // Handle error
      debugPrint('Error fetching patient profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi<Patientprofile>> addPatientprofile(
      Patientprofile profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await PatientprofileService.createPatientProfile(profile);
      if (result.status == 'success' && result.data != null) {
        _patientprofiles.add(result.data!);
      }
      return result;
    } catch (e) {
      // Handle error
      debugPrint('Error adding patient profile: $e');
      return ResponseApi<Patientprofile>(
        status: 'error',
        message: 'Error adding patient profile: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi<Patientprofile>> updatePatientprofile(
      Patientprofile profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await PatientprofileService.updatePatientProfile(profile);
      if (result.status == 'success' && result.data != null) {
        final index = _patientprofiles.indexWhere(
            (p) => p.patientProfileId == result.data!.patientProfileId);
        if (index != -1) {
          _patientprofiles[index] = result.data!;
        }
      }
      return result;
    } catch (e) {
      // Handle error
      debugPrint('Error updating patient profile: $e');
      return ResponseApi<Patientprofile>(
        status: 'error',
        message: 'Error updating patient profile: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi> deletePatientprofile(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await PatientprofileService.deletePatientProfile(id);
      if (result.status == 'success') {
        _patientprofiles
            .removeWhere((profile) => profile.patientProfileId == id);
      }
      return result;
    } catch (e) {
      // Handle error
      debugPrint('Error deleting patient profile: $e');
      return ResponseApi(
        status: 'error',
        message: 'Error deleting patient profile: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _patientprofiles = [];
    notifyListeners();
  }
}
