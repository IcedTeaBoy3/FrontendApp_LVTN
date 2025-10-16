import 'package:flutter/material.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/widgets/custom_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:frontend_app/models/account.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final account = authProvider.account;
    _nameController = TextEditingController(text: account?.userName ?? '');
    _emailController = TextEditingController(text: account?.email ?? '');
    _phoneController = TextEditingController(text: account?.phone ?? '');
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickerImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
      Navigator.of(context).pop(); // Đóng bottom sheet sau khi chọn ảnh
    }
  }

  void _handleChangeAvatar(BuildContext context) {
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
                        "Tải ảnh lên",
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
                          context.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Chọn ảnh từ thư viện',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Chọn ảnh từ thư viện thiết bị'),
                onTap: () => _pickerImage(ImageSource.gallery),
                trailing: const FaIcon(FontAwesomeIcons.image, size: 18),
              ),
              ListTile(
                title: const Text(
                  'Chụp ảnh mới',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Sử dụng camera để chụp ảnh mới'),
                onTap: () => _pickerImage(ImageSource.camera),
                trailing: const FaIcon(FontAwesomeIcons.camera, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider _getAvatarImage(Account? account, File? avatarFile) {
    // 1️⃣ Nếu user vừa chọn ảnh mới
    if (avatarFile != null) {
      return FileImage(avatarFile);
    }

    // 2️⃣ Nếu account có avatar trong server
    if (account?.avatar != null && account!.avatar.isNotEmpty) {
      final avatar = account.avatar;
      if (avatar.startsWith('http')) {
        return NetworkImage(avatar);
      } else {
        return NetworkImage('${ApiConfig.backendUrl}$avatar');
      }
    }

    // 3️⃣ Nếu chưa có gì -> ảnh mặc định
    return const AssetImage('assets/images/avatar-default-icon.png');
  }

  void _handleChangeInfo() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final account = authProvider.account;
      if (account == null) return;
      Map<String, dynamic> updatedData = {
        'userName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };
      if (_avatarFile != null) {
        updatedData['avatar'] = await MultipartFile.fromFile(_avatarFile!.path);
      }
      final result = await authProvider.updateAccount(
        accountId: account.accountId,
        updatedData: updatedData,
      );
      if (!mounted) return;
      CustomFlushbar.show(
        context,
        status: result.status,
        message: result.message,
      );
    }
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      final result = await AuthService.changePassword(
        currentPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      if (!mounted) return;
      await CustomFlushbar.show(
        context,
        status: result.status,
        message: result.message,
      );
      if (result.status == 'success') {
        // Xóa các trường mật khẩu sau khi đổi thành công
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        if (!mounted) return;
        final authProvider = context.read<AuthProvider>();
        await authProvider.logout();
        context.goNamed('login');
      }
    }
  }

  Widget buildOldPasswordField() {
    return TextFormField(
      controller: _oldPasswordController,
      obscureText: !_isOldPasswordVisible,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isOldPasswordVisible ? Colors.black87 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isOldPasswordVisible = !_isOldPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return '* Mật khẩu phải có ít nhất 6 ký tự';
        }
        // Biểu thức kiểm tra độ mạnh của mật khẩu
        final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
        );
        if (!regex.hasMatch(value)) {
          return '* Mật khẩu phải gồm ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
        }
        return null;
      },
      onSaved: (value) => _oldPasswordController.text = value ?? '',
    );
  }

  Widget buildNewPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: !_isNewPasswordVisible,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isNewPasswordVisible ? Colors.black87 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isNewPasswordVisible = !_isNewPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return '* Mật khẩu phải có ít nhất 6 ký tự';
        }
        // Biểu thức kiểm tra độ mạnh của mật khẩu
        final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
        );
        if (!regex.hasMatch(value)) {
          return '* Mật khẩu phải gồm ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
        }
        // kiểm tra mật khẩu có khớp không
        if (value != _newPasswordController.text) {
          return '* Mật khẩu không khớp';
        }
        return null;
      },
      onSaved: (value) => _newPasswordController.text = value ?? '',
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isNewPasswordVisible,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isNewPasswordVisible ? Colors.black87 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isNewPasswordVisible = !_isNewPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return '* Mật khẩu phải có ít nhất 6 ký tự';
        }
        if (value != _newPasswordController.text) {
          return '* Mật khẩu không khớp';
        }
        return null;
      },
      onSaved: (value) => _confirmPasswordController.text = value ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final account = authProvider.account;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _getAvatarImage(account, _avatarFile),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              _handleChangeAvatar(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.upload,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      hintText: 'Nhập họ và tên',
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập họ và tên' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Nhập email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        final emailRegex = RegExp(
                            r'^[^@]+@[^@]+\.[^@]+'); // Regex đơn giản kiểm tra định dạng email
                        if (!emailRegex.hasMatch(value)) {
                          return 'Vui lòng nhập email hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      label: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_nameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty &&
                                _phoneController.text.isNotEmpty)
                            ? _handleChangeInfo
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Lưu thay đổi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mật khẩu hiện tại',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildOldPasswordField(),
                  const SizedBox(height: 16),
                  const Text(
                    'Mật khẩu mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildNewPasswordField(),
                  const SizedBox(height: 16),
                  const Text(
                    'Nhập lại mật khẩu mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildConfirmPasswordField(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_newPasswordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              _oldPasswordController.text.isNotEmpty)
                          ? _handleChangePassword
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thay đổi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
