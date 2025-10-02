import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
}
