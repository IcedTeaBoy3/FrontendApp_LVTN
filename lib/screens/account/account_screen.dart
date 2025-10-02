import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/providers/appointment_provider.dart';

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
        context.read<PatientprofileProvider>().clear();
        context.read<AppointmentProvider>().reset();
        context.goNamed('login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final account = authProvider.account;
    final isAuthenticated = authProvider.isAuthenticated;
    return Column(
      children: [
        isAuthenticated
            ? Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        account?.userName.isNotEmpty == true
                            ? account!.userName
                            : (account?.email ?? 'Đăng ký/Đăng nhập'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryBlue,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: AppColors.white),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Đăng xuất"),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12.0),
                  margin: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
              ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
          ),
        )
      ],
    );
  }
}
