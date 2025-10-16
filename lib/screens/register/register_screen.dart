import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Xử lý đăng ký tài khoản tại đây
      setState(() {
        _isLoading = true;
      });
      final response = await AuthService.register(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      await CustomFlushbar.show(
        context,
        status: response.status,
        message: response.message,
      );
      if (response.status == 'success') {
        if (!mounted) return;
        context.goNamed(
          'verifyOtp',
          extra: _emailController.text,
          queryParameters: {'type': 'register'},
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
                              'Nhập vào thông tin đăng ký của bạn',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            _buildEmailField(),
                            const SizedBox(
                              height: 16.0,
                            ),
                            _buildPasswordField(),
                            const SizedBox(
                              height: 16.0,
                            ),
                            _buildConfirmPasswordField(),
                            const SizedBox(
                              height: 24.0,
                            ),
                            const Text(
                              'Bằng việc tiếp tục, bạn đã đồng ý với các Điều khoản, điều kiện sử dụng của chúng tôi.',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildContinueButton(),
                    const SizedBox(
                      height: 6.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.black, // Màu chữ khi nhập
        fontSize: 16,
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return '* Vui lòng nhập địa chỉ email hợp lệ';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        // --- Phần đã được sửa đổi ---
        prefixIcon: const Icon(Icons.email),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(
        color: Colors.black, // Màu chữ khi nhập
        fontSize: 16,
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
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
        if (value != _confirmPasswordController.text) {
          return '* Mật khẩu không khớp';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        // --- Phần đã được sửa đổi ---
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isPasswordVisible ? Colors.black87 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      style: const TextStyle(
        color: Colors.black, // Màu chữ khi nhập
        fontSize: 16,
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return '* Mật khẩu phải có ít nhất 6 ký tự';
        }
        if (value != _passwordController.text) {
          return '* Mật khẩu không khớp';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Nhập lại mật khẩu',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        // --- Phần đã được sửa đổi ---
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _isPasswordVisible ? Colors.black87 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSubmit, // disable khi đang loading
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryBlue, // Màu nền xanh
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text('Tiếp tục'),
      ),
    );
  }
}
