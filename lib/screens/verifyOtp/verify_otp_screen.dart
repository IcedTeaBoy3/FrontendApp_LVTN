import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() async {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text;
      setState(() {
        _isLoading = true;
      });
      // Gọi API xác thực OTP ở đây
      final result = await AuthService.verifyOtp(
        email: widget.email,
        otp: otp,
      );
      if (!mounted) return;
      if (result.status == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
        context.goNamed('login', extra: widget.email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleResendOtp() async {
    // Xử lý gửi lại OTP
    print('Gửi lại OTP cho email: ${widget.email}');
    final result = await AuthService.resendOtp(email: widget.email);
    setState(() {
      _isLoading = true;
    });
    if (!mounted) return;
    if (result.status == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Xác thực OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/Email.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              const Text(
                'Mã OTP đã được gửi đến email của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 8.0,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Nhập mã OTP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
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
                      return '* Vui lòng nhập mã OTP';
                    }
                    if (value.length < 6) {
                      return '* Mã OTP phải có 6 chữ số';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.blueAccent,
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
                      : const Text(
                          'Xác thực',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: _handleResendOtp,
                      child: const Text(
                        'Gửi lại mã OTP',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
