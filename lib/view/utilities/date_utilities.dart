class DateUtilities {
  static String getFormattedDateTime(DateTime date) {
    String suffix = date.hour < 12 ? 'AM' : 'PM';
    int hour = date.hour % 12;
    return '${date.day}/${date.month}/${date.year} - $hour:${date.minute} $suffix';
  }
}
