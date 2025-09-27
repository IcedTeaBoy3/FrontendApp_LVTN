class Ward {
  final int code;
  final String name;

  Ward({required this.code, required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      code: json["code"],
      name: json["name"],
    );
  }
}

class District {
  final int code;
  final String name;
  final List<Ward> wards;

  District({required this.code, required this.name, required this.wards});

  factory District.fromJson(Map<String, dynamic> json) {
    var wardList = <Ward>[];
    if (json["wards"] != null) {
      wardList = (json["wards"] as List).map((w) => Ward.fromJson(w)).toList();
    }
    return District(
      code: json["code"],
      name: json["name"],
      wards: wardList,
    );
  }
}

class Province {
  final int code;
  final String name;
  final List<District> districts;

  Province({required this.code, required this.name, required this.districts});

  factory Province.fromJson(Map<String, dynamic> json) {
    var districtList = <District>[];
    if (json["districts"] != null) {
      districtList =
          (json["districts"] as List).map((d) => District.fromJson(d)).toList();
    }
    return Province(
      code: json["code"],
      name: json["name"],
      districts: districtList,
    );
  }
}
