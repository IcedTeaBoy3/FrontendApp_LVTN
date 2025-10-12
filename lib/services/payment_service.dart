import 'api_client.dart';
import '../models/payment.dart';

class PaymentService {
  static Future<String> createQRCode(
      double amount, String paymentId, String? description) async {
    try {
      final response = await ApiClient.dio.post(
        '/payment/create-qr-code',
        data: {
          'amount': amount,
          'paymentId': paymentId,
          'description': description,
        },
      );
      if (response.statusCode == 201) {
        final qrCodeUrl = response.data['data'];
        return qrCodeUrl;
      } else {
        throw Exception('Failed to create QR code');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Payment> getPaymentStatus(String paymentId) async {
    try {
      final response = await ApiClient.dio.get(
        '/payment/payment-status/$paymentId',
      );
      if (response.statusCode == 200) {
        final paymentData = response.data['data'];
        return Payment.fromJson(paymentData);
      } else {
        throw Exception('Failed to fetch payment status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
