import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctorreview_provider.dart';
import 'doctor_review_card.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:frontend_app/widgets/custom_dropdownfield.dart';
import 'modal_doctor_review.dart';

class DoctorReviewList extends StatefulWidget {
  final String doctorId;
  const DoctorReviewList({super.key, required this.doctorId});

  @override
  State<DoctorReviewList> createState() => _DoctorReviewListState();
}

class _DoctorReviewListState extends State<DoctorReviewList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DoctorreviewProvider>()
          .fetchDoctorReviewsByDoctorId(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
            child: CustomDropdownField<String>(
              label: 'Đánh giá và nhận xét',
              hintText: 'Sắp xếp',
              value: context.watch<DoctorreviewProvider>().selectedSortOption,
              items: const ['Mới nhất', 'Cũ nhất'],
              itemLabel: (item) => item,
              onChanged: (value) {
                if (value != null) {
                  context.read<DoctorreviewProvider>().setSortOption(value);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Consumer<DoctorreviewProvider>(
            builder: (context, reviewProvider, child) {
              if (reviewProvider.isLoading) {
                return const CustomLoading();
              }
              final reviews = reviewProvider.doctorReviews;
              if (reviews.isEmpty) {
                return Center(child: const Text("Chưa có đánh giá nào."));
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: reviews.length > 5 ? 5 : reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return DoctorReviewCard(review: review);
                },
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openModalDoctorReview(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(color: Colors.grey.shade300),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
              ),
              child: Text(
                'Xem tất cả đánh giá và nhận xét',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
