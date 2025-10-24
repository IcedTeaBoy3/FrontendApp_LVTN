import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/screens/patientProfile/widgets/card_patientprofile.dart';
import 'package:frontend_app/providers/medicalresult_provider.dart';

void openModalPatientProfile(BuildContext context) {
  final patientProfiles =
      context.read<PatientprofileProvider>().patientprofiles;
  final isAuthenticated = context.read<AuthProvider>().isAuthenticated;
  showModalBottomSheet<void>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    context: context,
    builder: (BuildContext ctx) {
      final theme = Theme.of(ctx);
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 8,
          right: 8,
          top: 12,
        ),
        child: isAuthenticated
            ? patientProfiles.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Chọn hồ sơ bệnh nhân để xem kết quả',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: patientProfiles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final profile = patientProfiles[index];
                            return CardPatientProfile(
                              patientprofile: profile,
                              selected: profile.patientProfileId ==
                                  context
                                      .read<MedicalresultProvider>()
                                      .selectedPatientProfile
                                      ?.patientProfileId,
                              onTap: () => {
                                context
                                    .read<MedicalresultProvider>()
                                    .selectedPatientProfile = profile,
                                context.goNamed('medicalResult'),
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Không có hồ sơ bệnh nhân nào.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Vui lòng đăng nhập để xem hồ sơ bệnh nhân.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
      );
    },
  );
}
