import 'package:flutter/foundation.dart';
import 'package:frontend_app/models/address/address.dart';
import 'package:frontend_app/services/address_service.dart';

class AddressProvider extends ChangeNotifier {
  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Ward> _wards = [];

  Province? _selectedProvince;
  District? _selectedDistrict;
  Ward? _selectedWard;

  List<Province> get provinces => _provinces;
  List<District> get districts => _districts;
  List<Ward> get wards => _wards;
  Province? get selectedProvince => _selectedProvince;
  District? get selectedDistrict => _selectedDistrict;
  Ward? get selectedWard => _selectedWard;

  bool isLoading = false;

  // Load tất cả tỉnh/thành (1 lần thôi)
  Future<void> loadProvincesOnce() async {
    if (_provinces.isNotEmpty) return;
    isLoading = true;
    notifyListeners();
    try {
      _provinces = await AddressService.getProvinces();
    } catch (e) {
      debugPrint("Error loading provinces: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Khi chọn province thì load district
  Future<void> loadDistricts(Province province) async {
    _selectedProvince = province;
    _districts = [];
    _wards = []; // reset luôn xã/phường
    isLoading = true;
    notifyListeners();

    try {
      _districts = await AddressService.getDistricts(province.code);
    } catch (e) {
      debugPrint("Error loading districts: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Khi chọn district thì load ward
  Future<void> loadWards(District district) async {
    _selectedDistrict = district;
    _wards = [];
    isLoading = true;
    notifyListeners();

    try {
      _wards = await AddressService.getWards(district.code);
    } catch (e) {
      debugPrint("Error loading wards: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Chọn Province
  void setSelectedProvince(Province province) {
    _selectedProvince = province;
    _selectedDistrict = null;
    _selectedWard = null;
    _districts = [];
    _wards = [];
    notifyListeners();
  }

  /// Chọn District
  void setSelectedDistrict(District district) {
    _selectedDistrict = district;
    _selectedWard = null;
    _wards = [];
    notifyListeners();
  }

  /// Chọn Ward
  void setSelectedWard(Ward ward) {
    _selectedWard = ward;
    notifyListeners();
  }
}
