import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceItem({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          size: 20,
          color: Colors.blue,
        ),
        const SizedBox(height: 6),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true, // Cho phép xuống dòng
            overflow: TextOverflow.visible, // Không cắt chữ
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
