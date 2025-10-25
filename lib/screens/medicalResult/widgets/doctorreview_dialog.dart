import 'package:flutter/material.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';

class DoctorReviewDialog extends StatefulWidget {
  const DoctorReviewDialog({super.key});

  @override
  State<DoctorReviewDialog> createState() => _DoctorReviewDialogState();
}

class _DoctorReviewDialogState extends State<DoctorReviewDialog> {
  double rating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🏷️ Tiêu đề
            const Text(
              "Đánh giá bác sĩ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // ⭐ Dãy sao chọn rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // 💬 Ô nhập nhận xét
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "Hãy chia sẻ trải nghiệm của bạn...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // 🔘 Hai nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text("Hủy"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (rating == 0) {
                      await CustomFlushbar.show(
                        context,
                        message: 'Vui lòng cung cấp đánh giá.',
                        status: 'error',
                      );
                      return;
                    }
                    Navigator.pop(context, {
                      'rating': rating,
                      'comment': commentController.text.trim(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Gửi đánh giá",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
