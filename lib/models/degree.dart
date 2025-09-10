class Degree {
  final String degreeId;
  final String title;
  final String abbreviation;
  final String? description;

  Degree({
    required this.degreeId,
    required this.title,
    required this.abbreviation,
    this.description,
  });

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(
      degreeId: json['degreeId'] ?? '',
      title: json['title'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      description: json['description'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'abbreviation': abbreviation,
      'description': description,
    };
  }
}
