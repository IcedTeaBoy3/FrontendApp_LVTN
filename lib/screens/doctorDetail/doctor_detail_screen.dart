import 'package:flutter/material.dart';

import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_doctorInfor.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_schedule.dart';
import 'package:frontend_app/widgets/clinic_detail_googlemap.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_bio.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_workplace.dart';
import 'package:frontend_app/providers/clinic_provider.dart';

import 'package:provider/provider.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String doctorId;
  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final clinic = context.read<ClinicProvider>().clinic;
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
            const SizedBox(
              height: 8,
            ),
            ClinicDetailGooglemap(address: clinic?.address ?? 'Đang cập nhật'),
            const SizedBox(
              height: 8,
            ),
            DoctorDetailBio(doctorId: doctorId),
            const SizedBox(
              height: 8,
            ),
            DoctorDetailWorkplace(doctorId: doctorId),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Xử lý đặt khám
              },
              child: const Text(
                "Đặt khám",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
