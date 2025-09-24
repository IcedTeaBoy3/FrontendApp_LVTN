import 'package:flutter/material.dart';
import 'package:frontend_app/models/clinic.dart';
import 'package:frontend_app/services/clinic_service.dart';

class ClinicProvider extends ChangeNotifier {
  Clinic? _clinic;
  bool _isLoading = false;

  Clinic? get clinic => _clinic;
  bool get isLoading => _isLoading;

  Future<void> fetchClinic() async {
    if (_isLoading) return; // Tránh gọi fetch nhiều lần cùng lúc
    _isLoading = true;
    notifyListeners();
    try {
      final result = await ClinicService.getClinic();
      _clinic = result;
    } catch (e) {
      // Nếu trong try có lỗi (như lỗi mạng, 401, hoặc JSON parse sai), code sẽ nhảy vào đây.
      debugPrint('Error fetching clinic: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
