import 'package:flutter/material.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/need_login.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/screens/patientProfile/widgets/card_patientprofile.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch patient profiles when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientprofileProvider>().fetchPatientprofiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return isAuthenticated
        ? Column(
            children: [
              Consumer<PatientprofileProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return CustomLoading(
                      size: 50,
                      color: AppColors.primaryBlue,
                      strokeWidth: 5.0,
                    );
                  } else if (provider.patientprofiles.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(8.0),
                            height: 80,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Bạn chưa có hồ sơ bệnh nhân. Vui lòng tạo mới hồ sơ để được đặt khám.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tạo hồ sơ bệnh nhân',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Bạn được phép tạo tối đa 5 hồ sơ bệnh nhân (cá nhân và người thân).',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        context.goNamed('addPatientProfile'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondaryBlue,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.userPlus,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    label: Text(
                                      'Chưa từng khám đăng ký mới'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.white,
                                      foregroundColor: AppColors.secondaryBlue,
                                      side: BorderSide(
                                        color: AppColors.secondaryBlue,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.qrcode,
                                      size: 18,
                                      color: AppColors.secondaryBlue,
                                    ),
                                    label: Text(
                                      'Quét mã QR CCCD'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.patientprofiles.length,
                            itemBuilder: (context, index) {
                              final profile = provider.patientprofiles[index];
                              return CardPatientProfile(
                                  patientprofile: profile);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          )
        : const NeedLogin();
  }
}
