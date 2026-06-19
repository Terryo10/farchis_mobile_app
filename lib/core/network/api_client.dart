import 'package:dio/dio.dart';

import '../../data/models/user_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/loyalty_wallet_model.dart';
import '../../data/models/promotion_model.dart';
import '../../data/models/article_model.dart';
import '../../data/models/gallery_item_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/scratch_card_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/referral_model.dart';
import '../../data/models/available_slot_model.dart';
import '../constants/api_constants.dart';

/// ApiClient provides type-safe API communication using Dio
class ApiClient {
  final Dio dio;

  ApiClient({required this.dio});

  // Auth Endpoints
  Future<Map<String, dynamic>> sendOtp(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.authSendOtp, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.authVerifyOtp, data: data);
    return response.data;
  }

  Future<UserModel> getProfile() async {
    final response = await dio.get(ApiConstants.authMe);
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await dio.put(ApiConstants.authUpdateProfile, data: data);
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<Map<String, dynamic>> updateFcmToken(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.authUpdateFcmToken, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await dio.post(ApiConstants.authLogout);
    return response.data;
  }

  // Booking Endpoints
  Future<List<BookingModel>> getBookings() async {
    final response = await dio.get(ApiConstants.bookings);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => BookingModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<BookingModel> getBooking(String id) async {
    final response = await dio.get(ApiConstants.booking(id));
    return BookingModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<BookingModel> createBooking(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.bookings, data: data);
    return BookingModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<BookingModel> updateBooking(String id, Map<String, dynamic> data) async {
    final response = await dio.put(ApiConstants.booking(id), data: data);
    return BookingModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<BookingModel> cancelBooking(String id) async {
    final response = await dio.post(ApiConstants.cancelBooking(id));
    return BookingModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<List<AvailableSlotModel>> getAvailableSlots(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.availableSlots, data: data);
    final slotData = response.data['data'] ?? response.data;
    if (slotData is List) {
      return slotData.map((item) => AvailableSlotModel.fromJson(item)).toList();
    }
    return [];
  }

  // Service Endpoints
  Future<List<ServiceModel>> getServices() async {
    final response = await dio.get(ApiConstants.services);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => ServiceModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<ServiceModel> getService(String id) async {
    final response = await dio.get(ApiConstants.service(id));
    return ServiceModel.fromJson(response.data['data'] ?? response.data);
  }

  // Payment Endpoints
  Future<Map<String, dynamic>> initiatePayment(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.initiatePayment, data: data);
    return response.data;
  }

  // Loyalty Endpoints
  Future<LoyaltyWalletModel> getLoyaltyWallet() async {
    final response = await dio.get(ApiConstants.loyaltyWallet);
    return LoyaltyWalletModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<List<Map<String, dynamic>>> getLoyaltyTransactions() async {
    final response = await dio.get(ApiConstants.loyaltyTransactions);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<Map<String, dynamic>> redeemPoints(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.loyaltyRedeem, data: data);
    return response.data;
  }

  // Scratch Card Endpoints
  Future<List<ScratchCardModel>> getScratchCards() async {
    final response = await dio.get(ApiConstants.scratchCards);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => ScratchCardModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<ScratchCardModel> scratchCard(String id) async {
    final response = await dio.post(ApiConstants.scratchCard(id));
    return ScratchCardModel.fromJson(response.data['data'] ?? response.data);
  }

  // Gallery Endpoints
  Future<List<GalleryItemModel>> getGallery() async {
    final response = await dio.get(ApiConstants.gallery);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => GalleryItemModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<GalleryItemModel> uploadGalleryItem(FormData data) async {
    final response = await dio.post(ApiConstants.gallery, data: data);
    return GalleryItemModel.fromJson(response.data['data'] ?? response.data);
  }

  // Article Endpoints
  Future<List<ArticleModel>> getArticles() async {
    final response = await dio.get(ApiConstants.articles);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => ArticleModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<ArticleModel> getArticle(String slug) async {
    final response = await dio.get(ApiConstants.article(slug));
    return ArticleModel.fromJson(response.data['data'] ?? response.data);
  }

  // Review Endpoints
  Future<List<ReviewModel>> getReviews() async {
    final response = await dio.get(ApiConstants.reviews);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => ReviewModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<ReviewModel> createReview(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.reviews, data: data);
    return ReviewModel.fromJson(response.data['data'] ?? response.data);
  }

  // Promotion Endpoints
  Future<List<PromotionModel>> getPromotions() async {
    final response = await dio.get(ApiConstants.promotions);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => PromotionModel.fromJson(item)).toList();
    }
    return [];
  }

  // Referral Endpoints
  Future<ReferralModel> getReferrals() async {
    final response = await dio.get(ApiConstants.referrals);
    return ReferralModel.fromJson(response.data['data'] ?? response.data);
  }

  // Notification Endpoints
  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get(ApiConstants.notifications);
    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> markNotificationRead(String id) async {
    final response = await dio.post(ApiConstants.markNotificationRead(id));
    return response.data;
  }

  Future<Map<String, dynamic>> markAllNotificationsRead() async {
    final response = await dio.post(ApiConstants.markAllNotificationsRead);
    return response.data;
  }

  // Vehicle Endpoints
  Future<UserModel> updateVehicle(Map<String, dynamic> data) async {
    final response = await dio.put(ApiConstants.updateVehicle, data: data);
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }
}
