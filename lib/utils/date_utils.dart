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

// Format lại ngày sinh
String formatDob(String dob) {
  if (dob.length != 8) return dob;
  return "${dob.substring(0, 2)}/${dob.substring(2, 4)}/${dob.substring(4, 8)}";
}

String formatTime(DateTime? time) {
  if (time == null) return '';
  final DateFormat formatter = DateFormat('HH:mm');
  return formatter.format(time);
}
