import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_doctorInfor.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String doctorId;
  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  DateTime? _selectedDate = DateTime.now();
  void showMonthPickerDialog(BuildContext context) {
    showMonthPicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
          _selectedDate = selectedDate;
          debugPrint('selectedDate: $_selectedDate');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade200
          : Colors.grey.shade800,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Chi tiết bác sĩ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Handle share button press
                },
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorDetailDoctorInfo(doctorId: widget.doctorId),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle booking appointment
                    },
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
                          _selectedDate == null
                              ? 'Chọn tháng'
                              : 'Lịch tháng ${_selectedDate!.month}/${_selectedDate!.year}',
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
                    onPressed: () {
                      showMonthPickerDialog(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
