class Degree {
  final String degreeId;
  final String title;
  final String abbreviation;
  final String? description;
  final String status;

  Degree({
    required this.degreeId,
    required this.title,
    required this.abbreviation,
    this.description,
    this.status = 'active',
  });

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(
      degreeId: json['degreeId'] ?? '',
      title: json['title'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'active',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'degreeId': degreeId,
      'title': title,
      'abbreviation': abbreviation,
      'description': description,
      'status': status,
    };
  }
}
