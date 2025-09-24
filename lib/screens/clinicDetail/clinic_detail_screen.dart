import 'package:flutter/material.dart';
import 'package:frontend_app/models/clinic.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:frontend_app/widgets/clinic_detail_googlemap.dart';
import 'package:frontend_app/screens/clinicDetail/widgets/clinic_detail_workhours.dart';
import 'package:frontend_app/screens/clinicDetail/widgets/clinic_detail_description.dart';
import 'package:frontend_app/screens/clinicDetail/widgets/clinic_detail_specialty.dart';
import 'package:frontend_app/screens/clinicDetail/widgets/clinic_detail_contact.dart';

class ClinicDetailScreen extends StatefulWidget {
  final Clinic clinic;
  const ClinicDetailScreen({super.key, required this.clinic});

  @override
  State<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends State<ClinicDetailScreen> {
  final _controller = CarouselSliderController();
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    final clinic = widget.clinic;
    final imageClinics =
        clinic.images.isNotEmpty ? clinic.images.skip(1).toList() : [];
    // final thumbnailClinic =
    //     clinic.images.isNotEmpty ? clinic.images.first : null;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade200
          : Colors.grey.shade800,
      appBar: AppBar(
        title: Text(
          'Thông tin phòng khám',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  CarouselSlider(
                    items: imageClinics
                        .map(
                          (image) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '${ApiConfig.backendUrl}$image',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() => _activeIndex = index);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.of(context).size.width * 0.5 -
                        (imageClinics.length * 10),
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activeIndex,
                      count: imageClinics.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blueAccent,
                        dotColor: Colors.white,
                      ),
                      onDotClicked: (index) => _controller.animateToPage(index),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ClinicDetailGooglemap(address: clinic.address),
            const SizedBox(height: 4),
            ClinicDetailWorkhours(workHours: clinic.workHours),
            const SizedBox(height: 4),
            ClinicDetailDescription(description: clinic.description),
            const SizedBox(height: 4),
            ClinicDetailSpecialty(),
            const SizedBox(height: 4),
            ClinicDetailContact(
              email: clinic.email,
              website: clinic.website,
              phone: clinic.phone,
            ),
          ],
        ),
      ),
    );
  }
}
