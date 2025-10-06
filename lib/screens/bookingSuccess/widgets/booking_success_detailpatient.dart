import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/widgets/dash_divider.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/widgets/modal_detail_patientprofile.dart';

class BookingSuccessDetailPatient extends StatelessWidget {
  final Patientprofile patientProfile;
  const BookingSuccessDetailPatient({super.key, required this.patientProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Họ và tên:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                patientProfile.person.fullName ?? "Chưa cập nhật",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày sinh:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                patientProfile.person.dateOfBirth != null
                    ? formatDate(patientProfile.person.dateOfBirth)
                    : "Chưa cập nhật",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giới tính:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                convertGenderBack(patientProfile.person.gender),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số điện thoại:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                patientProfile.person.phone ?? "Chưa cập nhật",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DashedDivider(
            color: Colors.grey,
            height: 1,
          ),
          TextButton(
            onPressed: () {
              handleShowDetailPatientProfile(context, patientProfile);
            },
            child: Text(
              'Chi tiết',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
