import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String formatCurrency(double amount, {String currency = 'USD'}) {
    final formatter = NumberFormat.currency(symbol: currency == 'USD' ? '\$' : 'ZWL ');
    return formatter.format(amount);
  }

  static String formatLoyaltyPoints(int points) {
    return NumberFormat('#,##0').format(points);
  }

  static String formatPhoneNumber(String phone) {
    // Zimbabwean phone format
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
    } else if (cleaned.length == 12 && cleaned.startsWith('263')) {
      return '+${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
    }
    return phone;
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatTimeRange(DateTime start, DateTime end) {
    return '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}';
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  static String formatPercentage(double value, {int decimals = 1}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final hours = duration.inHours;

    if (hours > 0) {
      return '${hours}h ${minutes % 60}m';
    }
    return '${minutes}m';
  }

  static String formatBookingStatus(String status) {
    final statusMap = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'in_queue': 'In Queue',
      'being_assessed': 'Being Assessed',
      'in_progress': 'In Progress',
      'ready': 'Ready for Pickup',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };
    return statusMap[status] ?? status;
  }

  static String formatPaymentStatus(String status) {
    final statusMap = {
      'pending': 'Pending',
      'processing': 'Processing',
      'paid': 'Paid',
      'failed': 'Failed',
      'cancelled': 'Cancelled',
    };
    return statusMap[status] ?? status;
  }

  static String formatServiceCategory(String category) {
    final categoryMap = {
      'maintenance': 'Maintenance',
      'repair': 'Repair',
      'detailing': 'Detailing',
      'custom': 'Custom',
    };
    return categoryMap[category] ?? category;
  }
}
