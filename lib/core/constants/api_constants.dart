import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    return 'http://10.39.132.196:5000/api/v1';
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

  // Vehicle
  static const String updateVehicle = '/vehicle';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
