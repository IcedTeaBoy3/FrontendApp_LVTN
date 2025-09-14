class Workplace {
  final String workplaceId;
  final String name;
  final String? description;
  final String address;
  final String phone;
  final String type;

  Workplace({
    required this.workplaceId,
    required this.name,
    this.description,
    required this.address,
    required this.phone,
    required this.type,
  });

  factory Workplace.fromJson(Map<String, dynamic> json) {
    return Workplace(
      workplaceId: json['workplaceId'],
      name: json['name'],
      description: json['description'] ?? '',
      address: json['address'],
      phone: json['phone'],
      type: json['type'],
    );
  }
  static List<Workplace> workplacesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Workplace.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "workplaceId": workplaceId,
      "name": name,
      "description": description,
      "address": address,
      "phone": phone,
      "type": type,
    };
  }
}
