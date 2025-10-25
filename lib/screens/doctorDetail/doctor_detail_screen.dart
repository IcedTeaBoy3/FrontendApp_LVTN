import 'package:flutter/material.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_doctorInfor.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_schedule.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_bio.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_detail_workplace.dart';
import 'package:frontend_app/widgets/clinic_detail_googlemap.dart';
import 'package:frontend_app/screens/doctorDetail/widgets/doctor_review_list.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/providers/clinic_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 📌 Đây là màn hình chi tiết bác sĩ có TabBar bên trong
class DoctorDetailScreen extends StatefulWidget {
  final String doctorId;
  final String? from;

  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.from,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clinic = context.read<ClinicProvider>().clinic;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade200
          : Colors.grey.shade800,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chi tiết bác sĩ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.from == 'search') {
              context.goNamed('search', queryParameters: {'query': ''});
            } else {
              context.goNamed('home');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Thông tin cơ bản bác sĩ
          DoctorDetailDoctorInfo(doctorId: widget.doctorId),

          const SizedBox(height: 8),

          // 🔹 TabBar nằm ngay trong nội dung
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(
                  text: 'Thông tin bác sĩ',
                  height: 20,
                ),
                Tab(
                  text: 'Đánh giá & Bình luận',
                ),
              ],
            ),
          ),

          // 🔹 Nội dung của từng tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 🩺 Tab 1: Thông tin bác sĩ
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorDetailSchedule(doctorId: widget.doctorId),
                      ClinicDetailGooglemap(
                        address: clinic?.address ?? 'Đang cập nhật',
                      ),
                      DoctorDetailBio(doctorId: widget.doctorId),
                      const SizedBox(height: 4),
                      DoctorDetailWorkplace(doctorId: widget.doctorId),
                    ],
                  ),
                ),

                // 💬 Tab 2: Đánh giá & Bình luận (placeholder)
                SingleChildScrollView(
                  child: DoctorReviewList(
                    doctorId: widget.doctorId,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 🔹 Nút đặt khám bên dưới
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final isAuthenticated =
                  context.read<AuthProvider>().isAuthenticated;

              if (!isAuthenticated) {
                ConfirmDialog.show(
                  context,
                  title: 'Bạn chưa đăng nhập',
                  content: 'Vui lòng đăng nhập để đặt lịch khám.',
                  confirmText: 'Đăng nhập',
                  cancelText: 'Hủy',
                  onConfirm: () {
                    context.goNamed(
                      'login',
                      extra: {
                        'from': context.namedLocation(
                          'doctorDetail',
                          pathParameters: {'doctorId': widget.doctorId},
                        ),
                      },
                    );
                  },
                );
              } else {
                context.goNamed(
                  'booking',
                  pathParameters: {'doctorId': widget.doctorId},
                );
              }
            },
            child: const Text(
              "Đặt khám",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
