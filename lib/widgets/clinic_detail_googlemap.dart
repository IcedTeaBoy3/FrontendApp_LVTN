import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClinicDetailGooglemap extends StatelessWidget {
  final String address;
  const ClinicDetailGooglemap({super.key, required this.address});

  Future<void> _openMap() async {
    final Uri googleUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");

    if (!await launchUrl(googleUrl, mode: LaunchMode.externalApplication)) {
      throw Exception("Không mở được Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: const AssetImage('assets/images/bg-map.webp'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.grey.withAlpha(150),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                address,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis, // để text không tràn
                maxLines: 2, // giới hạn số dòng
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _openMap,
              icon: const FaIcon(
                FontAwesomeIcons.diamondTurnRight,
                color: Colors.white,
              ),
              label: const Text("Mở bản đồ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(90, 36),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
