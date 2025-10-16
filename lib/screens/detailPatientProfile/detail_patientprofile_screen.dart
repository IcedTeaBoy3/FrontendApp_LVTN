import 'package:frontend_app/models/patientprofile.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/providers/ethnic_provider.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailPatientprofileScreen extends StatefulWidget {
  final Patientprofile patientProfile;
  const DetailPatientprofileScreen({super.key, required this.patientProfile});

  @override
  State<DetailPatientprofileScreen> createState() =>
      _DetailPatientprofileScreenState();
}

class _DetailPatientprofileScreenState
    extends State<DetailPatientprofileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EthnicityProvider>().loadEthnicGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chi tiết hồ sơ bệnh nhân',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person, color: Colors.blue),
                    label: Text(
                      'Thông tin cá nhân',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.goNamed(
                      'addEditPatientProfile',
                      extra: widget.patientProfile,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cập nhật'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'thẻ căn cước công dân'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Mã bệnh nhân:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  widget.patientProfile.patientProfileCode,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                          text: widget.patientProfile.patientProfileId),
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
                  'Mã bảo hiểm y tế:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  widget.patientProfile.insuranceCode ?? 'Chưa cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.patientProfile.insuranceCode),
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
                  widget.patientProfile.idCard ?? 'Chua cập nhật',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.patientProfile.idCard),
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
                  widget.patientProfile.person.fullName ?? 'Chua cập nhật',
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
                  widget.patientProfile.person.phone ?? 'Chua cập nhật',
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
                  formatDate(widget.patientProfile.person.dateOfBirth) ??
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
                  convertGenderBack(widget.patientProfile.person.gender) ??
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
                  widget.patientProfile.person.address ?? 'Chua cập nhật',
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
                          .read<EthnicityProvider>()
                          .findByCodeOrName(
                              widget.patientProfile.person.ethnic ??
                                  '') // tìm dân tộc theo code hoặc name
                          ?.name ??
                      'Chua cập nhật',
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
      ),
    );
  }
}
