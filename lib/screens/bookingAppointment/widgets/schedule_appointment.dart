import 'package:flutter/material.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/date.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_schedule.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/screens/patientProfile/widgets/card_patientprofile.dart';
import 'package:frontend_app/screens/bookingAppointment/widgets/card_doctor_appointment.dart';
import 'package:go_router/go_router.dart';

class ScheduleAppointment extends StatefulWidget {
  final String doctorId;

  const ScheduleAppointment({super.key, required this.doctorId});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  bool _isExpanded = false;

  void _handleChangePatientProfile(BuildContext context) {
    final patientProfiles =
        context.read<PatientprofileProvider>().patientprofiles;
    final selectedProfile =
        context.read<AppointmentProvider>().selectedPatientProfile;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: patientProfiles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final profile = patientProfiles[index];
              return CardPatientProfile(
                patientprofile: profile,
                onTap: () {
                  context
                      .read<AppointmentProvider>()
                      .setSelectedPatientProfile(profile);
                  context.pop();
                },
                selected: profile.patientProfileId ==
                    selectedProfile?.patientProfileId,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Sau khi widget khởi tạo, gán patientProfile mặc định
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentProvider = context.read<AppointmentProvider>();
      final patientProfiles = context.read<PatientprofileProvider>();
      if (patientProfiles.patientprofiles.isEmpty) return;
      final patientProfile = patientProfiles.patientprofiles.first;
      appointmentProvider.setSelectedPatientProfile(patientProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProfile =
        context.watch<AppointmentProvider>().selectedPatientProfile;
    final doctor = context.watch<DoctorProvider>().findById(widget.doctorId);
    final notes = doctor?.notes ?? "Chưa cập nhật";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(30),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: CardDoctorAppointment(doctorId: widget.doctorId),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber[100], // nền vàng nhạt
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: InkWell(
              onTap: notes == "Chưa cập nhật"
                  ? null
                  : () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Lưu ý",
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        notes,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    secondChild: const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Đặt lịch khám này cho:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(30),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Họ và tên:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      patientProfile?.person.fullName ?? "Chưa có thông tin",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Giới tính:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      convertGenderBack(patientProfile!.person.gender),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ngày sinh:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      formatDate(patientProfile!.person.dateOfBirth),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Điện thoại:",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      patientProfile.person.phone ?? "Chưa có thông tin",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.goNamed(
                    'addPatientProfile',
                    extra: patientProfile,
                  ),
                  child: Text(
                    "Xem chi tiết",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleChangePatientProfile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                  child: Text(
                    "Thay đổi",
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Chọn ngày khám:",
              style: Theme.of(context).textTheme.bodyLarge,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
            ),
          ),
          DoctorDetailSchedule(doctorId: widget.doctorId),
        ],
      ),
    );
  }
}
