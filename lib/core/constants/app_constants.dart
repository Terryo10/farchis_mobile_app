class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Farchis';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // SharedPreferences Keys
  static const String spKeyThemeMode = 'theme_mode';
  static const String spKeyUserId = 'user_id';
  static const String spKeyUserEmail = 'user_email';
  static const String spKeyOnboardingComplete = 'onboarding_complete';

  // Loyalty Constants
  static const int loyaltyPointsPerBooking = 100;
  static const int loyaltyTierSilverThreshold = 1000;
  static const int loyaltyTierGoldThreshold = 5000;
  static const int loyaltyTierPlatinumThreshold = 10000;

  // Booking Status
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusConfirmed = 'confirmed';
  static const String bookingStatusInQueue = 'in_queue';
  static const String bookingStatusBeingAssessed = 'being_assessed';
  static const String bookingStatusInProgress = 'in_progress';
  static const String bookingStatusReady = 'ready';
  static const String bookingStatusCompleted = 'completed';
  static const String bookingStatusCancelled = 'cancelled';

  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusProcessing = 'processing';
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusFailed = 'failed';
  static const String paymentStatusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentMethodStripe = 'stripe';
  static const String paymentMethodEcocash = 'ecocash';

  // Service Categories
  static const String serviceCategoryMaintenance = 'maintenance';
  static const String serviceCategoryRepair = 'repair';
  static const String serviceCategoryDetailing = 'detailing';
  static const String serviceCategoryCustom = 'custom';

  // Scratch Card Prize Types
  static const String scratchCardPrizeDiscount = 'discount';
  static const String scratchCardPrizeFreeValet = 'free_valet';
  static const String scratchCardPrizeBonusPoints = 'bonus_points';

  // Notification Types
  static const String notificationTypeBookingStatus = 'booking_status';
  static const String notificationTypePromotion = 'promotion';
  static const String notificationTypeScratchCard = 'scratch_card';
  static const String notificationTypeLoyalty = 'loyalty';
  static const String notificationTypeReminder = 'reminder';

  // Maps Categories
  static const String mapsLocationFuelStations = 'fuel_stations';
  static const String mapsLocationCarWashes = 'car_washes';
  static const String mapsLocationAutoparts = 'auto_parts';
  static const String mapsLocationTyreShops = 'tyre_shops';
  static const String mapsLocationTowing = 'towing';

  // OTP
  static const int otpExpiryMinutes = 10;
  static const int otpResendDelaySeconds = 60;

  // Polling Intervals
  static const Duration jobTrackerPollInterval = Duration(seconds: 5);
  static const Duration bookingDetailRefreshInterval = Duration(seconds: 30);

  // Image Upload
  static const int maxImageSize = 5242880; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  // Pagination
  static const int defaultPageSize = 20;
}
