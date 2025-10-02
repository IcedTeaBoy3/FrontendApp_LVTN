import 'package:flutter/material.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/schedule_provider.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/utils/date.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/widgets/custom_loading.dart';

class DoctorDetailSchedule extends StatefulWidget {
  final String doctorId;
  const DoctorDetailSchedule({super.key, required this.doctorId});

  @override
  State<DoctorDetailSchedule> createState() => _DoctorDetailScheduleState();
}

class _DoctorDetailScheduleState extends State<DoctorDetailSchedule> {
  void _onMonthSelected(DateTime? selectedDate) {
    if (selectedDate == null) return;
    final appointmentProvider = context.read<AppointmentProvider>();
    appointmentProvider.setDate(selectedDate);

    context
        .read<ScheduleProvider>()
        .fetchDoctorSchedules(doctorId: widget.doctorId, date: selectedDate);
    context.read<AppointmentProvider>().setSchedule(null);
  }

  void showMonthPickerDialog() {
    final appointmentProvider = context.read<AppointmentProvider>();
    showMonthPicker(
      context: context,
      initialDate: appointmentProvider.selectedDate ?? DateTime.now(),
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
    ).then(_onMonthSelected);
  }

  void _handleBookingAppointment(Slot slot) {
    context.read<AppointmentProvider>().setSlot(slot);

    final currentRoute = GoRouterState.of(context).name;
    // hoặc: final currentLocation = GoRouter.of(context).location;

    if (currentRoute != 'booking') {
      print('Chuyển đến trang đặt lịch khám');
      context.goNamed(
        'booking',
        pathParameters: {
          'doctorId': widget.doctorId,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final appointmentProvider = context.read<AppointmentProvider>();
    // nếu chưa có selectedDate thì gán mặc định tháng hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appointmentProvider.selectedDate == null) {
        appointmentProvider.setDate(now);
      }
      context.read<ScheduleProvider>().fetchDoctorSchedules(
            doctorId: widget.doctorId,
            date: context.read<AppointmentProvider>().selectedDate,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.read<AppointmentProvider>().selectedDate;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(12),
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
                  selectedDate == null
                      ? "Chọn tháng"
                      : 'Lịch tháng ${selectedDate?.month}/${selectedDate?.year}',
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
          Consumer2<ScheduleProvider, AppointmentProvider>(
            builder: (context, scheduleProvider, appointmentProvider, child) {
              if (scheduleProvider.isLoading) {
                return const CustomLoading();
              }
              final schedules = scheduleProvider.schedules;
              if (schedules.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Không có lịch khám trong tháng này.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              return Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        final slotCount = schedule.availableSlotCount;
                        final isSelected =
                            appointmentProvider.selectedSchedule?.scheduleId ==
                                schedule.scheduleId;
                        // Gán mặc định 1 lần khi chưa có selected
                        if (appointmentProvider.selectedSchedule == null &&
                            schedules.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            appointmentProvider.setSchedule(schedules.first);
                          });
                        }
                        return GestureDetector(
                          onTap: () =>
                              appointmentProvider.setSchedule(schedule),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: isSelected
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
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
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
                                          backgroundColor: Colors.blue.shade50,
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
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Consumer2<ScheduleProvider, AppointmentProvider>(
            builder: (context, scheduleProvider, appointmentProvider, child) {
              final selectedSchedule = appointmentProvider.selectedSchedule;
              if (selectedSchedule == null) {
                return SizedBox.shrink();
              }
              return Column(
                children: selectedSchedule.shifts.map(
                  (shift) {
                    final firstSlot = shift.getFirstSlot();
                    if (appointmentProvider.selectedSlot == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        appointmentProvider.setSlot(firstSlot);
                      });
                    }
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
                                final isSelected =
                                    appointmentProvider.selectedSlot == slot;
                                return ElevatedButton(
                                  onPressed: isAvailable
                                      ? () => _handleBookingAppointment(slot)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 40),
                                    backgroundColor: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.secondaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
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
                ).toList(),
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
