import 'package:flutter/material.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:frontend_app/models/doctorreview.dart';
import 'package:frontend_app/utils/date_utils.dart';

class DoctorReviewCard extends StatelessWidget {
  final DoctorReview review;
  const DoctorReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final patient = review.appointment?.patientProfile?.person;
    final patientAvatarUrl = patient?.avatar != null
        ? '${ApiConfig.backendUrl}${patient!.avatar!}'
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧑 Avatar bệnh nhân
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: ClipOval(
                child: patientAvatarUrl != null
                    ? Image.network(
                        patientAvatarUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/avatar-default-icon.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/avatar-default-icon.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // 📋 Nội dung bên phải
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên bệnh nhân + ngày (nếu có)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        patient?.fullName ?? 'Người dùng ẩn danh',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        formatDate(review.createdAt ?? DateTime.now()),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // ⭐ Hàng sao
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 💬 Nội dung bình luận
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      review.comment.isNotEmpty ? review.comment : '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                            height: 1.3,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
