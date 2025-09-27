import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctor.dart';
import 'package:frontend_app/services/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  int _total = 0;
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors;
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
}
