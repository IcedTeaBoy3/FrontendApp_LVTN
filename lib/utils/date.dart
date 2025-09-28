import 'package:intl/intl.dart';

String getWeekdayName(DateTime date) {
  const weekdays = {
    1: "Thứ 2",
    2: "Thứ 3",
    3: "Thứ 4",
    4: "Thứ 5",
    5: "Thứ 6",
    6: "Thứ 7",
    7: "Chủ nhật",
  };

  return weekdays[date.weekday] ?? "";
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}
