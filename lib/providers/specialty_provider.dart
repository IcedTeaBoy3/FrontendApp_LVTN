import 'package:flutter/material.dart';
import 'package:frontend_app/models/specialty.dart';
import 'package:frontend_app/services/specialty_service.dart';

class SpecialtyProvider extends ChangeNotifier {
  List<Specialty> _specialties = [];
  int _total = 0;
  bool _isLoading = false;

  List<Specialty> get specialties => _specialties;
  int get total => _total;
  bool get isLoading => _isLoading;

  Future<void> fetchSpecialties({int page = 1, int limit = 10}) async {
    if (_isLoading) return; // Tránh gọi fetch nhiều lần cùng lúc
    _isLoading = true;
    notifyListeners();
    try {
      final result =
          await SpecialtyService.getAllSpecialties(page: page, limit: limit);
      _specialties = result['specialties'];
      _total = result['total'];
    } catch (e) {
      // Nếu trong try có lỗi (như lỗi mạng, 401, hoặc JSON parse sai), code sẽ nhảy vào đây.
      debugPrint('Error fetching specialties: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
