import 'package:flutter/material.dart';

import 'api_client.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:frontend_app/models/medicalresult.dart';

class MedicalResultService {
  static Future<ResponseApi<List<MedicalResult>>> getPatientMedicalResults(
      String patientId) async {
    try {
      final response = await ApiClient.dio.get(
        '/medicalresult/get-patient-medicalresults/$patientId',
      );
      debugPrint('Response data: ${response.data}');
      return ResponseApi<List<MedicalResult>>.fromJson(
        response.data,
        funtionParser: (dataJson) =>
            MedicalResult.medicalResultsFromJson(dataJson as List<dynamic>),
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
