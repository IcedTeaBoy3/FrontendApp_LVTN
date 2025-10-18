import 'package:flutter/material.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/widgets/dash_divider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/screens/bookingSuccess/widgets/booking_success_detaildoctor.dart';
import 'package:frontend_app/screens/bookingSuccess/widgets/booking_success_detailpatient.dart';
import 'package:frontend_app/screens/bookingSuccess/widgets/booking_success_payment.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Appointment appointment;
  const BookingSuccessScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctorService = appointment.doctorService;
    final patientProfile = appointment.patientProfile;
    final schedule = appointment.schedule;
    final slot = appointment.slot;
    final payment = appointment.payment;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Đặt lịch thành công',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // 🧱 Container chính
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Đặt lịch thành công!',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatTimeHHMMSS(DateTime.now())} - ${formatDate(DateTime.now())}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  // ✅ Dấu tích chồng lên
                  Positioned(
                    top: -40, // nửa chồng ra ngoài container
                    child: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 32,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'STT',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              appointment.appointmentNumber.toString(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.qr_code,
                          size: 100,
                          color: Colors.grey[400],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã lịch khám:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        ),
                        Text(
                          appointment.appointmentCode ?? "Chưa cập nhật",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày khám:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        ),
                        Text(
                          '${getWeekdayName(schedule?.workday ?? DateTime.now())}, ${formatDate(schedule?.workday ?? DateTime.now())}',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Giờ khám:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        ),
                        Text(
                          '${formatTime(slot?.startTime)} - ${formatTime(slot?.endTime)} (${slot?.shift?.name ?? ''})',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Thông tin bác sĩ'.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    ),
                    Expanded(
                      child: DashedDivider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              BookingSuccessDetaildoctor(doctorService: doctorService!),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Thông tin bệnh nhân'.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    ),
                    Expanded(
                      child: DashedDivider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              BookingSuccessDetailPatient(patientProfile: patientProfile!),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Thông tin thanh toán'.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    ),
                    Expanded(
                      child: DashedDivider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              BookingSuccessPayment(payment: payment!),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(
              'home',
              queryParameters: {'initialIndex': '3'},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black87),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Về trang chủ',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
