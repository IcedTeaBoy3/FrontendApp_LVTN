import 'package:flutter/material.dart';

class ClinicDetailWorkhours extends StatelessWidget {
  final String? workHours;
  const ClinicDetailWorkhours({super.key, this.workHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                "Giờ làm việc",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            workHours ?? "Chưa cập nhật",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
