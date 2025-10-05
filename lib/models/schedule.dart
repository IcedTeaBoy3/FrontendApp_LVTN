import 'shift.dart';
import 'slot.dart';

class Schedule {
  final String scheduleId;
  final DateTime workday;
  final String doctorId;
  final List<Shift> shifts;
  final int slotDuration;
  final String status;
  Schedule({
    required this.scheduleId,
    required this.workday,
    required this.doctorId,
    required this.shifts,
    required this.slotDuration,
    this.status = 'active',
  });
  // Đếm tổng số slot trong ngày có status = 'available'
  int get availableSlotCount {
    int count = 0;
    for (var shift in shifts) {
      for (var slot in shift.slots) {
        if (slot.status == 'available') {
          count++;
        }
      }
    }
    return count;
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['_id'] ?? json['scheduleId'],
      workday: DateTime.parse(json['workday']).toLocal(),
      doctorId: json['doctorId'] ?? json['doctor'],
      shifts: Shift.shiftsFromJson(json['shifts'] ?? []),
      slotDuration: json['slotDuration'] ?? 30,
      status: json['status'] ?? 'active',
    );
  }
  static List<Schedule> schedulesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'workday': workday.toIso8601String(),
      'doctorId': doctorId,
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
      'slotDuration': slotDuration,
      'status': status,
    };
  }

  Slot? getFirstAvailableSlot() {
    for (var shift in shifts) {
      for (var slot in shift.slots) {
        if (slot.status == 'available') {
          return slot;
        }
      }
    }
    return null; // không có slot nào trống
  }
}
