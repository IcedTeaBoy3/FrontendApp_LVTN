import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class PatientProfileAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBackToHome;
  const PatientProfileAppbar({super.key, required this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBackToHome,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      title: Center(
        child: const Text(
          'Hồ sơ bệnh nhân',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
      showDragHandle: true, // <-- cái này tạo luôn thanh xám nhỏ ở ngoài
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
