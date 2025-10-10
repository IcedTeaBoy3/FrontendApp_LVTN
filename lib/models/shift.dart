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

  Shift copyWith({
    String? shiftId,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    List<Slot>? slots,
  }) {
    return Shift(
      shiftId: shiftId ?? this.shiftId,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slots: slots ?? this.slots,
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      shiftId: json['shiftId'] ?? json['_id'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']).toLocal(),
      endTime: DateTime.parse(json['endTime']).toLocal(),
      slots: Slot.slotsFromJson(json['slots'] ?? []),
    );
  }
  static List<Shift> shiftsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Shift.fromJson(json)).toList();
  }

  int get availableSlotsCount {
    return slots.where((slot) => slot.status != "isBooked").length;
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
