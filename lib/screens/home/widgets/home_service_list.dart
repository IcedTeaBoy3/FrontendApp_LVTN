import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/widgets/service_item.dart';

class HomeServiceList extends StatelessWidget {
  const HomeServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
