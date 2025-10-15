import 'package:flutter/material.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SpecialtyCard extends StatelessWidget {
  final String name;
  final String? image; // cho phép null luôn
  final String specialtyId;

  const SpecialtyCard({
    super.key,
    required this.name,
    required this.specialtyId,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = (image != null && image!.isNotEmpty)
        ? ApiConfig.backendUrl + image!
        : null;

    return GestureDetector(
      onTap: () {
        context.read<DoctorProvider>().setSelectedSpecialty(name);
        context.goNamed('search');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.lightBlue.shade50,
            radius: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 40, color: Colors.grey);
                      },
                    )
                  : const Icon(Icons.image_not_supported,
                      size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
