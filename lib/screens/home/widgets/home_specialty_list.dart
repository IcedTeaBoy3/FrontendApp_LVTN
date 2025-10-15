import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/widgets/specialty_card.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:frontend_app/widgets/modal_list_specialties.dart';

class HomeSpecialtyList extends StatefulWidget {
  const HomeSpecialtyList({super.key});

  @override
  State<HomeSpecialtyList> createState() => _HomeSpecialtyListState();
}

class _HomeSpecialtyListState extends State<HomeSpecialtyList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpecialtyProvider>().fetchSpecialties(page: 1, limit: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FaIcon(
                FontAwesomeIcons.stethoscope,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(
                width: 6,
              ), // khoảng cách giữa icon và text
              Text(
                'Chuyên khoa',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          // Danh sách chuyên khoa
          const SizedBox(height: 8),
          Consumer<SpecialtyProvider>(
            builder: (context, specialtyProvider, child) {
              if (specialtyProvider.isLoading) {
                return const CustomLoading();
              }
              final specialties = specialtyProvider.specialties;
              if (specialties.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Không thể tải thông tin chuyên khoa'),
                  ),
                );
              }
              return SizedBox(
                height: 230,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  // Nếu có nhiều hơn 8 thì chỉ lấy 8 phần tử
                  itemCount: specialties.length > 8 ? 8 : specialties.length,
                  itemBuilder: (context, index) {
                    // Hiển thị card bình thường
                    final specialty = specialties[index];
                    return SpecialtyCard(
                      specialtyId: specialty.specialtyId,
                      name: specialty.name,
                      image: specialty.image,
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openSpecialtySheet(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(color: Colors.grey.shade300),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: Text(
                'Xem tất cả các chuyên khoa',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
