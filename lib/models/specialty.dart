class Specialty {
  final String specialtyId;
  final String name;
  final String description;
  final String image;
  final String status;

  Specialty({
    required this.specialtyId,
    required this.name,
    required this.description,
    required this.image,
    required this.status,
  });
  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      specialtyId: json['specialtyId'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 'active',
    );
  }
  static List<Specialty> specialtiesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Specialty.fromJson(json)).toList();
  }

  // Convert a Specialty object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'specialtyId': specialtyId,
      'name': name,
      'description': description,
      'image': image,
      'status': status,
    };
  }
}
