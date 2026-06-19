class DateUtils {
  DateUtils._();

  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getTomorrow() {
    return getToday().add(const Duration(days: 1));
  }

  static DateTime getNextWeek() {
    return getToday().add(const Duration(days: 7));
  }

  static DateTime getNextMonth() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month + 1, now.day);
    if (date.month == 1) {
      return DateTime(now.year + 1, 1, now.day);
    }
    return date;
  }

  static bool isToday(DateTime date) {
    final today = getToday();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = getTomorrow();
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static List<DateTime> getAvailableDates(int daysAhead) {
    final dates = <DateTime>[];
    final today = getToday();
    for (int i = 0; i < daysAhead; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }

  static List<String> getTimeSlots({
    required DateTime date,
    int startHour = 8,
    int endHour = 18,
    int intervalMinutes = 30,
  }) {
    final slots = <String>[];
    for (int i = startHour; i < endHour; i++) {
      for (int j = 0; j < 60; j += intervalMinutes) {
        slots.add('${i.toString().padLeft(2, '0')}:${j.toString().padLeft(2, '0')}');
      }
    }
    return slots;
  }

  static DateTime parseTime(String timeString, {DateTime? baseDate}) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final base = baseDate ?? DateTime.now();
    return DateTime(base.year, base.month, base.day, hour, minute);
  }

  static bool isWithinBusinessHours(
    DateTime dateTime, {
    int startHour = 8,
    int endHour = 18,
  }) {
    return dateTime.hour >= startHour && dateTime.hour < endHour;
  }

  static DateTime addBusinessDays(DateTime date, int businessDays) {
    int added = 0;
    while (added < businessDays) {
      date = date.add(const Duration(days: 1));
      if (!isWeekend(date)) {
        added++;
      }
    }
    return date;
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static String getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  static String getMonthName(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[date.month - 1];
  }
}
