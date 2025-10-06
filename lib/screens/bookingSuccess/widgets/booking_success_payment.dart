import 'package:flutter/material.dart';
import 'package:frontend_app/models/payment.dart';
import 'package:frontend_app/utils/currency_utils.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/utils/method_utils.dart';
import 'package:frontend_app/utils/paymenttype_utils.dart';

class BookingSuccessPayment extends StatelessWidget {
  final Payment payment;
  const BookingSuccessPayment({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hình thức khám: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Expanded(
                child: Text(
                  convertPaymentType(payment.paymentType),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phương thức:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Expanded(
                child: Text(
                  converMethodPayment(payment.method),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số tiền: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                formatCurrency(payment.amount),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày thanh toán: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                payment.payAt != null ? formatDate(payment.payAt!) : '--',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
