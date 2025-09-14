import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctor.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/configs/api_config.dart';

class DoctorDetailDoctorInfo extends StatelessWidget {
  final String doctorId;
  const DoctorDetailDoctorInfo({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final Doctor? doctor = context.read<DoctorProvider>().findById(doctorId);
    final avatarUrl = (doctor?.user.avatar != null)
        ? ApiConfig.backendUrl + doctor!.user.avatar!
        : null;
    final degreeName = doctor?.degree.title ?? "Chưa cập nhật";
    final specialties =
        doctor?.doctorSpecialties.map((ds) => ds.specialty.name) ?? [];
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person,
                                size: 50, color: Colors.blue.shade700);
                          },
                        )
                      : Icon(Icons.person,
                          size: 50, color: Colors.blue.shade700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BS.$degreeName",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      doctor?.user.name ?? "Chưa cập nhật",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${doctor?.yearsOfExperience} năm kinh nghiệm",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${doctor?.primaryPositionName} tại ${doctor?.primaryWorkplaceName}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Chuyên khoa:",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: specialties.isNotEmpty
                      ? specialties
                          .map((spec) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  spec,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.blue.shade800,
                                      ),
                                ),
                              ))
                          .toList()
                      : [
                          Text(
                            "Chưa cập nhật",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                ),
              )
            ],
          ),
          // Nếu có nhiều chuyên khoa thì thêm list chỗ này
        ],
      ),
    );
  }
}
