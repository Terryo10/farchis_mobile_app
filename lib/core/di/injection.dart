import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/http_client.dart';
import '../../data/repositories/article_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/loyalty_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/promotion_repository.dart';
import '../../data/repositories/referral_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/scratch_card_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/vehicle_repository.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking_create/booking_create_bloc.dart';
import '../../blocs/loyalty/loyalty_bloc.dart';
import '../../blocs/maps/maps_bloc.dart';
import '../../blocs/services/services_bloc.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/promotion/promotion_bloc.dart';
import '../../blocs/gallery/gallery_bloc.dart';
import '../../blocs/scratch_card/scratch_card_bloc.dart';
import '../../blocs/referral/referral_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';

class Injection {
  Injection._();

  static late final FlutterSecureStorage secureStorage;
  static late final SharedPreferences sharedPreferences;
  static late final FarchisHttpClient httpClient;

  // Repositories
  static late final ArticleRepository articleRepository;
  static late final AuthRepository authRepository;
  static late final BookingRepository bookingRepository;
  static late final GalleryRepository galleryRepository;
  static late final LoyaltyRepository loyaltyRepository;
  static late final NotificationRepository notificationRepository;
  static late final PaymentRepository paymentRepository;
  static late final PromotionRepository promotionRepository;
  static late final ReferralRepository referralRepository;
  static late final ReviewRepository reviewRepository;
  static late final ScratchCardRepository scratchCardRepository;
  static late final ServiceRepository serviceRepository;
  static late final VehicleRepository vehicleRepository;

  // Blocs
  static late final AuthBloc _authBloc;
  static late final BookingBloc _bookingBloc;
  static late final BookingCreateBloc _bookingCreateBloc;
  static late final LoyaltyBloc _loyaltyBloc;
  static late final MapsBloc _mapsBloc;
  static late final ServicesBloc _servicesBloc;
  static late final ThemeCubit _themeCubit;
  static late final PromotionBloc _promotionBloc;
  static late final GalleryBloc _galleryBloc;
  static late final ScratchCardBloc _scratchCardBloc;
  static late final ReferralBloc _referralBloc;
  static late final NotificationBloc _notificationBloc;

  static Future<void> init() async {
    secureStorage = const FlutterSecureStorage();
    sharedPreferences = await SharedPreferences.getInstance();
    httpClient = FarchisHttpClient(secureStorage);

    // Init Repositories
    articleRepository = ArticleRepository(httpClient);
    authRepository = AuthRepository(httpClient);
    bookingRepository = BookingRepository(httpClient);
    galleryRepository = GalleryRepository(httpClient);
    loyaltyRepository = LoyaltyRepository(httpClient);
    notificationRepository = NotificationRepository(httpClient);
    paymentRepository = PaymentRepository(httpClient);
    promotionRepository = PromotionRepository(httpClient);
    referralRepository = ReferralRepository(httpClient);
    reviewRepository = ReviewRepository(httpClient);
    scratchCardRepository = ScratchCardRepository(httpClient);
    serviceRepository = ServiceRepository(httpClient);
    vehicleRepository = VehicleRepository(httpClient);

    // Init Blocs
    _authBloc = AuthBloc(authRepository: authRepository, secureStorage: secureStorage);
    _bookingBloc = BookingBloc(bookingRepository);
    _bookingCreateBloc = BookingCreateBloc(bookingRepository);
    _loyaltyBloc = LoyaltyBloc(loyaltyRepository: loyaltyRepository);
    _mapsBloc = MapsBloc(); 
    _servicesBloc = ServicesBloc(serviceRepository: serviceRepository);
    _themeCubit = ThemeCubit(sharedPreferences);
    _promotionBloc = PromotionBloc(promotionRepository: promotionRepository);
    _galleryBloc = GalleryBloc(galleryRepository: galleryRepository);
    _scratchCardBloc = ScratchCardBloc(scratchCardRepository: scratchCardRepository);
    _referralBloc = ReferralBloc(referralRepository: referralRepository);
    _notificationBloc = NotificationBloc(notificationRepository: notificationRepository);
  }

  static AuthBloc get authBloc => _authBloc;
  static BookingBloc get bookingBloc => _bookingBloc;
  static BookingCreateBloc get bookingCreateBloc => _bookingCreateBloc;
  static LoyaltyBloc get loyaltyBloc => _loyaltyBloc;
  static MapsBloc get mapsBloc => _mapsBloc;
  static ServicesBloc get servicesBloc => _servicesBloc;
  static ThemeCubit get themeCubit => _themeCubit;
  static PromotionBloc get promotionBloc => _promotionBloc;
  static GalleryBloc get galleryBloc => _galleryBloc;
  static ScratchCardBloc get scratchCardBloc => _scratchCardBloc;
  static ReferralBloc get referralBloc => _referralBloc;
  static NotificationBloc get notificationBloc => _notificationBloc;
}
