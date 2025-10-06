import 'package:frontend_app/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/widgets/dash_divider.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/utils/currency_utils.dart';
import 'package:frontend_app/widgets/modal_detail_patientprofile.dart';

class DetailAppointmentScreen extends StatelessWidget {
  final Appointment appointment;
  const DetailAppointmentScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final clinic = context.read<ClinicProvider>().clinic;
    final doctor = appointment.doctorService.doctor;
    final appointmentNumber = appointment.appointmentNumber;
    final patient = appointment.patientProfile;
    final doctorService = appointment.doctorService;
    final service = doctorService.service;
    final schedule = appointment.schedule;
    final slot = appointment.slot;
    final payment = appointment.payment;
    final avatarUrl = doctor?.person.avatar != null
        ? '${ApiConfig.backendUrl}${doctor?.person.avatar}'
        : null;
    String _converStatus(String status) {
      switch (status) {
        case 'pending':
          return 'Chờ xác nhận';
        case 'confirmed':
          return 'Đã xác nhận';
        case 'completed':
          return 'Đã hoàn thành';
        case 'canceled':
          return 'Đã hủy';
        default:
          return status;
      }
    }

    Icon _getStatusIcon(String status) {
      switch (status) {
        case 'pending':
          return const Icon(Icons.hourglass_empty, color: Colors.white);
        case 'confirmed':
          return const Icon(Icons.check_circle, color: Colors.white);
        case 'completed':
          return const Icon(Icons.check_circle_outline, color: Colors.white);
        case 'canceled':
          return const Icon(Icons.cancel, color: Colors.white);
        default:
          return const Icon(Icons.help_outline, color: Colors.white);
      }
    }

    Color _getStatusColor(String status) {
      switch (status) {
        case 'pending':
          return Colors.orange;
        case 'confirmed':
          return Colors.blue;
        case 'completed':
          return Colors.green;
        case 'canceled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chi tiết lịch hẹn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'STT',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 20,
                                  ),
                            ),
                            Text(
                              appointmentNumber != null
                                  ? appointmentNumber.toString()
                                  : '--',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 36,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),
                        Icon(
                          Icons.qr_code,
                          size: 80,
                          color: Colors.grey[700],
                        )
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment.status),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          _getStatusIcon(appointment.status),
                          Text(
                            _converStatus(appointment.status),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: DashedDivider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã phiếu khám:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            appointment.appointmentCode ?? '',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày khám:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            formatDate(schedule.workday),
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Giờ khám:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            '${formatTime(slot.startTime)} - ${formatTime(slot.endTime)} (${slot.shift?.name ?? ''})',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Thông tin bệnh nhân',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã bệnh nhân',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            patient.patientProfileCode,
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Họ và tên',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            patient.person.fullName,
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số điện thoại',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            patient.person.phone ?? '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: DashedDivider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    handleShowDetailPatientProfile(context, patient);
                  },
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Thông tin bác sĩ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doctor?.person.fullName ?? '--',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                        ),
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl) as ImageProvider
                              : const AssetImage(
                                  'assets/images/avatar-default-icon.png'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chuyên khoa',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            service?.specialty?.name ?? '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Địa chỉ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            clinic?.address ?? '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: DashedDivider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    context.pushNamed('doctorDetail', pathParameters: {
                      'doctorId': doctor!.doctorId.toString(),
                    });
                  },
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Thông tin thanh toán',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trạng thái',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: payment != null
                                ? (payment.status == 'paid'
                                    ? Colors.green
                                    : Colors.orange)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                payment != null
                                    ? (payment.status == 'paid'
                                        ? Icons.check_circle
                                        : Icons.hourglass_empty)
                                    : Icons.help_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                payment != null
                                    ? payment.status == 'paid'
                                        ? 'Đã thanh toán'
                                        : 'Chưa thanh toán'
                                    : 'Chưa cập nhật',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hình thức khám',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            payment != null
                                ? payment.paymentType == 'service'
                                    ? 'Khám dịch vụ'
                                    : 'Khám BHYT'
                                : '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phương thức',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            payment?.method == 'cash'
                                ? 'Tiền mặt'
                                : payment?.method == 'momo'
                                    ? 'Momo'
                                    : payment?.method == 'bank'
                                        ? 'Chuyển khoản'
                                        : '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số tiền',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            payment != null
                                ? formatCurrency(payment.amount)
                                : '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày thanh toán',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[600]),
                        ),
                        Expanded(
                          child: Text(
                            payment?.payAt != null
                                ? formatDate(payment!.payAt!)
                                : '--',
                            textAlign: TextAlign.right,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            ConfirmDialog.show(
              context,
              title: 'Xác nhận huỷ lịch',
              content: 'Bạn có chắc chắn muốn huỷ lịch hẹn này không?',
              cancelText: 'Không',
              confirmText: 'Huỷ',
              confirmColor: Colors.red,
              onConfirm: () {
                // Handle cancellation logic here
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Huỷ lịch',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
