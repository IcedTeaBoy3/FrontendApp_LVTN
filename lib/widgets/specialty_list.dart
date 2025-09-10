import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend_app/widgets/specialty_card.dart';

class SpecialtyList extends StatefulWidget {
  const SpecialtyList({super.key});

  @override
  State<SpecialtyList> createState() => _SpecialtyListState();
}

class _SpecialtyListState extends State<SpecialtyList> {
  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu chuyên khoa khi khởi tạo widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final specialtyProvider = context.read<SpecialtyProvider>();
      specialtyProvider.fetchSpecialties(page: 1, limit: 100);
    });
  }

  void _openSpecialtySheet(BuildContext context) {
    final specialtyProvider = context.read<SpecialtyProvider>();
    final specialties = specialtyProvider.specialties;
    final total = specialtyProvider.total;
    showModalBottomSheet(
      context: context,
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
              Container(
                width: 50,
                height: 5,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "Tất cả chuyên khoa",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: total,
                    itemBuilder: (context, index) {
                      final specialty = specialties[index];
                      return SpecialtyCard(
                        name: specialty.name,
                        image: specialty.image,
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final specialtyProvider = context.watch<SpecialtyProvider>();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              TextButton(
                onPressed: () => _openSpecialtySheet(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Xem tất cả', style: TextStyle(color: Colors.blue)),
                    SizedBox(width: 4), // khoảng cách giữa chữ và icon
                    Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
                  ],
                ),
              )
            ],
          ),
          // Danh sách chuyên khoa
          const SizedBox(height: 8),
          specialtyProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: 230,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4,
                    ),
                    // Nếu có nhiều hơn 8 thì chỉ lấy 8 phần tử
                    itemCount: specialtyProvider.specialties.length > 8
                        ? 8
                        : specialtyProvider.specialties.length,
                    itemBuilder: (context, index) {
                      // Hiển thị card bình thường
                      final specialty = specialtyProvider.specialties[index];
                      return SpecialtyCard(
                        name: specialty.name,
                        image: specialty.image,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
