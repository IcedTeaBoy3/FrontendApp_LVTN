import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctorreview.dart';
import 'package:frontend_app/services/doctorreview_service.dart';
import 'package:frontend_app/models/responseapi.dart';

class DoctorreviewProvider extends ChangeNotifier {
  List<DoctorReview> _doctorReviews = [];
  String _selectedSortOption = 'Mới nhất';
  bool _isLoading = false;

  List<DoctorReview> get doctorReviews {
    // Trả về danh sách đã sắp xếp theo lựa chọn hiện tại
    final sorted = List<DoctorReview>.from(_doctorReviews);
    sorted.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(1970);
      final bDate = b.createdAt ?? DateTime(1970);

      if (_selectedSortOption == 'Mới nhất') {
        return bDate.compareTo(aDate); // mới nhất trước
      } else {
        return aDate.compareTo(bDate); // cũ nhất trước
      }
    });
    return sorted;
  }

  bool get isLoading => _isLoading;
  String get selectedSortOption => _selectedSortOption;

  void setSortOption(String option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  Future<void> fetchDoctorReviewsByDoctorId(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await DoctorReviewService.getDoctorReviewsByDoctorId(doctorId);
      if (response.status == 'success') {
        _doctorReviews = response.data ?? [];
      }
    } catch (e) {
      throw Exception('Error fetching doctor reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi> createDoctorReview({
    required String appointmentId,
    required String doctorId,
    required double rating,
    String? comment,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await DoctorReviewService.createDoctorReview(
        appointmentId: appointmentId,
        comment: comment,
        doctorId: doctorId,
        rating: rating,
      );
      debugPrint('Created Doctor Review: ${response.data}');
      if (response.status == 'success' && response.data != null) {
        _doctorReviews.add(response.data!);
      }
      return response;
    } catch (e) {
      throw Exception('Error creating doctor review: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
