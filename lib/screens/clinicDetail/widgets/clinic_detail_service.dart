import 'package:flutter/material.dart';
import 'package:frontend_app/models/service.dart';

class ClinicDetailService extends StatelessWidget {
  final List<Service> services;
  const ClinicDetailService({super.key, required this.services});

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
                "Dịch vụ nổi bật",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          services.isEmpty
              ? Text(
                  "Chưa cập nhật dịch vụ",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: services
                      .map(
                        (service) => Chip(
                          label: Text(
                            service.name,
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
                        ),
                      )
                      .toList(),
                )
        ],
      ),
    );
  }
}
