import 'package:equatable/equatable.dart';

/// Well-known pref keys — typed constants prevent typo-driven bugs.
class NotifPrefKeys {
  static const String bookingUpdates = 'notif_booking_updates';
  static const String promotions = 'notif_promotions';
  static const String reminders = 'notif_reminders';
  static const String newServices = 'notif_new_services';

  /// All keys in display order.
  static const List<String> all = [
    bookingUpdates,
    promotions,
    reminders,
    newServices,
  ];

  /// Human-readable label for each key.
  static const Map<String, String> labels = {
    bookingUpdates: 'Booking Updates',
    promotions: 'Promotions & Offers',
    reminders: 'Reminders',
    newServices: 'New Services',
  };

  static const Map<String, String> subtitles = {
    bookingUpdates: 'Status changes for your active bookings',
    promotions: 'Deals, discounts and special events',
    reminders: 'Service due and appointment reminders',
    newServices: 'When new services are added',
  };
}

class NotificationPrefsState extends Equatable {
  final Map<String, bool> prefs;
  final bool isLoading;

  const NotificationPrefsState({
    this.prefs = const {
      NotifPrefKeys.bookingUpdates: true,
      NotifPrefKeys.promotions: true,
      NotifPrefKeys.reminders: true,
      NotifPrefKeys.newServices: false,
    },
    this.isLoading = false,
  });

  NotificationPrefsState copyWith({
    Map<String, bool>? prefs,
    bool? isLoading,
  }) {
    return NotificationPrefsState(
      prefs: prefs ?? this.prefs,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get(String key) => prefs[key] ?? true;

  @override
  List<Object?> get props => [prefs, isLoading];
}
