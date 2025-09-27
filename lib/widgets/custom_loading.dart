import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomLoading({
    super.key,
    this.size = 40,
    this.color = Colors.blue,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
