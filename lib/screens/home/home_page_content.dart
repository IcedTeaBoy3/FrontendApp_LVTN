import 'package:flutter/material.dart';
import 'package:frontend_app/screens/home/widgets/home_search.dart';
import 'package:frontend_app/screens/home/widgets/home_slider.dart';
import 'package:frontend_app/screens/home/widgets/home_specialty_list.dart';

import 'package:frontend_app/screens/home/widgets/home_clinic_card.dart';
import 'package:frontend_app/screens/home/widgets/home_doctor_list.dart';
import 'package:frontend_app/screens/home/widgets/home_service_list.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

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
      child: SingleChildScrollView(
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
    );
  }
}
