import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int activeIndex = 0;

  final controller = CarouselSliderController();

  final List<String> images = [
    "assets/images/banner_1.webp",
    "assets/images/banner_2.webp",
    "assets/images/banner_3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: images.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 4,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
