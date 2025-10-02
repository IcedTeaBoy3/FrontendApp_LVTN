import 'package:flutter/material.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceAppointment extends StatefulWidget {
  final String doctorId;
  const ServiceAppointment({super.key, required this.doctorId});

  @override
  State<ServiceAppointment> createState() => _ServiceAppointmentState();
}

class _ServiceAppointmentState extends State<ServiceAppointment> {
  String? _selectedType = 'service'; // 'service' hoặc 'insurance'
  String? _selectedServiceId;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentProvider = context.read<AppointmentProvider>();
      final doctor = context.read<DoctorProvider>().findById(widget.doctorId)!;
      final doctorServices = doctor.doctorServices;

      if (doctorServices.isNotEmpty) {
        final defaultService = doctorServices[0];
        appointmentProvider.setDoctorService(defaultService);
        setState(() {
          _selectedServiceId = defaultService.doctorServiceId;
        });
      } else {
        appointmentProvider.setDoctorService(null);
        setState(() {
          _selectedServiceId = null;
        });
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

    setState(() {
      _selectedType = value;
    });
  }

  void _handleSelectedService(String? value) {
    setState(() {
      _selectedServiceId = value;
    });
    final doctor = context.read<DoctorProvider>().findById(widget.doctorId)!;
    final doctorServices = doctor.doctorServices ?? [];
    final selectedService = doctorServices
        .firstWhere((service) => service.doctorServiceId == value);
    context.read<AppointmentProvider>().setDoctorService(selectedService);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(widget.doctorId);
    final doctorServices = doctor?.doctorServices ?? [];
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Chọn hình thức khám'.toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                    border: _selectedType == 'service'
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
                      groupValue: _selectedType,
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
                    border: _selectedType == 'insurance'
                        ? Border.all(color: AppColors.primaryBlue, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    title: Text(
                      'Khám Bảo hiểm y tế',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle:
                        Text('Khám qua bảo hiểm y tế, bảo hiểm chi trả 80%'),
                    leading: Radio(
                      value: 'insurance',
                      groupValue: _selectedType,
                      onChanged: (value) {
                        _handleSelectedType(value, context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Chọn dịch vụ khám'.toUpperCase(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                    border: _selectedServiceId == doctorService.doctorServiceId
                        ? Border.all(color: AppColors.primaryBlue, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    leading: Radio<String>(
                      value: doctorService.doctorServiceId,
                      groupValue: _selectedServiceId,
                      onChanged: (value) {
                        _handleSelectedService(value);
                      },
                    ),
                    title: Text(
                      doctorService.service.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text(
                      doctorService.service.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedType ==
                            'insurance') // chỉ hiện giá gốc khi khám BHYT
                          Text(
                            '${doctorService.price.toStringAsFixed(0)} đ',
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
                        if (_selectedType == 'insurance')
                          const SizedBox(width: 6),
                        Text(
                          _selectedType == 'service'
                              ? '${doctorService.price.toStringAsFixed(0)} đ'
                              : '${(doctorService.price * 0.2).toStringAsFixed(0)} đ',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _selectedServiceId = doctorService.doctorServiceId;
                      });
                    },
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
