import 'package:flutter/material.dart';
import 'package:frontend_app/screens/home/widgets/home_search.dart';
import 'package:frontend_app/screens/home/widgets/home_slider.dart';
import 'package:frontend_app/screens/home/widgets/home_specialty_list.dart';
import 'package:frontend_app/screens/home/widgets/home_navbar.dart';
import 'package:frontend_app/screens/home/widgets/home_clinic_card.dart';
import 'package:frontend_app/screens/home/widgets/home_doctor_list.dart';
import 'package:frontend_app/screens/home/widgets/home_service_list.dart';

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
                    HomeSearch(
                      searchText:
                          'Tìm kiếm bác sĩ, phòng khám, chuyên khoa, dịch vụ',
                    ),
                    const SizedBox(height: 16),
                    const HomeServiceList(),
                  ],
                ),
              ),
              const HomeSlider(),
              const SizedBox(height: 16),
              const HomeClinicCard(),
              const SizedBox(height: 12),
              const HomeDoctorList(),
              const SizedBox(height: 12),
              const HomeSpecialtyList(),
            ],
          ),
        ),
        bottomNavigationBar: HomeNavbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
