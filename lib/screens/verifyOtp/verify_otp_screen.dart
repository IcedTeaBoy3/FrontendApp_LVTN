import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'dart:async';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String type; // "register" hoặc "resetPassword"
  const VerifyOtpScreen({super.key, required this.email, required this.type});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isExpired = false;
  int _secondsRemaining = 300; // 5 phút = 300 giây
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // hủy timer cũ nếu có
    setState(() {
      _secondsRemaining = 300; // reset về 5 phút
      _isExpired = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isExpired = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
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
        type: widget.type,
      );
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      await CustomFlushbar.show(
        context,
        status: result.status,
        message: result.message,
      );
      if (result.status == 'success') {
        // ✅ Xác thực OTP thành công
        if (widget.type == 'register') {
          // Chuyển đến màn hình đăng nhập
          if (!mounted) return;
          context.goNamed(
            'login',
            extra: widget.email,
          );
        } else if (widget.type == 'forgot_password') {
          // Chuyển đến màn hình đặt lại mật khẩu
          if (!mounted) return;
          context.goNamed(
            'resetPassword',
            extra: widget.email,
          );
        }
      }
    }
  }

  void _handleResendOtp() async {
    if (_isLoading) return; // tránh bấm liên tục
    setState(() => _isLoading = true);
    try {
      print('Gửi lại OTP cho email: ${widget.email}');
      final result = await AuthService.resendOtp(
        email: widget.email,
        type: widget.type,
      );
      if (!mounted) return;
      await CustomFlushbar.show(
        context,
        status: result.status,
        message: result.message,
      );
      if (result.status == 'success') {
        // ✅ Reset trạng thái
        setState(() {
          _isExpired = false;
          _secondsRemaining = 300; // 5 phút
        });
        _startTimer(); // ✅ Bắt đầu lại đếm ngược
      }
    } catch (e) {
      if (mounted) {
        await CustomFlushbar.show(
          context,
          status: 'error',
          message: 'Lỗi khi gửi lại OTP: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Xác thực email',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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
                //
                const SizedBox(height: 8),
                // Hiển thị đếm ngược
                Text(
                  _isExpired
                      ? 'Mã OTP đã hết hạn'
                      : 'Mã OTP hết hạn sau ${_formatTime(_secondsRemaining)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isExpired ? Colors.red : Colors.black87,
                  ),
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
                // 🔁 Gửi lại OTP (chỉ hiển thị khi hết hạn và không đang loading)
                if (!_isLoading && _isExpired)
                  TextButton(
                    onPressed: _handleResendOtp,
                    child: Text(
                      'Gửi lại mã OTP',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: (_isExpired || _isLoading) ? null : _handleVerifyOtp,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
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
    );
  }
}
