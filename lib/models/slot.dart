class Slot {
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Slot({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotId: json['slotId'] ?? json['_id'],
      startTime: DateTime.parse(json['startTime']).toLocal(),
      endTime: DateTime.parse(json['endTime']).toLocal(),
      status: json['status'],
    );
  }
  static List<Slot> slotsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Slot.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
    };
  }
}
