import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:flutter/services.dart';
import 'package:frontend_app/providers/ethnic_provider.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:provider/provider.dart';

void handleShowDetailPatientProfile(
  BuildContext context,
  Patientprofile patientProfile,
) {
  context.read<EthnicityProvider>().loadEthnicGroups();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40, // đảm bảo có cùng chiều cao với AppBar mini
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        "Thông tin bệnh nhân",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        padding: EdgeInsets.zero, // bỏ padding mặc định
                        constraints:
                            const BoxConstraints(), // bỏ constraint thừa
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Mã bệnh nhân:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.patientProfileCode,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: patientProfile.patientProfileId),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.blueAccent,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Đã sao chép vào bộ nhớ tạm",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Mã bảo hiểm y tế:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.insuranceCode ?? 'Chưa cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: patientProfile.insuranceCode),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior
                            .floating, // nổi lên, không dính sát đáy
                        backgroundColor: Colors.blueAccent,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Đã sao chép vào bộ nhớ tạm",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Mã căn cước công dân:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.idCard ?? 'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: patientProfile.idCard),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior
                            .floating, // nổi lên, không dính sát đáy
                        backgroundColor: Colors.blueAccent,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Đã sao chép vào bộ nhớ tạm",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Họ và tên:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.person.fullName ?? 'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Số điện thoại:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.person.phone ?? 'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Ngày sinh:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  formatDate(patientProfile.person.dateOfBirth) ??
                      'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Giới tính:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  convertGenderBack(patientProfile.person.gender) ??
                      'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Địa chỉ:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  patientProfile.person.address ?? 'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Dân tộc:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  context
                          .watch<EthnicityProvider>()
                          .findByCodeOrName(patientProfile.person.ethnic ?? '')
                          ?.name ??
                      'Chưa cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Nghề nghiệp:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
