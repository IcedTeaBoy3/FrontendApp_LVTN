import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PatientProfileAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBackToHome;
  const PatientProfileAppbar({super.key, required this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.read<AuthProvider>().isAuthenticated;
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: onBackToHome,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      title: const Text(
        'Hồ sơ bệnh nhân',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.userPlus,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            if (!isAuthenticated) {
              ConfirmDialog.show(
                context,
                title: 'Xác nhận',
                content: 'Bạn cần đăng nhập để thực hiện hành động này.',
                confirmText: 'Đăng nhập',
                cancelText: 'Hủy',
                confirmColor: AppColors.primaryBlue,
                onConfirm: () {
                  context.goNamed('login');
                },
              );
              return;
            }
            _showOptionsDialog(context);
          },
        )
      ],
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40, // đảm bảo có cùng chiều cao với AppBar mini
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        "Tạo hồ sơ mới",
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
              const Divider(),
              ListTile(
                title: const Text(
                  'Nhập thông tin bệnh nhân',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Tạo hồ sơ theo thông tin hành chính'),
                onTap: () {
                  context.goNamed('addPatientProfile');
                },
                trailing: const FaIcon(FontAwesomeIcons.pen, size: 18),
              ),
              ListTile(
                title: const Text(
                  'Tạo theo mã CCCD',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Quét mã CCCD để tạo hồ sơ'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Thêm logic để chuyển đổi bệnh nhân
                },
                trailing: const FaIcon(FontAwesomeIcons.qrcode, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
