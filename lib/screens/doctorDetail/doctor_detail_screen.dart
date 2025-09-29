import 'package:flutter/material.dart';

import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_doctorInfor.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_schedule.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_bio.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_workplace.dart';
import 'package:frontend_app/widgets/clinic_detail_googlemap.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:go_router/go_router.dart';

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
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorDetailDoctorInfo(doctorId: doctorId),
            const SizedBox(
              height: 4,
            ),
            DoctorDetailSchedule(doctorId: doctorId),
            ClinicDetailGooglemap(address: clinic?.address ?? 'Đang cập nhật'),
            DoctorDetailBio(doctorId: doctorId),
            const SizedBox(
              height: 4,
            ),
            DoctorDetailWorkplace(doctorId: doctorId),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final isAuthenticated =
                  context.read<AuthProvider>().isAuthenticated;
              if (!isAuthenticated) {
                ConfirmDialog.show(
                  context,
                  title: 'Bạn chưa đăng nhập',
                  content: 'Vui lòng đăng nhập để đặt lịch khám.',
                  confirmText: 'Đăng nhập',
                  cancelText: 'Hủy',
                  onConfirm: () {
                    context.goNamed('login');
                  },
                );
              } else {
                context.goNamed('booking', pathParameters: {
                  'doctorId': doctorId,
                });
              }
            },
            child: const Text(
              "Đặt khám",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
