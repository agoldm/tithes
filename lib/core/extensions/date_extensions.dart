extension DateTimeExtensions on DateTime {
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
  
  DateTime get startOfMonth => DateTime(year, month, 1);
  
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
  
  String get monthYear => '$month/$year';
  
  String get displayMonth {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[month - 1]} $year';
  }
}