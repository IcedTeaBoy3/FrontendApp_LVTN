import 'shift.dart';

class Slot {
  final String slotId;
  final String? shiftId;
  final Shift? shift;
  final DateTime startTime;
  final DateTime endTime;
  String status;

  Slot({
    required this.slotId,
    this.shift,
    this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    Shift? parsedShift;
    String? parsedShiftId;
    if (json['shift'] is Map<String, dynamic>) {
      parsedShift = Shift.fromJson(json['shift']);
    } else if (json['shift'] is String) {
      parsedShiftId = json['shift'];
    }
    return Slot(
      slotId: json['slotId'] ?? json['_id'],
      shift: parsedShift,
      shiftId: parsedShiftId,
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
      'shift': shift != null ? shift!.toJson() : shiftId,
    };
  }
}
