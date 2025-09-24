import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FirebaseService _authService = FirebaseService();
  bool _isLoading = false;
  final Map<String, String> _registerData = {
    'phone': '',
  };

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      // Bắt đầu quá trình gửi OTP
      await _authService.sendOtp(
        '+84${_registerData['phone']}', // Thêm mã quốc gia
        codeSent: (String verificationId, int? resendToken) {
          // TODO: Chuyển hướng đến màn hình xác thực OTP
          // Truyền verificationId để sử dụng khi xác thực OTP
          context.pushNamed('verifyOtp', extra: {
            'verificationId': verificationId,
            'phone': _registerData['phone'],
          });
        },
        verificationFailed: (e) {
          // Hiển thị lỗi cho người dùng
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
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
                              'Nhập vào số điện thoại đăng ký',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            _buildPhoneNumberField(),
                            const SizedBox(
                              height: 16.0,
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
                    _buildRegisterLink(),
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

  // lib/screens/login_screen.dart

  Widget _buildPhoneNumberField() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black, // Màu chữ khi nhập
        fontSize: 16,
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 9) {
          return 'Vui lòng nhập số điện thoại';
        }
        return null;
      },
      onChanged: (value) => {
        setState(() {
          _isButtonEnabled = RegExp(r'^[0-9]{9,10}$').hasMatch(value);
        })
      },
      onSaved: (value) {
        _registerData['phone'] = value!;
      },
      decoration: InputDecoration(
        hintText: 'Số điện thoại',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        // --- Phần đã được sửa đổi ---
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.phone,
              color: Colors.black87,
            ),
            label: Text(
              '+84',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        // --- Kết thúc phần sửa đổi ---
        filled: true,
        fillColor: Colors.grey[200], // Thêm màu nền để dễ nhìn hơn
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
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

  Widget _buildRegisterLink() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : _isButtonEnabled
                ? () {
                    setState(() {
                      _isLoading = true;
                    });
                    _onSubmit();
                  }
                : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF1976D2), // Màu nền xanh
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          side: BorderSide(
            color: Colors.black45,
            width: 1.0,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : const Text(
                'Tiếp tục',
              ),
      ),
    );
  }
}
