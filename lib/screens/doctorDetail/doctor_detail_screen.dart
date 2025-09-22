import 'package:flutter/material.dart';

import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_doctorInfor.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_schedule.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String doctorId;
  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade200
          : Colors.grey.shade800,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Chi tiết bác sĩ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Handle share button press
                },
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorDetailDoctorInfo(doctorId: doctorId),
            const SizedBox(
              height: 8,
            ),
            DoctorDetailSchedule(doctorId: doctorId),
          ],
        ),
      ),
    );
  }
}
