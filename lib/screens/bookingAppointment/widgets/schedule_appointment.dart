import 'package:flutter/material.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/models/doctor.dart';
import 'package:frontend_app/providers/doctor_provider.dart';

class ScheduleAppointment extends StatefulWidget {
  final String doctorId;

  const ScheduleAppointment({super.key, required this.doctorId});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(widget.doctorId);
    final String avatarUrl =
        (doctor?.person.avatar != null && doctor!.person.avatar!.isNotEmpty)
            ? ApiConfig.backendUrl + doctor.person.avatar!
            : 'https://via.placeholder.com/150';
    final specialties =
        doctor?.doctorSpecialties.map((ds) => ds.specialty.name) ?? [];
    final degreeName = doctor?.degree.title ?? "Chưa cập nhật";
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
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
          child: ListTile(
            leading: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person,
                        size: 50, color: Colors.blue.shade700);
                  },
                ),
              ),
            ),
            title: Text(
              'BS. ${doctor?.person.fullName ?? "Chưa cập nhật"}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  degreeName,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  specialties.isNotEmpty
                      ? specialties.join(', ')
                      : 'Chưa cập nhật chuyên khoa',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Phần màu vàng bên dưới
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
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
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
          ),
        ),
        // Text mở rộng
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Bạn nên đến sớm 15 phút để làm thủ tục.\n"
              "Mang theo giấy tờ tuỳ thân và hồ sơ y tế (nếu có).",
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        )
      ],
    );
  }
}
