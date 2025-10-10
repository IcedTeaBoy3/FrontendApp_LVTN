import 'package:flutter/material.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/services/schedule_service.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/models/shift.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  int _total = 0;
  bool _isLoading = false;

  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  int get total => _total;

  Future<void> fetchDoctorSchedules(
      {required String doctorId, DateTime? date}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ScheduleService.getAllDoctorSchedules(
        doctorId: doctorId,
        date: date,
      );
      debugPrint('Fetched schedules: $result');
      _schedules = result['schedules'] as List<Schedule>;
      _total = result['total'] as int;
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void disableSlot(Slot slot) {
    bool updated = false;

    for (int i = 0; i < _schedules.length; i++) {
      final schedule = _schedules[i];

      for (int j = 0; j < schedule.shifts.length; j++) {
        final shift = schedule.shifts[j];

        final index = shift.slots.indexWhere((s) => s.slotId == slot.slotId);
        if (index != -1) {
          // ✅ Lấy slot hiện tại và cập nhật trạng thái
          final currentSlot = shift.slots[index];
          final updatedSlot = currentSlot.copyWith(status: 'booked');

          // ✅ Clone lại toàn bộ các tầng để Flutter nhận biết thay đổi
          final updatedSlots = List<Slot>.from(shift.slots);
          updatedSlots[index] = updatedSlot;

          final updatedShift = shift.copyWith(slots: updatedSlots);
          final updatedShifts = List<Shift>.from(schedule.shifts);
          updatedShifts[j] = updatedShift;

          final updatedSchedule = schedule.copyWith(shifts: updatedShifts);
          _schedules[i] = updatedSchedule;

          updated = true;
          break;
        }
      }

      if (updated) break;
    }

    if (updated) {
      _schedules = List<Schedule>.from(_schedules); // ép Provider rebuild
      notifyListeners();
    }
  }
}
