import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String avatar;
  const DoctorCard(
      {super.key,
      required this.name,
      required this.specialty,
      required this.rating,
      required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar bác sĩ
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(
              avatar,
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin bác sĩ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên bác sĩ
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Chuyên khoa
                Text(
                  specialty,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Rating + số lượt đánh giá
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(120 đánh giá)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Icon mũi tên → để điều hướng
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
