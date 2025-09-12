import 'package:flutter/material.dart';

class ClinicDetailSpecialty extends StatelessWidget {
  const ClinicDetailSpecialty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                "Chuyên khoa",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Chưa cập nhật",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
