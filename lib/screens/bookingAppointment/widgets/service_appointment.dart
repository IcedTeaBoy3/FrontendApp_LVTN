import 'package:flutter/material.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:frontend_app/utils/currency_utils.dart';
import 'package:frontend_app/widgets/dash_divider.dart';

class ServiceAppointment extends StatefulWidget {
  final String doctorId;
  const ServiceAppointment({super.key, required this.doctorId});

  @override
  State<ServiceAppointment> createState() => _ServiceAppointmentState();
}

class _ServiceAppointmentState extends State<ServiceAppointment> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentProvider = context.read<AppointmentProvider>();
      final doctor = context.read<DoctorProvider>().findById(widget.doctorId)!;
      final doctorServices = doctor.doctorServices;

      // Chỉ set lần đầu khi chưa có dữ liệu
      if (appointmentProvider.paymentType == null) {
        appointmentProvider.setPaymentType('service');
      }

      if (appointmentProvider.selectedDoctorService == null) {
        if (doctorServices.isNotEmpty) {
          final defaultService = doctorServices[0];
          appointmentProvider.setDoctorService(defaultService);
        }
      }
    });
  }

  void _handleSelectedType(String? value, BuildContext context) {
    final patientProfile =
        context.read<AppointmentProvider>().selectedPatientProfile;
    if (value == 'insurance' && patientProfile == null) {
      CustomFlushbar.show(
        status: 'warning',
        context,
        message: 'Vui lòng chọn hồ sơ bệnh nhân có bảo hiểm y tế',
      );
    }
    context.read<AppointmentProvider>().setPaymentType(value!);
  }

  void _handleSelectedService(String? value) {
    final doctor = context.read<DoctorProvider>().findById(widget.doctorId)!;
    final doctorServices = doctor.doctorServices;
    final selectedService = doctorServices
        .firstWhere((service) => service.doctorServiceId == value);
    context.read<AppointmentProvider>().setDoctorService(selectedService);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(widget.doctorId);
    final doctorServices = doctor?.doctorServices ?? [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            child: Text(
              'Chọn hình thức khám',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: DashedDivider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          // Thêm các widget khác để hiển thị và chọn dịch vụ
          Container(
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[50],
                    border: context.watch<AppointmentProvider>().paymentType ==
                            'service'
                        ? Border.all(color: AppColors.primaryBlue, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    title: Text(
                      'Khám dịch vụ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text('Khám dịch vụ do bạn tự chi trả'),
                    leading: Radio(
                      value: 'service',
                      groupValue:
                          context.watch<AppointmentProvider>().paymentType,
                      onChanged: (value) {
                        _handleSelectedType(value, context);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[50],
                    border: context.watch<AppointmentProvider>().paymentType ==
                            'insurance'
                        ? Border.all(color: AppColors.primaryBlue, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    title: Text(
                      'Khám bảo hiểm y tế (BHYT)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle:
                        Text('Khám qua bảo hiểm y tế, bảo hiểm chi trả 80%'),
                    leading: Radio(
                      value: 'insurance',
                      groupValue:
                          context.watch<AppointmentProvider>().paymentType,
                      onChanged: (value) {
                        _handleSelectedType(value, context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
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
            child: Text(
              'Chọn dịch vụ khám',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.blue,
              ),
            ),
            child: DashedDivider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          Container(
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
            child: ListView.builder(
              shrinkWrap:
                  true, // để list không chiếm hết màn hình nếu trong Column
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctorServices.length,
              itemBuilder: (context, index) {
                final doctorService = doctorServices[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[50], // màu mặc định
                    border: context
                                .watch<AppointmentProvider>()
                                .selectedDoctorService
                                ?.doctorServiceId ==
                            doctorService.doctorServiceId
                        ? Border.all(color: AppColors.primaryBlue, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    leading: Radio<String>(
                      value: doctorService.doctorServiceId,
                      groupValue: context
                          .watch<AppointmentProvider>()
                          .selectedDoctorService
                          ?.doctorServiceId,
                      onChanged: (value) {
                        _handleSelectedService(value);
                      },
                    ),
                    title: Text(
                      doctorService.service?.name ?? '--',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text(
                      doctorService.service?.description ?? '--',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (context.watch<AppointmentProvider>().paymentType ==
                            'insurance') // chỉ hiện giá gốc khi khám BHYT
                          Text(
                            formatCurrency(doctorService.price),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  decoration: TextDecoration
                                      .lineThrough, // 👈 gạch ngang
                                ),
                          ),
                        if (context.watch<AppointmentProvider>().paymentType ==
                            'insurance') // chỉ hiện giá BHYT khi khám BHYT
                          const SizedBox(width: 6),
                        Text(
                          context.watch<AppointmentProvider>().paymentType ==
                                  'service'
                              ? formatCurrency(doctorService.price)
                              : formatCurrency(doctorService.price * 0.2),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
