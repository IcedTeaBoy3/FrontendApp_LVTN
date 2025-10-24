import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctorreview.dart';
import 'package:frontend_app/services/doctorreview_service.dart';
import 'package:frontend_app/models/responseapi.dart';

class DoctorreviewProvider extends ChangeNotifier {
  List<DoctorReview> _doctorReviews = [];
  bool _isLoading = false;

  List<DoctorReview> get doctorReviews => _doctorReviews;
  bool get isLoading => _isLoading;

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
    required String comment,
    required String doctorId,
    required double rating,
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
