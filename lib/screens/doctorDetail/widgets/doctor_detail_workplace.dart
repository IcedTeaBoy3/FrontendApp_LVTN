import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';

class DoctorDetailWorkplace extends StatelessWidget {
  final String doctorId;
  const DoctorDetailWorkplace({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<DoctorProvider>().findById(doctorId);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Text(
                "Nơi công tác",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            doctor?.primaryWorkplaceName ?? 'Chưa cập nhật',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
