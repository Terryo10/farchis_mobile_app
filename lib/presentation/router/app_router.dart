import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';
import 'auth_guard.dart';
import '../../data/models/notification_model.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_layout_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/booking/booking_list_screen.dart';
import '../screens/booking/job_tracker_screen.dart';
import '../screens/booking/create_booking_screen.dart';
import '../screens/maps/driver_convenience_map_screen.dart';
import '../screens/scratch_card/scratch_card_screen.dart';
import '../screens/loyalty/loyalty_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/gallery/gallery_screen.dart';
import '../screens/referral/referral_screen.dart';
import '../screens/notification/notification_list_screen.dart';
import '../screens/profile/personal_info_screen.dart';
import '../screens/profile/my_vehicles_screen.dart';
import '../screens/profile/payment_methods_screen.dart';
import '../screens/profile/notification_prefs_screen.dart';
import '../screens/profile/help_support_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(
          page: MainLayoutRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: BookingListRoute.page),
            AutoRoute(page: LoyaltyRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        AutoRoute(page: JobTrackerRoute.page, guards: [authGuard]),
        AutoRoute(page: CreateBookingRoute.page, guards: [authGuard]),
        AutoRoute(page: DriverConvenienceMapRoute.page, guards: [authGuard]),
        AutoRoute(page: ScratchCardRoute.page, guards: [authGuard]),
        AutoRoute(page: GalleryRoute.page),
        AutoRoute(page: ReferralRoute.page, guards: [authGuard]),
        AutoRoute(page: NotificationListRoute.page, guards: [authGuard]),
        AutoRoute(page: PersonalInfoRoute.page, guards: [authGuard]),
        AutoRoute(page: MyVehiclesRoute.page, guards: [authGuard]),
        AutoRoute(page: PaymentMethodsRoute.page, guards: [authGuard]),
        AutoRoute(page: NotificationsRoute.page, guards: [authGuard]),
        AutoRoute(page: HelpSupportRoute.page),

      ];

  static void navigateFromNotification(NotificationModel notification, AppRouter router) {
    if (notification.type == 'booking_update') {
      final bookingId = notification.data['booking_id'];
      if (bookingId != null) {
        // router.push(JobTrackerRoute(bookingId: bookingId));
      }
    } else if (notification.type == 'scratch_card') {
      router.push(const ScratchCardRoute());
    } else if (notification.type == 'promotion') {
      // router.push(PromotionRoute(id: notification.data['promotion_id']));
    }
  }
}
