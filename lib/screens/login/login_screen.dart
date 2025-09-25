import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _loginData = {
    'phone': '',
    'password': '',
  };
  bool _isPasswordVisible = false;

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle login action
    }
  }

  void _handleGoogleSignIn() async {
    final success = await context.read<AuthProvider>().loginWithGoogle();
    if (success) {
      if (context.mounted) {
        context.goNamed('home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập Google thành công!'),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập Google thất bại. Vui lòng thử lại.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Các dấu cộng rải rác
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.white,
                AppColors.white,
                AppColors.primaryBlue,
              ],
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: 40,
          child: Opacity(
            opacity: 0.5,
            child: FaIcon(
              FontAwesomeIcons.plus, // dấu cộng
              size: 50,
              color: AppColors.secondaryBlue,
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 100,
          child: Opacity(
            opacity: 0.5,
            child: FaIcon(
              FontAwesomeIcons.plus, // dấu cộng
              size: 25,
              color: AppColors.secondaryBlue,
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: Opacity(
            opacity: 0.3,
            child: FaIcon(
              FontAwesomeIcons.plus, // dấu cộng
              size: 25,
              color: AppColors.secondaryBlue,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 60,
          child: Opacity(
            opacity: 0.3,
            child: FaIcon(
              FontAwesomeIcons.plus, // dấu cộng
              size: 25,
              color: AppColors.secondaryBlue,
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 80,
          child: Opacity(
            opacity: 0.3,
            child: FaIcon(
              FontAwesomeIcons.plus, // dấu cộng
              size: 30,
              color: AppColors.secondaryBlue,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 40,
          child: Opacity(
            opacity: 0.4,
            child: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 60,
          child: Opacity(
            opacity: 0.4,
            child: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              color: Colors.black,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Medicare',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Thông tin đăng nhập',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            _buildPhoneNumberField(),
                            const SizedBox(
                              height: 12.0,
                            ),
                            _buildPasswordField(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle forgot password action
                                },
                                child: const Text(
                                  'Quên mật khẩu?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Hoặc tiếp tục với google
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Divider(
                                  color: Colors.grey.withAlpha(50),
                                  thickness: 1,
                                ),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: const Text(
                                    'Hoặc tiếp tục với',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.withAlpha(50),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(50),
                                        blurRadius: 6,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(8),
                                    icon: FaIcon(
                                      FontAwesomeIcons.google,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                    onPressed: _handleGoogleSignIn,
                                  ),
                                ),
                                const SizedBox(width: 25),

                                // Facebook
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.withAlpha(50),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(30),
                                        blurRadius: 6,
                                        spreadRadius: 3,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(8),
                                    icon: FaIcon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blue,
                                      size: 34,
                                    ),
                                    onPressed: () {
                                      // Handle Facebook sign-in
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    _buildRegisterLink(),
                    const SizedBox(
                      height: 6.0,
                    ),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black54, // màu chữ khi nhập
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        hintText: 'Số điện thoại',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.phone),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ), // giảm padding
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
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
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        return null;
      },
      onSaved: (value) {
        _loginData['phone'] = value!;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      style: const TextStyle(
        color: Colors.black54, // màu chữ khi nhập
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
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isPasswordVisible ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
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
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        return null;
      },
      onSaved: (newValue) => _loginData['password'] = newValue!,
    );
  }

  Widget _buildRegisterLink() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.goNamed('register'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black54,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text(
          'Đăng ký tài khoản',
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Đăng nhập'),
      ),
    );
  }
}
