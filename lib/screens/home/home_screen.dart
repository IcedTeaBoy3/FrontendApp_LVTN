import 'package:flutter/material.dart';
import 'package:frontend_app/screens/home/widgets/home_navbar.dart';
import 'package:frontend_app/screens/home/widgets/home_appbar.dart';

import 'package:frontend_app/screens/home/home_page_content.dart';
import 'package:frontend_app/screens/patientProfile/patient_profile_screen.dart';
import 'package:frontend_app/screens/patientProfile/widgets/patient_profile_appbar.dart';

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

  final List<Widget> _pages = [
    const HomePageContent(),
    const PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<PreferredSizeWidget?> _appBars = [
      const HomeAppbar(),
      PatientProfileAppbar(onBackToHome: () => _onItemTapped(0)),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _appBars[_selectedIndex],
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: HomeNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
