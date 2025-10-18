import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctor.dart';
import 'package:frontend_app/services/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  int _total = 0;
  bool _isLoading = false;
  List<Doctor> _filteredDoctors = [];
  String _query = '';
  String _selectedSpecialty = '';
  String _selectedService = '';
  String _selectedDegree = '';

  List<Doctor> get doctors => _doctors;
  int get total => _total;
  bool get isLoading => _isLoading;
  List<Doctor> get filteredDoctors => _filteredDoctors;
  String get query => _query;
  String get selectedSpecialty => _selectedSpecialty;
  String get selectedService => _selectedService;
  String get selectedDegree => _selectedDegree;

  Future<void> fetchDoctors({int page = 1, int limit = 10}) async {
    if (_isLoading) return; // Tránh gọi fetch nhiều lần cùng lúc
    _isLoading = true;
    notifyListeners();
    try {
      final result =
          await DoctorService.getAllDoctors(page: page, limit: limit);
      debugPrint('Fetched doctors: ${result['doctors']}');
      _doctors = result['doctors'] as List<Doctor>;
      _filteredDoctors = List.from(_doctors);
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

  /// ✅ Set query và tự động lọc
  void setQuery(String value) {
    _query = value;
    notifyListeners();
    filterDoctors();
  }

  void setSelectedSpecialty(String? value) {
    _selectedSpecialty = value?.trim() ?? '';
    notifyListeners();
  }

  void setSelectedService(String? value) {
    _selectedService = value?.trim() ?? '';
    notifyListeners();
  }

  void setSelectedDegree(String? value) {
    _selectedDegree = value?.trim() ?? '';
    notifyListeners();
  }

  void clearFilters() {
    _selectedSpecialty = '';
    _selectedService = '';
    _selectedDegree = '';
    filterDoctors();
  }

  bool isFilter() {
    return _selectedSpecialty.isNotEmpty ||
        _selectedService.isNotEmpty ||
        _selectedDegree.isNotEmpty;
  }

  void filterDoctors() {
    List<Doctor> filtered = List.from(_doctors);

    // 1️⃣ Lọc theo query (tên, bằng cấp, chuyên khoa, dịch vụ)
    if (_query.isNotEmpty) {
      final lowerQuery = _query.toLowerCase();
      filtered = filtered.where((doctor) {
        final fullName = doctor.person.fullName.toLowerCase();
        final degreeTitle = doctor.degree?.title.toLowerCase() ?? '';
        final specialties = doctor.doctorSpecialties
            .map((ds) => ds.specialty.name.toLowerCase())
            .join(' ');
        final services = doctor.doctorServices
            .map((ds) => ds.service?.name.toLowerCase() ?? '')
            .join(' ');

        return fullName.contains(lowerQuery) ||
            degreeTitle.contains(lowerQuery) ||
            specialties.contains(lowerQuery) ||
            services.contains(lowerQuery);
      }).toList();
    }

    // 2️⃣ Lọc theo chuyên khoa
    if (_selectedSpecialty.isNotEmpty) {
      final lowerSpec = _selectedSpecialty.toLowerCase();
      filtered = filtered.where((doctor) {
        return doctor.doctorSpecialties.any(
          (ds) => ds.specialty.name.toLowerCase().contains(lowerSpec),
        );
      }).toList();
    }

    // 3️⃣ Lọc theo dịch vụ
    if (_selectedService!.isNotEmpty) {
      final lowerService = _selectedService!.toLowerCase();
      filtered = filtered.where((doctor) {
        return doctor.doctorServices.any(
          (ds) =>
              ds.service?.name.toLowerCase().contains(lowerService) ?? false,
        );
      }).toList();
    }

    // 4️⃣ Lọc theo bằng cấp
    if (_selectedDegree.isNotEmpty) {
      final lowerDegree = _selectedDegree.toLowerCase();
      filtered = filtered.where((doctor) {
        final degree = doctor.degree?.title.toLowerCase() ?? '';
        return degree.contains(lowerDegree);
      }).toList();
    }

    _filteredDoctors = filtered;
    notifyListeners();
  }

  Doctor? findById(String doctorId) {
    final index = _doctors.indexWhere((doctor) => doctor.doctorId == doctorId);
    if (index >= 0) {
      return _doctors[index];
    }
    return null;
  }
}
