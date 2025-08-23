import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend_app/widgets/InputSearch.dart';
import 'package:frontend_app/widgets/ServiceItem.dart';
import 'package:frontend_app/widgets/CustomNavbar.dart';
import 'package:frontend_app/widgets/Slider.dart';
import 'package:frontend_app/widgets/DoctorCard.dart';
import 'package:frontend_app/widgets/ClinicCard.dart';
import 'package:frontend_app/widgets/SpecialtyCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final doctors = [
    {
      'name': 'Dr. John Doe',
      'specialty': 'Tim mạch',
      'rating': 4.5,
      'image': 'assets/images/doctor_1.jpg',
    },
    {
      'name': 'Dr. Jane Smith',
      'specialty': 'Nhi khoa',
      'rating': 4.8,
      'image': 'assets/images/doctor_2.jpg',
    },
    {
      'name': 'Dr. Alex Lee',
      'specialty': 'Da liễu',
      'rating': 4.6,
      'image': 'assets/images/doctor_3.jpg',
    },
  ];
  final clinics = [
    {
      'name': 'Phòng khám đa khoa',
      'address': '123 Đường ABC, Quận 1',
      'rating': 4.5,
      'image': 'assets/images/Nhankhoa.png',
    },
    {
      'name': 'Phòng khám chuyên khoa',
      'address': '456 Đường DEF, Quận 2',
      'rating': 4.8,
      'image': 'assets/images/clinic_2.jpg',
    },
    {
      'name': 'Phòng khám nha khoa',
      'address': '789 Đường GHI, Quận 3',
      'rating': 4.6,
      'image': 'assets/images/clinic_3.jpg',
    },
  ];
  final specialties = [
    {
      'name': 'Nhi khoa',
      'image': 'assets/images/Nhikhoa.png',
    },
    {
      'name': 'Nhãn khoa',
      'image': 'assets/images/Nhankhoa.png',
    },
    {
      'name': 'Da liễu',
      'image': 'assets/images/Noithan.png',
    },
    {
      'name': 'Nội tổng quát',
      'image': 'assets/images/Noitongquat.png',
    },
    {
      'name': 'Nhãn khoa',
      'image': 'assets/images/Nhankhoa.png',
    },
    {
      'name': 'Da liễu',
      'image': 'assets/images/Noithan.png',
    },
    {
      'name': 'Nội tổng quát',
      'image': 'assets/images/Noitongquat.png',
    },
    {
      'name': 'Da liễu',
      'image': 'assets/images/Noithan.png',
    },
    {
      'name': 'Nội tổng quát',
      'image': 'assets/images/Noitongquat.png',
    },
    {
      'name': 'Nội tổng quát',
      'image': 'assets/images/Noitongquat.png',
    },
    {
      'name': 'Da liễu',
      'image': 'assets/images/Noithan.png',
    },
    {
      'name': 'Nội tổng quát',
      'image': 'assets/images/Noitongquat.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).brightness == Brightness.light
              ? [
                  Colors.lightBlue.shade100,
                  Colors.white,
                  Colors.lightBlue.shade100,
                ]
              : [
                  Colors.blueGrey.shade900,
                  Colors.black,
                  Colors.blueGrey.shade900,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/mylogo.webp',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Medicare'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Handle settings action
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InputSearch(
                      searchText:
                          'Tìm kiếm bác sĩ, phòng khám, chuyên khoa, dịch vụ',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 140,
                        child: GridView.count(
                          crossAxisCount: 2, // 2 hàng
                          scrollDirection: Axis.horizontal,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: [
                            const ServiceItem(
                              icon: FontAwesomeIcons.hospital,
                              title: "Phòng khám",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.userDoctor,
                              title: "Bác sĩ",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.stethoscope,
                              title: "Chuyên khoa",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.briefcaseMedical,
                              title: "Dịch vụ",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.fileCircleCheck,
                              title: "Tra cứu kết quả",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.calendarCheck,
                              title: "Đặt lịch hẹn",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.fileMedical,
                              title: "Hồ sơ y tế",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.heartPulse,
                              title: "Sức khoẻ",
                            ),
                            const ServiceItem(
                              icon: FontAwesomeIcons.pills,
                              title: "Thuốc men",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const CustomSlider(),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Xem tất cả',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                  width: 4), // khoảng cách giữa chữ và icon
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.blue, size: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Danh sách bác sĩ
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: doctors.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return DoctorCard(
                            name: doctor['name'] as String,
                            specialty: doctor['specialty'] as String,
                            rating: doctor['rating'] as double,
                            avatar: doctor['image'] as String,
                          );
                        },
                      ),
                      // Thêm các bác sĩ vào danh sách
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                              FontAwesomeIcons.hospital,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 6,
                            ), // khoảng cách giữa icon và text
                            Text(
                              'Phòng khám',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Xem tất cả',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                  width: 4), // khoảng cách giữa chữ và icon
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.blue, size: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Danh sách phòng khám
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: clinics.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final clinic = clinics[index];
                          return ClinicCard(
                            name: clinic['name'] as String,
                            address: clinic['address'] as String,
                            rating: clinic['rating'] as double,
                            image: clinic['image'] as String,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Xem tất cả',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                  width: 4), // khoảng cách giữa chữ và icon
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.blue, size: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Danh sách chuyên khoa
                    SizedBox(
                      height: 150,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        // Nếu có nhiều hơn 8 thì chỉ lấy 8 phần tử
                        itemCount: specialties.length,
                        itemBuilder: (context, index) {
                          // Hiển thị card bình thường
                          final specialty = specialties[index];
                          return SpecialtyCard(
                            name: specialty['name'] as String,
                            image: specialty['image'] as String,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
