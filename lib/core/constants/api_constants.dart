
class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    return 'https://farchis.com/api/v1';
  }

  // Auth Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authGoogle = '/auth/google';
  static const String authSendOtp = '/auth/otp/send';
  static const String authVerifyOtp = '/auth/otp/verify';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authUpdateProfile = '/auth/profile';
  static const String authUpdateFcmToken = '/auth/fcm-token';

  // Bookings
  static const String bookings = '/bookings';
  static String booking(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static String driverLocation(String id) => '/bookings/$id/driver-location';
  static const String availableSlots = '/bookings/available-slots';

  // Services
  static const String services = '/services';
  static String service(String id) => '/services/$id';
  static String servicePrice(String id) => '/services/$id/price';

  // Payments
  static const String initiatePayment = '/payments/initiate';
  static const String paynowWebhook = '/payments/paynow/webhook';
  static const String stripeWebhook = '/payments/stripe/webhook';

  // Loyalty
  static const String loyaltyWallet = '/loyalty/wallet';
  static const String loyaltyTransactions = '/loyalty/transactions';
  static const String loyaltyRedeem = '/loyalty/redeem';

  // Scratch Cards
  static const String scratchCards = '/scratch-cards';
  static String scratchCard(String id) => '/scratch-cards/$id/scratch';

  // Gallery
  static const String gallery = '/gallery';

  // Articles
  static const String articles = '/articles';
  static String article(String slug) => '/articles/$slug';

  // Reviews
  static const String reviews = '/reviews';
  static const String allReviews = '/reviews';

  // Promotions
  static const String promotions = '/promotions';

  // Referrals
  static const String referrals = '/referrals';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';

  // Vehicles (dedicated multi-vehicle garage resource)
  static const String vehicles = '/vehicles';
  static String vehicle(String id) => '/vehicles/$id';
  static String setPrimaryVehicle(String id) => '/vehicles/$id/set-primary';
  static const String vehicleSizeCategories = '/vehicle-size-categories';

  // Inspection Requests
  static const String inspectionRequests = '/inspection-requests';
  static String inspectionRequest(String id) => '/inspection-requests/$id';
  static String acceptInspectionQuote(String id) => '/inspection-requests/$id/accept-quote';
  static String declineInspectionRequest(String id) => '/inspection-requests/$id/decline';

  // Chat / Conversations
  static const String conversations = '/conversations';
  static String conversationMessages(String id) => '/conversations/$id/messages';
  static String markConversationRead(String id) => '/conversations/$id/read';

  // Reverb/Pusher-protocol broadcasting auth for Sanctum-authenticated mobile
  // clients (see routes/api.php on the backend — distinct from the default
  // browser-facing /broadcasting/auth route).
  static String get broadcastingAuthUrl => '$baseUrl/broadcasting/auth';

  // Stripe
  // Placeholder — must match the backend's STRIPE_KEY (publishable key) in
  // config/services.php / .env for PaymentSheet to work end-to-end.
  static const String stripePublishableKey = 'pk_test_REPLACE_ME';

  // Reverb (self-hosted Laravel Reverb, Pusher-protocol). These match the
  // backend's local .env defaults — update if the backend's REVERB_* values
  // change (e.g. for staging/production).
  static const String reverbAppKey = 'nbyp5jmovf6ooth7wcli';
  static const String reverbHost = 'localhost';
  static const int reverbPort = 8080;
  static const String reverbScheme = 'http';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
