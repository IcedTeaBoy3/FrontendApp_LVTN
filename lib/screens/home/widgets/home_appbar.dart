import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/themes/colors.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    String getGreetingMessage() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Chào buổi sáng!';
      } else if (hour < 18) {
        return 'Chào buổi chiều!';
      } else {
        return 'Chào buổi tối!';
      }
    }

    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;

    return AppBar(
      title: InkWell(
        onTap: () => context.goNamed('login'),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final account = authProvider.account;
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    FontAwesomeIcons.user,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreetingMessage(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      account?.userName?.isNotEmpty == true
                          ? account!.userName
                          : (account?.email ?? 'Đăng ký/Đăng nhập'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 28,
              ),
              onPressed: () {
                if (isAuthenticated) {
                  context.goNamed('notifications');
                } else {
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
              },
            ),
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: const Text(
                  '3', // Số lượng thông báo chưa đọc
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
