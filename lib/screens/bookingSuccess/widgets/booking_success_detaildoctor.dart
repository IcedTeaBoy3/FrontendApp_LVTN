import 'package:flutter/material.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/models/doctorservice.dart';
import 'package:frontend_app/configs/api_config.dart';

class BookingSuccessDetaildoctor extends StatelessWidget {
  final DoctorService doctorService;
  const BookingSuccessDetaildoctor({super.key, required this.doctorService});

  @override
  Widget build(BuildContext context) {
    final doctor = doctorService.doctor;
    final service = doctorService.service;
    final avatarUrl = (doctor?.person.avatar != null &&
            doctor?.person.avatar!.isNotEmpty == true)
        ? '${ApiConfig.backendUrl + doctor!.person.avatar!}'
        : null;
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.blue.shade100,
            child: ClipOval(
              child: avatarUrl != null
                  ? Image.network(
                      avatarUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/avatar-default-icon.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor?.degree?.title ?? "Chưa cập nhật",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor?.person.fullName ?? "Chưa cập nhật",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chuyên khoa:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        service?.specialty?.name ?? "Chưa cập nhật",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dịch vụ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        service?.name ?? "Chưa cập nhật",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
