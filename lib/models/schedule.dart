import 'shift.dart';

class Schedule {
  final String scheduleId;
  final DateTime workday;
  final String doctorId;
  final List<Shift> shifts;
  Schedule({
    required this.scheduleId,
    required this.workday,
    required this.doctorId,
    required this.shifts,
  });
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      workday: DateTime.parse(json['workday']),
      doctorId: json['doctorId'],
      shifts: Shift.shiftsFromJson(json['shifts'] ?? []),
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
    };
  }
}
