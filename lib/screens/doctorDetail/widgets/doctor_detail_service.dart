import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';

class DoctorDetailService extends StatelessWidget {
  final String doctorId;
  const DoctorDetailService({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(doctorId);
    final doctorServices = doctor?.doctorServices;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tiêu đề ---
          Row(
            children: [
              const Icon(
                Icons.medical_services_outlined,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Dịch vụ khám",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --- Nội dung ---
          if (doctorServices != null && doctorServices.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctorServices.map(
                (doctorService) {
                  final serviceName =
                      doctorService.service?.name ?? 'Chưa cập nhật';
                  return Chip(
                    label: Text(
                      serviceName,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    avatar: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Chưa cập nhật dịch vụ.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
