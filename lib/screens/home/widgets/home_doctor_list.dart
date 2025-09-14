import 'package:flutter/material.dart';
import 'package:frontend_app/widgets/doctor_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:provider/provider.dart';

class HomeDoctorList extends StatefulWidget {
  const HomeDoctorList({super.key});

  @override
  State<HomeDoctorList> createState() => _HomeDoctorListState();
}

class _HomeDoctorListState extends State<HomeDoctorList> {
  late Future<void> _fetchDoctors;
  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu bác sĩ khi khởi tạo widget
    _fetchDoctors = context.read<DoctorProvider>().fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
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
                    FontAwesomeIcons.userDoctor,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ), // khoảng cách giữa icon và text
                  Text(
                    'Bác sĩ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
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
          FutureBuilder(
            future: _fetchDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Lỗi khi tải dữ liệu: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ));
              } else if (doctorProvider.doctors.isEmpty) {
                return const Center(
                    child: Text(
                  'Không có bác sĩ nào',
                ));
              }
              final doctors = doctorProvider.doctors;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length > 8 ? 8 : doctors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorCard(
                      doctorId: doctor.doctorId,
                      name: doctor.user.name as String,
                      specialtyName: doctor.primarySpecialtyName,
                      avatar: doctor.user.avatar as String,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
