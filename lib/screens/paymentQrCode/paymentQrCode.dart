import 'package:flutter/material.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/services/payment_service.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/utils/currency_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/widgets/message_dialog.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'dart:async';

class PaymentQRCode extends StatefulWidget {
  final Appointment appointment;
  const PaymentQRCode({super.key, required this.appointment});

  @override
  State<PaymentQRCode> createState() => _PaymentQRCodeState();
}

class _PaymentQRCodeState extends State<PaymentQRCode>
    with SingleTickerProviderStateMixin {
  String? qrUrl;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final payment = widget.appointment.payment;
    PaymentService.createQRCode(
      payment?.amount ?? 0,
      payment?.paymentId ?? '',
      '',
    ).then((value) {
      debugPrint('QR Code URL: $value');
      setState(() {
        qrUrl = value;
        isLoading = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        try {
          final paymentres =
              await PaymentService.getPaymentStatus(payment?.paymentId ?? '');
          if (paymentres.status == 'paid') {
            timer.cancel();
            if (mounted) {
              final appointment = context
                  .read<AppointmentProvider>()
                  .updatePaymentStatus(
                      widget.appointment.appointmentId, 'paid');
              LottieDialog.show(
                context,
                animationPath: 'assets/animations/Success.json',
                type: 'success',
                message: 'Thanh toán thành công!',
                duration: 3,
                onClosed: () {
                  context.goNamed(
                    'bookingSuccess',
                    extra: appointment,
                  );
                },
              );
            }
          } else if (paymentres.status == 'failed') {
            timer.cancel();
            if (mounted) {
              LottieDialog.show(
                context,
                animationPath: 'assets/animations/Error.json',
                type: 'error',
                message: 'Thanh toán thất bại. Vui lòng thử lại.',
                duration: 3,
              );
            }
          }
        } catch (e) {
          debugPrint('Error checking payment: $e');
        }
      });
    }).catchError((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thanh toán QR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E88E5),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Quét mã QR để thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // QR Card với shadow đẹp
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(30),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: qrUrl != null
                        ? Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  qrUrl!,
                                  width: 260,
                                  height: 260,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      'Không thể tải mã QR',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Mã lịch hẹn: ${widget.appointment.appointmentCode}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Số tiền: ${formatCurrency(widget.appointment.payment?.amount ?? 0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Không có mã QR để hiển thị',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),

                  const SizedBox(height: 40),

                  // Nút hỗ trợ
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(
              'home',
              queryParameters: {'initialIndex': '3'},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Về trang chủ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
