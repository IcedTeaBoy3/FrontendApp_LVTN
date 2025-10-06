import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_app/models/ethnic.dart';

class EthnicityProvider with ChangeNotifier {
  List<Ethnic> _ethnicGroups = [];
  bool _isLoading = false;

  List<Ethnic> get ethnicGroups => _ethnicGroups;
  bool get isLoading => _isLoading;

  Future<void> loadEthnicGroups() async {
    if (_ethnicGroups.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      final String response =
          await rootBundle.loadString('assets/data/ethnicGroups.json');
      final List<dynamic> data = json.decode(response);
      _ethnicGroups = data.map((e) => Ethnic.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi đọc JSON dân tộc: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Hàm tìm dân tộc theo code hoặc name
  Ethnic? findByCodeOrName(String value) {
    if (value.isEmpty || _ethnicGroups.isEmpty) return null;

    try {
      return _ethnicGroups.firstWhere(
        (e) =>
            e.code.toLowerCase() == value.toLowerCase() ||
            e.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
