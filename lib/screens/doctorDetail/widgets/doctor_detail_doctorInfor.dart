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
    final avatarPath = doctor?.person.avatar;
    final avatarUrl = (avatarPath != null && avatarPath.isNotEmpty)
        ? '${ApiConfig.backendUrl}$avatarPath'
        : null;
    final degreeName = doctor?.degree?.title ?? "Chưa cập nhật";
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                          avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/avatar-default-icon.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/avatar-default-icon.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      degreeName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      doctor?.person.fullName ?? "Chưa cập nhật",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${doctor?.yearsOfExperience} năm kinh nghiệm",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${doctor?.primaryPositionName} tại ${doctor?.primaryWorkplaceName}",
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            "Chuyên khoa:",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          specialties.isNotEmpty
              ? Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: List.generate(specialties.length, (index) {
                    final spec = specialties.elementAt(index);
                    final isLast = index == specialties.length - 1;
                    return Text(
                      isLast ? spec : '$spec,',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }),
                )
              : Text(
                  "Chưa cập nhật",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                )
        ],
      ),
    );
  }
}
