import 'slot.dart';

class Shift {
  final String shiftId;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final List<Slot> slots;

  Shift({
    required this.shiftId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.slots,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      shiftId: json['shiftId'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      slots: Slot.slotsFromJson(json['slots'] ?? []),
    );
  }
  static List<Shift> shiftsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Shift.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'shiftId': shiftId,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }
}
