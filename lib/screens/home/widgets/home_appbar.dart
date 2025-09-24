import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/services/auth_service.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getUser();
    // Viết hàm chào buổi sáng/chiều/tối dựa trên giờ hiện tại
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

    return AppBar(
      title: InkWell(
        onTap: () => context.goNamed('login'),
        child: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (!snapshot.hasData) {
              return const Text('No User');
            }
            final userData = snapshot.data!;
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: userData.avatar != null
                      ? ClipOval(
                          child: Image.network(
                            userData.avatar!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          FontAwesomeIcons.user,
                          color: Colors.blue,
                        ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreetingMessage(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userData.name ?? userData.email ?? 'Đăng ký/Đăng nhập',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
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
                // Xử lý khi nhấn vào biểu tượng thông báo
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
