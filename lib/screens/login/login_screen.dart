import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/widgets/message_dialog.dart';

class LoginScreen extends StatefulWidget {
  final String? email;
  const LoginScreen({super.key, this.email});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint("Email nhận: ${widget.email}");
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await context
          .read<AuthProvider>()
          .login(email: email, password: password);

      if (!mounted) return; // kiểm tra ngay sau await

      if (response.status == 'success') {
        LottieDialog.show(
          context,
          animationPath: "assets/animations/Success.json",
          type: response.status,
          message: response.message,
          duration: 2,
          onClosed: () {
            if (mounted) {
              context.goNamed('home');
            }
          },
        );
      } else {
        LottieDialog.show(
          context,
          animationPath: "assets/animations/Error.json",
          type: response.status,
          message: response.message,
          duration: 2,
        );
      }
    }
  }

  Future<void> handleGoogleSignIn() async {
    final result = await context.read<AuthProvider>().loginWithGoogle();
    if (!mounted) return;
    if (result.status == 'success') {
      LottieDialog.show(
        context,
        animationPath: "assets/animations/Success.json",
        type: result.status,
        message: result.message,
        duration: 2,
        onClosed: () {
          context.goNamed('home'); // navigate sau khi dialog đóng
        },
      );
    } else {
      LottieDialog.show(
        context,
        animationPath: "assets/animations/Error.json",
        type: result.status,
        message: result.message,
        duration: 2,
      );
    }
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(Icons.email),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
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
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return '* Vui lòng nhập địa chỉ email hợp lệ';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
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
        return null;
      },
    );
  }

  Widget buildRegisterLink() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.goNamed('register'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
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

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
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
        child: context.watch<AuthProvider>().isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Đăng nhập',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
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
                            buildEmailField(),
                            const SizedBox(
                              height: 12.0,
                            ),
                            buildPasswordField(),
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
                                    onPressed: handleGoogleSignIn,
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
                    buildRegisterLink(),
                    const SizedBox(
                      height: 6.0,
                    ),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
