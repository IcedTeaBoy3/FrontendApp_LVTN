import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  void _showLogoutDialog(BuildContext context) {
    ConfirmDialog.show(
      context,
      title: "Xác nhận đăng xuất",
      content: "Bạn có chắc chắn muốn đăng xuất không?",
      cancelText: "Hủy",
      confirmText: "Đăng xuất",
      confirmColor: Colors.red,
      onConfirm: () {
        context.read<AuthProvider>().logout();
        context.goNamed('login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn chưa có tài khoản?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Đăng ký hoặc đăng nhập để đặt lịch khám ngay',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.goNamed('login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(Icons.person, size: 20, color: Colors.white),
                        label: Text(
                          'Đăng ký / Đăng nhập',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.all(12.0),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Bạn là bác sĩ?',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       Text(
                //         'Đăng ký để quản lý lịch khám và hồ sơ bệnh án',
                //         style: TextStyle(
                //           fontSize: 16,
                //           color: Colors.black87,
                //         ),
                //       ),
                //       SizedBox(
                //         height: 8,
                //       ),
                //       ElevatedButton.icon(
                //         onPressed: () {
                //           // Handle doctor registration
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: AppColors.primaryBlue,
                //           foregroundColor: Colors.white,
                //           padding: EdgeInsets.symmetric(
                //             horizontal: 10,
                //           ),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //         ),
                //         icon: Icon(Icons.medical_services,
                //             size: 20, color: Colors.white),
                //         label: Text(
                //           'Đăng ký làm bác sĩ',
                //           style: TextStyle(fontSize: 15),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.medical_information,
                          color: AppColors.primaryBlue,
                        ),
                        title: Text('Hồ sơ y tế'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        ),
                        onTap: () {
                          // Handle settings navigation
                        },
                      ),
                      Divider(
                        indent: 12,
                        endIndent: 12,
                        color: Colors.grey[200],
                        thickness: 1,
                      ),
                      ListTile(
                        style: ListTileStyle.list,
                        leading: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        title: Text('Danh sách yêu thích'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        ),
                        onTap: () {
                          // Handle settings navigation
                        },
                      ),
                      Divider(
                        indent: 12,
                        endIndent: 12,
                        color: Colors.grey[200],
                        thickness: 1,
                      ),
                      ListTile(
                        style: ListTileStyle.list,
                        leading: Icon(
                          Icons.info,
                          color: Colors.green,
                        ),
                        title: Text('Điều khoản và chính sách'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        ),
                        onTap: () {
                          // Handle settings navigation
                        },
                      ),
                      Divider(
                        indent: 12,
                        endIndent: 12,
                        color: Colors.grey[200],
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.black),
                        title: Text('Cài đặt'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        ),
                        onTap: () {
                          // Handle settings navigation
                        },
                      ),
                      Divider(
                        indent: 12,
                        endIndent: 12,
                        color: Colors.grey[200],
                        thickness: 1,
                      ),
                      isAuthenticated
                          ? ListTile(
                              leading: Icon(Icons.logout, color: Colors.black),
                              title: Text('Đăng xuất'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black45,
                              ),
                              onTap: () => _showLogoutDialog(context),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
