import 'package:flutter/material.dart';
import 'package:frontend_app/screens/home/widgets/home_navbar.dart';
import 'package:frontend_app/screens/home/widgets/home_appbar.dart';

import 'package:frontend_app/screens/home/home_page_content.dart';
import 'package:frontend_app/screens/patientProfile/patient_profile_screen.dart';
import 'package:frontend_app/screens/account/account_screen.dart';
import 'package:frontend_app/screens/patientProfile/widgets/patient_profile_appbar.dart';
import 'package:frontend_app/screens/appointment/appointment_screen.dart';
import 'package:frontend_app/screens/appointment/widgets/appointment_appbar.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages.addAll([
      const HomePageContent(),
      PatientProfileScreen(), // truyền callback
      const AccountScreen(),
      AppointmentScreen(), // có thể dùng lại
      AccountScreen(onBackToHome: _onItemTapped),
    ]);
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget? _buildAppBar(int index) {
    switch (index) {
      case 0:
        return const HomeAppbar();
      case 1:
        return PatientProfileAppbar(onBackToHome: () => _onItemTapped(0));
      case 2:
        return null; // Account không cần appbar
      case 3:
        return AppointmentAppbar(onBackToHome: () => _onItemTapped(0));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(_selectedIndex),
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
