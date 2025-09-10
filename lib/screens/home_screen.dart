import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend_app/widgets/input_search.dart';
import 'package:frontend_app/widgets/service_item.dart';
import 'package:frontend_app/widgets/custom_navbar.dart';
import 'package:frontend_app/widgets/custom_slider.dart';
import 'package:frontend_app/widgets/clinic_card.dart';

import 'package:frontend_app/widgets/specialty_list.dart';
import 'package:frontend_app/widgets/doctor_list.dart';

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
    },
    {
      'name': 'Dr. Jane Smith',
      'specialty': 'Nhi khoa',
      'rating': 4.8,
    },
    {
      'name': 'Dr. Alex Lee',
      'specialty': 'Da liễu',
      'rating': 4.6,
    },
  ];
  final clinics = [
    {
      'name': 'Phòng khám đa khoa',
      'address': '123 Đường ABC, Quận 1',
      'rating': 4.5,
    },
    {
      'name': 'Phòng khám chuyên khoa',
      'address': '456 Đường DEF, Quận 2',
      'rating': 4.8,
    },
    {
      'name': 'Phòng khám nha khoa',
      'address': '789 Đường GHI, Quận 3',
      'rating': 4.6,
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
              const ClinicCard(),
              const SizedBox(height: 12),
              const DoctorList(),
              const SizedBox(height: 12),
              const SpecialtyList(),
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
