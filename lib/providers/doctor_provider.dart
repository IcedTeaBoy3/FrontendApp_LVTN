import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctor.dart';
import 'package:frontend_app/services/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  int _total = 0;
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors;
  List<Doctor> get filteredDoctors => _filteredDoctors;
  int get total => _total;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctors({int page = 1, int limit = 10}) async {
    if (_isLoading) return; // Tránh gọi fetch nhiều lần cùng lúc
    _isLoading = true;
    notifyListeners();
    try {
      final result =
          await DoctorService.getAllDoctors(page: page, limit: limit);
      debugPrint('Fetched doctors: ${result['doctors']}');
      _doctors = result['doctors'] as List<Doctor>;
      _filteredDoctors = List.from(_doctors); // Khởi tạo filteredDoctors
      _total = result['total'] as int;
    } catch (e) {
      // Nếu trong try có lỗi (như lỗi mạng, 401, hoặc JSON parse sai), code sẽ nhảy vào đây.
      debugPrint('Error fetching doctors: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Doctor? findById(String doctorId) {
    final index = _doctors.indexWhere((doctor) => doctor.doctorId == doctorId);
    if (index >= 0) {
      return _doctors[index];
    }
    return null;
  }

  void filterDoctors(
      {double? minPrice,
      double? maxPrice,
      String? specialtyName,
      String? doctorId}) {
    _filteredDoctors = _doctors.where((doctor) {
      final matchesPrice = (minPrice == null || maxPrice == null) ||
          (doctor.doctorServices.any((service) =>
              service.price >= minPrice && service.price <= maxPrice));
      final matchesSpecialty = specialtyName == null ||
          specialtyName.isEmpty ||
          doctor.primarySpecialtyName
              .toLowerCase()
              .contains(specialtyName.toLowerCase());
      final matchesDoctorId =
          doctorId == null || doctorId.isEmpty || doctor.doctorId == doctorId;

      return matchesPrice && matchesSpecialty && matchesDoctorId;
    }).toList();

    notifyListeners();
  }
}
