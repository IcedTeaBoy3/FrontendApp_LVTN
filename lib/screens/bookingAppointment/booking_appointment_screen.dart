import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frontend_app/screens/bookingAppointment/widgets/schedule_appointment.dart';
import 'package:frontend_app/screens/bookingAppointment/widgets/confirm_appointment.dart';
import 'package:frontend_app/screens/bookingAppointment/widgets/service_appointment.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:frontend_app/models/appointment.dart';

class BookingAppointmentScreen extends StatefulWidget {
  final String doctorId;

  const BookingAppointmentScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<BookingAppointmentScreen> createState() =>
      _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  int _currentStep = 0;

  final List<String> _titles = [
    'Chọn lịch khám',
    'Chọn dịch vụ',
    'Xác nhận',
  ];

  List<Widget> get _contents => [
        ScheduleAppointment(doctorId: widget.doctorId),
        ServiceAppointment(doctorId: widget.doctorId),
        ConfirmAppointment(doctorId: widget.doctorId),
      ];

  void _nextStep() async {
    final appointmentProvider = context.read<AppointmentProvider>();
    final patientProfile = appointmentProvider.selectedPatientProfile;
    final doctorService = appointmentProvider.selectedDoctorService;
    final schedule = appointmentProvider.selectedSchedule;
    final slot = appointmentProvider.selectedSlot;
    final paymentMethod = appointmentProvider.paymentMethod;
    if (_currentStep < _titles.length - 1) {
      if (_currentStep == 0) {
        if (patientProfile == null) {
          CustomFlushbar.show(
            context,
            status: 'warning',
            title: 'Chưa có hồ sơ bệnh nhân',
            message: 'Vui lòng thêm hồ sơ bệnh nhân để tiếp tục đặt lịch khám.',
          );
          return;
        }
        if (schedule == null) {
          CustomFlushbar.show(
            context,
            status: 'warning',
            title: 'Chưa chọn ngày khám',
            message: 'Vui lòng chọn ngày khám để tiếp tục đặt lịch khám.',
          );
          return;
        }
        if (slot == null) {
          CustomFlushbar.show(
            context,
            status: 'warning',
            title: 'Chưa chọn giờ khám',
            message: 'Vui lòng chọn giờ khám.',
          );
          return;
        }
      }
      setState(() => _currentStep += 1);
    } else {
      if (patientProfile == null) {
        CustomFlushbar.show(
          context,
          status: 'warning',
          title: 'Chưa có hồ sơ bệnh nhân',
          message: 'Vui lòng thêm hồ sơ bệnh nhân để tiếp tục đặt lịch khám.',
        );
        return;
      }
      if (schedule == null) {
        CustomFlushbar.show(
          context,
          status: 'warning',
          title: 'Chưa chọn ngày khám',
          message: 'Vui lòng chọn ngày khám để tiếp tục đặt lịch khám.',
        );
        return;
      }
      if (slot == null) {
        CustomFlushbar.show(
          context,
          status: 'warning',
          title: 'Chưa chọn giờ khám',
          message: 'Vui lòng chọn giờ khám.',
        );
        return;
      }
      if (paymentMethod == null) {
        CustomFlushbar.show(
          context,
          status: 'warning',
          title: 'Chưa chọn phương thức thanh toán',
          message:
              'Vui lòng chọn phương thức thanh toán để tiếp tục đặt lịch khám.',
        );
        return;
      }
      if (doctorService == null) {
        CustomFlushbar.show(
          context,
          status: 'warning',
          title: 'Chưa chọn dịch vụ khám',
          message: 'Vui lòng chọn dịch vụ khám để tiếp tục đặt lịch khám.',
        );
        return;
      }
      final result = await appointmentProvider.createAppointment();
      if (!mounted) return;
      await CustomFlushbar.show(
        context,
        status: result.status,
        message: result.message,
      );
      if (result.status == 'success' && mounted) {
        // di chuyển đến thanh toán
        context.read<AppointmentProvider>().disableSlot(result.data!.slot!);
        if (paymentMethod == 'online') {
          if (!mounted) return;
          context.goNamed(
            'paymentQRCode',
            pathParameters: {
              'doctorId': widget.doctorId,
            },
            extra: result.data as Appointment,
          );
        } else {
          if (!mounted) return;
          context.goNamed(
            'bookingSuccess',
            pathParameters: {
              'doctorId': widget.doctorId,
            },
            extra: result.data as Appointment,
          );
        }
      }
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
              child: Container(
                color: Colors.grey.shade200,
                child: SingleChildScrollView(
                  // nếu nội dung cao thì cho cuộn dọc
                  child: _contents[_currentStep],
                ),
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
