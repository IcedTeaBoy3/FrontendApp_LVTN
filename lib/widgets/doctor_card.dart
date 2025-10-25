import 'package:flutter/material.dart';
import 'package:frontend_app/configs/api_config.dart';

class DoctorCard extends StatelessWidget {
  final String doctorId;
  final String name;
  final String specialtyName;
  final double? star;
  final int? countReview;
  final String? avatar;
  final Function()? onTap;
  const DoctorCard({
    super.key,
    required this.doctorId,
    required this.name,
    required this.specialtyName,
    this.star,
    this.countReview,
    this.avatar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = (avatar != null && avatar!.isNotEmpty)
        ? ApiConfig.backendUrl + avatar!
        : null;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar bác sĩ
            CircleAvatar(
              radius: 42,
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
            const SizedBox(width: 16),

            // Thông tin bác sĩ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BS. $name",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Chuyên khoa: $specialtyName",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // đánh giá
                  // ⭐ Đánh giá
                  Row(
                    children: [
                      if (star != null) ...[
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          star!.toStringAsFixed(1),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                      if (countReview != null) ...[
                        if (star != null) const SizedBox(width: 12),
                        Text(
                          '($countReview đánh giá)',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
