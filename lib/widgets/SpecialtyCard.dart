import 'package:flutter/material.dart';

class SpecialtyCard extends StatelessWidget {
  final String name;
  final String image;

  const SpecialtyCard({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.15,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // 👈 cho phép 2 dòng
            ),
          ),
        ],
      ),
    );
  }
}
