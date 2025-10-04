import 'package:flutter/material.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/configs/api_config.dart';

class CardDoctorAppointment extends StatelessWidget {
  final String doctorId;
  const CardDoctorAppointment({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(doctorId);
    final avatarUrl = (doctor?.person.avatar != null)
        ? ApiConfig.backendUrl + doctor!.person.avatar!
        : null;
    final specialties =
        doctor?.doctorSpecialties.map((ds) => ds.specialty.name) ?? [];
    final degreeName = doctor?.degree?.title ?? "Chưa cập nhật";
    return Row(
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
                : Icon(Icons.person, size: 50, color: Colors.blue.shade700),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BS. $degreeName",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.blue,
                    ),
              ),
              SizedBox(height: 4),
              Text(
                doctor?.person.fullName ?? "Bác sĩ chưa cập nhật",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                specialties.isNotEmpty
                    ? "Chuyên khoa: ${specialties.join(', ')}"
                    : "Chuyên khoa chưa cập nhật",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
