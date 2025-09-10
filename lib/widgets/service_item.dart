import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceItem({
    super.key,
    required this.icon,
    required this.title,
  });

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
            style: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                : Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ),
      ],
    );
  }
}
