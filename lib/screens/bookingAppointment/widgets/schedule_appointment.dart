import 'package:flutter/material.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/date_utils.dart';
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
          child: Column(
            children: [
              Text(
                "Chọn hồ sơ bệnh nhân",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Thêm cái nút thêm mới hồ sơ
              const SizedBox(height: 8),
              // Nút thêm hồ sơ mới
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // màu nổi bật
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // bo tròn
                  ),
                  elevation: 5, // tạo bóng
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  context.goNamed('addEditPatientProfile');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Thêm hồ sơ mới",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: patientProfiles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
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
              ),
            ],
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
                      patientProfile?.person.fullName ?? "--",
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
                      patientProfile?.person.gender == null
                          ? "--"
                          : convertGenderBack(patientProfile!.person.gender),
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
                      patientProfile?.person.dateOfBirth == null
                          ? "--"
                          : formatDate(patientProfile!.person.dateOfBirth),
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
                      patientProfile?.person.phone ?? "--",
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
              color:
                  patientProfile == null ? Colors.amber[100] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(
                    patientProfile == null
                        ? Icons.error_outline
                        : Icons.arrow_forward_ios,
                    color: patientProfile == null ? Colors.orange : Colors.blue,
                    size: 18,
                  ),
                  onPressed: () {
                    if (patientProfile != null) {
                      context.goNamed(
                        'addPatientProfile',
                        extra: patientProfile,
                        queryParameters: {'from': 'booking'},
                      );
                    }
                  },
                  label: Text(
                    patientProfile == null ? "Chưa có hồ sơ" : "Xem chi tiết",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: patientProfile == null
                              ? Colors.orange
                              : Colors.blue,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (patientProfile == null) {
                      context.goNamed('addPatientProfile');
                    }
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
                    patientProfile == null ? "Thêm hồ sơ" : "Thay đổi",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
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
