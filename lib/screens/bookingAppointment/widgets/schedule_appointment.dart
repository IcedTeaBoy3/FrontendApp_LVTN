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
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  void _handleAddMoreInfo(BuildContext context) async {
    final appointmentProvider = context.read<AppointmentProvider>();

    // 🟢 Lấy giá trị hiện tại từ Provider
    final TextEditingController symptomController =
        TextEditingController(text: appointmentProvider.symptoms ?? '');
    File? selectedImage = appointmentProvider.symptomsImage;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _pickImage() async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  selectedImage = File(pickedFile.path);
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lý do thăm khám",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 📝 Text area triệu chứng
                    TextField(
                      controller: symptomController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Ví dụ: Tôi bị sốt, ho, đau họng...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ảnh triệu chứng (nếu có)",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 📸 Upload ảnh
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: selectedImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo,
                                        size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text("Chọn ảnh"),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = null;
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black54,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ Nút lưu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            "symptom": symptomController.text.trim(),
                            "image": selectedImage,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Lưu thông tin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // 🟢 Sau khi đóng bottom sheet, lưu lại vào Provider
    if (result != null) {
      final symptom = result["symptom"] as String?;
      final image = result["image"] as File?;
      appointmentProvider.setSymptoms(symptom ?? "");
      appointmentProvider.setSymptomsImage(image);
    }
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
                        'addEditPatientProfile',
                        extra: patientProfile,
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
                      context.goNamed(
                        'addEditPatientProfile',
                        extra: patientProfile,
                      );
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
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Thông tin bổ sung (không bắt buộc):",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Bạn có thể cung cấp các thông tin như lý do khám, triệu chứng hiện tại, tiền sử bệnh lý, đơn thuốc,...",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handleAddMoreInfo(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tôi muốn cung cấp thêm thông tin ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.blue,
                    size: 16,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
