import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/specialty_provider.dart';
import 'package:frontend_app/widgets/specialty_card.dart';

void openSpecialtySheet(BuildContext context) {
  final specialtyProvider = context.read<SpecialtyProvider>();
  final specialties = specialtyProvider.specialties;
  final total = specialties.length;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tất cả chuyên khoa",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                ),
                itemCount: total,
                itemBuilder: (context, index) {
                  final specialty = specialties[index];
                  return SpecialtyCard(
                    specialtyId: specialty.specialtyId,
                    name: specialty.name,
                    image: specialty.image,
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
