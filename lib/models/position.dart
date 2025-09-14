class Position {
  final String positionId;
  final String title;
  final String? description;

  Position({
    required this.positionId,
    required this.title,
    required this.description,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      positionId: json['positionId'],
      title: json['title'],
      description: json['description'],
    );
  }
  static List<Position> positionsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Position.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'positionId': positionId,
      'title': title,
      'description': description,
    };
  }
}
