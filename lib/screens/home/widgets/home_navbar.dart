import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeNavbar extends StatelessWidget {
  final int _selectedIndex;
  final Function(int) _onItemTapped;

  const HomeNavbar(
      {super.key,
      required int selectedIndex,
      required Function(int) onItemTapped})
      : _selectedIndex = selectedIndex,
        _onItemTapped = onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Hồ sơ',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.lightBlueAccent,
                      Colors.white,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(100),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.robot,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              label: 'Trợ lý',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy),
              label: 'Phiếu khám',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tài khoản',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
