import 'package:flutter/material.dart';
import 'card_doctor_appointment.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/currency_utils.dart';

class ConfirmAppointment extends StatefulWidget {
  final String doctorId;
  const ConfirmAppointment({super.key, required this.doctorId});

  @override
  State<ConfirmAppointment> createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentProvider = context.read<AppointmentProvider>();
      if (appointmentProvider.paymentMethod == null) {
        appointmentProvider.setPaymentMethod('cash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = context.watch<AppointmentProvider>();
    final selectedSchedule = appointmentProvider.selectedSchedule;
    final selectedSlot = appointmentProvider.selectedSlot;
    final patientProfile = appointmentProvider.selectedPatientProfile;
    final doctorService = appointmentProvider.selectedDoctorService;
    final paymentType = appointmentProvider.paymentType;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Thông tin đăng ký'.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 16,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CardDoctorAppointment(
                doctorId: widget.doctorId,
              ),
              const Divider(
                height: 32,
                thickness: 1,
                color: Colors.grey,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày khám',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Giờ khám',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedSchedule != null
                          ? formatDate(selectedSchedule.workday)
                          : 'Chưa chọn',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      selectedSlot != null
                          ? '${DateFormat.Hm().format(selectedSlot.startTime)} - ${DateFormat.Hm().format(selectedSlot.endTime)}'
                          : 'Chưa chọn',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              //Chuyên khoa
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chuyên khoa',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doctorService != null
                          ? doctorService.service?.specialty?.name ??
                              'Chưa cập nhật'
                          : 'Chưa chọn',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text(
                      "Thông tin bệnh nhân", // chữ bạn muốn
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Họ và tên',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      patientProfile != null
                          ? patientProfile.person.fullName
                          : 'Chưa có',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày sinh',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      patientProfile != null
                          ? formatDate(patientProfile.person.dateOfBirth)
                          : 'Chưa có',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Giới tính
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Giới tính',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      convertGenderBack(patientProfile?.person.gender ?? ''),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              // Số điện thoại
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Số điện thoại',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      patientProfile?.person.phone ?? 'Chưa có',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Thông tin thanh toán'.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 16,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hình thức khám',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      paymentType == 'service'
                          ? 'Khám dịch vụ'
                          : 'Khám bảo hiểm y tế',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Dịch vụ khám',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      doctorService != null
                          ? doctorService.service?.name ?? 'Chưa cập nhật'
                          : 'Chưa cập nhật',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Phí khám',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      doctorService != null
                          ? formatCurrency(doctorService.price *
                              (paymentType == 'service' ? 1 : 0.2))
                          : 'Chưa cập nhật',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text(
                      "Hình thức thanh toán", // chữ bạn muốn
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border:
                          context.watch<AppointmentProvider>().paymentMethod ==
                                  'cash'
                              ? Border.all(color: Colors.blue, width: 1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<String>(
                      value: 'cash',
                      groupValue:
                          context.watch<AppointmentProvider>().paymentMethod,
                      onChanged: (value) {
                        context
                            .read<AppointmentProvider>()
                            .setPaymentMethod(value!);
                      },
                      title: Text(
                        'Thanh toán khi đến khám',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border:
                          context.watch<AppointmentProvider>().paymentMethod ==
                                  'online'
                              ? Border.all(color: Colors.blue, width: 1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<String>(
                      value: 'online',
                      groupValue:
                          context.watch<AppointmentProvider>().paymentMethod,
                      onChanged: (value) {
                        context
                            .read<AppointmentProvider>()
                            .setPaymentMethod(value!);
                      },
                      title: Text(
                        'Thanh toán online',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
