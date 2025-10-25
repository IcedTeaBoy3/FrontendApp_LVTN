import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctorreview_provider.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_review_card.dart';

void openModalDoctorReview(BuildContext context) {
  final doctorreviews = context.read<DoctorreviewProvider>().doctorReviews;
  final total = doctorreviews.length;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tất cả đánh giá",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: total,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final review = doctorreviews[index];
                  return DoctorReviewCard(
                    review: review,
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
