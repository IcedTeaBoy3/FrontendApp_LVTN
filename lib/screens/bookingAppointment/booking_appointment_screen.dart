import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/screens/bookingAppointment/widgets/schedule_appointment.dart';

class BookingAppointmentScreen extends StatefulWidget {
  final String doctorId;
  Schedule? selectedSchedule;
  Slot? selectedSlot;

  BookingAppointmentScreen({
    super.key,
    required this.doctorId,
    this.selectedSchedule,
    this.selectedSlot,
  });

  @override
  State<BookingAppointmentScreen> createState() =>
      _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  int _currentStep = 0;

  final List<String> _titles = [
    'Chọn lịch khám',
    'Xác nhận',
    'Thanh toán',
    'Nhận kết quả',
  ];

  List<Widget> get _contents => [
        // Thay bằng widget content thực tế của bạn nếu cần
        ScheduleAppointment(doctorId: widget.doctorId),
        const Text('Xem lại thông tin và xác nhận lịch hẹn.'),
        const Text('Chọn phương thức thanh toán và hoàn tất.'),
        const Text('Xem kết quả khám bệnh của bạn.'),
      ];

  void _nextStep() {
    if (_currentStep < _titles.length - 1) {
      setState(() => _currentStep += 1);
    } else {
      // hoàn tất
      debugPrint('Đặt lịch hẹn hoàn tất !');
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  Widget _buildStepItem(int index, double itemWidth) {
    final bool isActive = _currentStep == index;
    final bool isCompleted = _currentStep > index;

    return GestureDetector(
      onTap: () => setState(() => _currentStep = index),
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted || isActive ? Colors.blue : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? Colors.white : Colors.black87,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _titles[index],
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(bool active) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: active ? Colors.blue : Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    // tính width cho mỗi step: cố gắng vừa phải, nhưng không quá nhỏ
    final int count = _titles.length;
    final double screenW = MediaQuery.of(context).size.width;
    final double minItemW = 84; // nhỏ nhất cho mỗi item
    // nếu có ít step thì chia đều; nếu nhiều step thì để minItemW và cho scroll
    final double itemWidth =
        math.max(minItemW, (screenW - 32) / count); // 32 là padding

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Đặt lịch hẹn với bác sĩ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            // Header step: scroll được ngang nếu cần, không làm rộng content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(count * 2 - 1, (i) {
                    // xen kẽ item và connector
                    if (i.isEven) {
                      final idx = i ~/ 2;
                      return _buildStepItem(idx, itemWidth);
                    } else {
                      final leftIndex = (i - 1) ~/ 2;
                      final activeConnector = _currentStep > leftIndex;
                      return _buildConnector(activeConnector);
                    }
                  }),
                ),
              ),
            ),

            const Divider(height: 1),

            // Content: chiếm full width, không bị kéo rộng
            Expanded(
              child: SingleChildScrollView(
                // nếu nội dung cao thì cho cuộn dọc
                child: _contents[_currentStep],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _nextStep,
                    child: Text(
                      _currentStep == _titles.length - 1
                          ? 'Hoàn tất'
                          : 'Tiếp tục',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_currentStep > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _prevStep,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text(
                        'Quay lại',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
