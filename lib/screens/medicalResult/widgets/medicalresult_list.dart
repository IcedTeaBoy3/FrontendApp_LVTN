import 'package:flutter/material.dart';
import 'package:frontend_app/providers/medicalresult_provider.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import './card_medicalresult.dart';

class MedicalResultList extends StatelessWidget {
  const MedicalResultList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: Consumer<MedicalresultProvider>(
              builder: (context, medicalresultProvider, child) {
                if (medicalresultProvider.isLoading) {
                  return CustomLoading();
                } else if (medicalresultProvider.medicalresults.isEmpty) {
                  return const Center(
                    child: Text('Không có kết quả khám bệnh nào.'),
                  );
                } else {
                  return ListView.separated(
                    itemCount: medicalresultProvider.medicalresults.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final medicalResult =
                          medicalresultProvider.medicalresults[index];
                      return CardMedicalResult(
                        medicalResult: medicalResult,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
