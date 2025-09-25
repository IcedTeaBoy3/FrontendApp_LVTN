// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // Gửi OTP đến số điện thoại
//   Future<void> sendOtp(
//     String phoneNumber, {
//     required Function(String, int?) codeSent,
//     required Function(FirebaseAuthException) verificationFailed,
//   }) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Tự động xác thực nếu thiết bị hỗ trợ
//         await _auth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         verificationFailed(e);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         codeSent(verificationId, resendToken);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Tự động hủy nếu quá thời gian chờ
//       },
//     );
//   }

//   // Xác thực OTP và đăng nhập
//   Future<UserCredential?> verifyOtp(
//       String verificationId, String smsCode) async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//       return await _auth.signInWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       // Xử lý lỗi khi xác thực OTP
//       debugPrint('Lỗi khi xác thực OTP: ${e.message}');
//       return null;
//     }
//   }

//   // Lấy thông tin người dùng hiện tại
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }
