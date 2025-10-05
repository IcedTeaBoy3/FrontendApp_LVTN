import 'package:flutter/material.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/services/schedule_service.dart';
import 'package:frontend_app/models/slot.dart';

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

  void disabledSlot(Slot slot) {
    final target =
        schedules.expand((s) => s.shifts).expand((sh) => sh.slots).firstWhere(
              (s) => s.slotId == slot.slotId,
              orElse: () => Slot(
                slotId: '',
                startTime: DateTime.now(),
                endTime: DateTime.now(),
                status: 'available',
              ),
            );

    if (target.slotId.isNotEmpty) {
      target.status = 'booked';
      notifyListeners();
    }
  }
}
