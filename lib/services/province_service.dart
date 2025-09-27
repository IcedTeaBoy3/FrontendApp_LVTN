import 'package:frontend_app/models/address/address.dart';
import 'package:dio/dio.dart';

class ProvinceService {
  static Future<List<Province>> getProvinces() async {
    final response = await Dio().get(
      'https://provinces.open-api.vn/api/v1/?depth=2',
    );
    return (response.data as List).map((p) => Province.fromJson(p)).toList();
  }

  static Future<List<District>> getDistricts(int provinceId) async {
    final response = await Dio().get(
      'https://provinces.open-api.vn/api/v1/p/$provinceId?depth=2',
    );
    return (response.data["districts"] as List)
        .map((d) => District.fromJson(d))
        .toList();
  }

  static Future<List<Ward>> getWards(int districtId) async {
    final response = await Dio().get(
      'https://provinces.open-api.vn/api/v1/d/$districtId?depth=2',
    );
    return (response.data["wards"] as List)
        .map((w) => Ward.fromJson(w))
        .toList();
  }
}
