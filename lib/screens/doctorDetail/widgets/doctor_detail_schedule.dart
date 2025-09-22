import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/schedule_provider.dart';
import 'package:frontend_app/utils/date.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorDetailSchedule extends StatefulWidget {
  final String doctorId;
  const DoctorDetailSchedule({super.key, required this.doctorId});

  @override
  State<DoctorDetailSchedule> createState() => _DoctorDetailScheduleState();
}

class _DoctorDetailScheduleState extends State<DoctorDetailSchedule> {
  late Future<void> _fetchDoctorSchedules;

  DateTime? _selectedMonth;
  Schedule? _selectedSchedule;
  void showMonthPickerDialog() {
    showMonthPicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      lastDate: DateTime(DateTime.now().year + 1, 12),
      monthPickerDialogSettings: const MonthPickerDialogSettings(
        headerSettings: PickerHeaderSettings(),
        dialogSettings: PickerDialogSettings(
          locale: Locale('vi-VN'),
          dialogRoundedCornersRadius: 20,
          dialogBackgroundColor: Colors.white,
        ),
        actionBarSettings: PickerActionBarSettings(
          actionBarPadding: EdgeInsets.only(right: 10, bottom: 10),
          confirmWidget: Text(
            'Chọn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          cancelWidget: Text(
            'Hủy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          buttonBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          selectedMonthBackgroundColor: Colors.blue,
          selectedMonthTextColor: Colors.white,
          unselectedMonthsTextColor: Colors.black,
          currentMonthTextColor: Colors.green,
          yearTextStyle: TextStyle(
            fontSize: 10,
          ),
          monthTextStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedMonth = selectedDate;
          _selectedSchedule = null;
          debugPrint('selectedDate: $_selectedMonth');
        });
        _fetchDoctorSchedules = context
            .read<ScheduleProvider>()
            .fetchDoctorSchedules(
                doctorId: widget.doctorId, date: _selectedMonth);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _fetchDoctorSchedules = context
        .read<ScheduleProvider>()
        .fetchDoctorSchedules(doctorId: widget.doctorId, date: _selectedMonth);
  }

  @override
  void dispose() {
    super.dispose();
    _selectedSchedule = null;
    _selectedMonth = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(35),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
            child: Text(
              'Lịch khám',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.black54,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedMonth == null
                      ? "Chọn tháng"
                      : 'Lịch tháng ${_selectedMonth?.month}/${_selectedMonth?.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down, // icon mũi tên xuống
                  color: Colors.blue,
                  size: 24,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
            onPressed: () => showMonthPickerDialog(),
          ),
          const SizedBox(height: 12),
          FutureBuilder(
            future: _fetchDoctorSchedules,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Consumer<ScheduleProvider>(
                  builder: (context, scheduleProvider, child) {
                    final schedules = scheduleProvider.schedules;
                    if (schedules.isEmpty) {
                      return const Center(
                        child: Text('Không có lịch khám trong tháng này.'),
                      );
                    }
                    if (_selectedSchedule == null && schedules.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedSchedule = schedules.first;
                        });
                      });
                    }
                    return SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          final slotCount = schedule.availableSlotCount;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSchedule = schedule;
                              });
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: _selectedSchedule?.scheduleId ==
                                        schedule.scheduleId
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                child: Stack(
                                  children: [
                                    // Badge Hết lịch
                                    if (slotCount == 0)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Đầy lịch',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Nội dung chính
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getWeekdayName(schedule.workday),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            child: Text(
                                              '${schedule.workday.day}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          // Badge số khung giờ
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: slotCount > 0
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '$slotCount slot',
                                              style: TextStyle(
                                                color: slotCount > 0
                                                    ? Colors.green.shade800
                                                    : Colors.grey.shade600,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(height: 12),
          if (_selectedSchedule != null)
            ..._selectedSchedule!.shifts.map(
              (shift) {
                return SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            shift.name.toLowerCase().contains('sáng')
                                ? FontAwesomeIcons.sun
                                : shift.name.toLowerCase().contains('chiều')
                                    ? FontAwesomeIcons.cloudSun
                                    : FontAwesomeIcons.moon,
                            size: 16,
                            color: shift.name.toLowerCase().contains('sáng')
                                ? Colors.orange
                                : shift.name.toLowerCase().contains('chiều')
                                    ? Colors.amber
                                    : Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            shift.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: shift.slots.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final slot = shift.slots[index];
                            final isAvailable = slot.status == 'available';
                            return ElevatedButton(
                              onPressed: isAvailable ? () {} : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 40),
                                backgroundColor: isAvailable
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                foregroundColor: isAvailable
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: Text(
                                '${DateFormat.Hm().format(slot.startTime)} - ${DateFormat.Hm().format(slot.endTime)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isAvailable
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.handPointUp, // icon tay chỉ lên
                size: 14,
                color: Colors.grey,
              ),
              SizedBox(width: 4),
              Text(
                '*Chọn một khung giờ để đặt lịch khám',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
