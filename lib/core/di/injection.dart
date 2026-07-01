import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/http_client.dart';
import '../services/pusher_service.dart';
import '../../data/repositories/article_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/inspection_request_repository.dart';
import '../../data/repositories/loyalty_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/promotion_repository.dart';
import '../../data/repositories/referral_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/scratch_card_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/providers/payment_provider.dart';
import '../../data/providers/local_payment_provider.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking_create/booking_create_bloc.dart';
import '../../blocs/chat/conversations_bloc.dart';
import '../../blocs/inspection_request/inspection_request_bloc.dart';
import '../../blocs/loyalty/loyalty_bloc.dart';
import '../../blocs/maps/maps_bloc.dart';
import '../../blocs/services/services_bloc.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/promotion/promotion_bloc.dart';
import '../../blocs/gallery/gallery_bloc.dart';
import '../../blocs/scratch_card/scratch_card_bloc.dart';
import '../../blocs/referral/referral_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/my_vehicles/my_vehicles_bloc.dart';
import '../../blocs/payment_methods/payment_methods_bloc.dart';
import '../../blocs/notification_prefs/notification_prefs_bloc.dart';

class Injection {
  Injection._();

  static late final FlutterSecureStorage secureStorage;
  static late final SharedPreferences sharedPreferences;
  static late final FarchisHttpClient httpClient;
  static late final PusherService pusherService;

  // Repositories
  static late final ArticleRepository articleRepository;
  static late final AuthRepository authRepository;
  static late final BookingRepository bookingRepository;
  static late final ChatRepository chatRepository;
  static late final GalleryRepository galleryRepository;
  static late final InspectionRequestRepository inspectionRequestRepository;
  static late final LoyaltyRepository loyaltyRepository;
  static late final NotificationRepository notificationRepository;
  static late final PaymentRepository paymentRepository;
  static late final PromotionRepository promotionRepository;
  static late final ReferralRepository referralRepository;
  static late final ReviewRepository reviewRepository;
  static late final ScratchCardRepository scratchCardRepository;
  static late final ServiceRepository serviceRepository;
  static late final VehicleRepository vehicleRepository;
  static late final PaymentProvider paymentProvider;

  // Blocs
  static late final AuthBloc _authBloc;
  static late final BookingBloc _bookingBloc;
  static late final BookingCreateBloc _bookingCreateBloc;
  static late final ConversationsBloc _conversationsBloc;
  static late final InspectionRequestBloc _inspectionRequestBloc;
  static late final LoyaltyBloc _loyaltyBloc;
  static late final MapsBloc _mapsBloc;
  static late final ServicesBloc _servicesBloc;
  static late final ThemeCubit _themeCubit;
  static late final PromotionBloc _promotionBloc;
  static late final GalleryBloc _galleryBloc;
  static late final ScratchCardBloc _scratchCardBloc;
  static late final ReferralBloc _referralBloc;
  static late final NotificationBloc _notificationBloc;
  static late final PersonalInfoBloc _personalInfoBloc;
  static late final MyVehiclesBloc _myVehiclesBloc;
  static late final PaymentMethodsBloc _paymentMethodsBloc;
  static late final NotificationPrefsBloc _notificationPrefsBloc;

  static Future<void> init() async {
    secureStorage = const FlutterSecureStorage();
    sharedPreferences = await SharedPreferences.getInstance();
    httpClient = FarchisHttpClient(secureStorage);
    pusherService = PusherService(secureStorage);

    // Init Repositories
    articleRepository = ArticleRepository(httpClient);
    authRepository = AuthRepository(httpClient);
    bookingRepository = BookingRepository(httpClient);
    chatRepository = ChatRepository(httpClient);
    galleryRepository = GalleryRepository(httpClient);
    inspectionRequestRepository = InspectionRequestRepository(httpClient);
    loyaltyRepository = LoyaltyRepository(httpClient);
    notificationRepository = NotificationRepository(httpClient);
    paymentRepository = PaymentRepository(httpClient);
    promotionRepository = PromotionRepository(httpClient);
    referralRepository = ReferralRepository(httpClient);
    reviewRepository = ReviewRepository(httpClient);
    scratchCardRepository = ScratchCardRepository(httpClient);
    serviceRepository = ServiceRepository(httpClient);
    vehicleRepository = VehicleRepository(httpClient);
    paymentProvider = LocalPaymentProvider();

    // Init Blocs
    _authBloc = AuthBloc(authRepository: authRepository, secureStorage: secureStorage);
    _bookingBloc = BookingBloc(bookingRepository);
    _bookingCreateBloc = BookingCreateBloc(bookingRepository);
    _conversationsBloc = ConversationsBloc(repository: chatRepository);
    _inspectionRequestBloc = InspectionRequestBloc(repository: inspectionRequestRepository);
    _loyaltyBloc = LoyaltyBloc(loyaltyRepository: loyaltyRepository);
    _mapsBloc = MapsBloc();
    _servicesBloc = ServicesBloc(serviceRepository: serviceRepository);
    _themeCubit = ThemeCubit(sharedPreferences);
    _promotionBloc = PromotionBloc(promotionRepository: promotionRepository);
    _galleryBloc = GalleryBloc(galleryRepository: galleryRepository);
    _scratchCardBloc = ScratchCardBloc(scratchCardRepository: scratchCardRepository);
    _referralBloc = ReferralBloc(referralRepository: referralRepository);
    _notificationBloc = NotificationBloc(notificationRepository: notificationRepository);
    _personalInfoBloc = PersonalInfoBloc(authRepository: authRepository, authBloc: _authBloc);
    _myVehiclesBloc = MyVehiclesBloc(repository: vehicleRepository);
    _paymentMethodsBloc = PaymentMethodsBloc(paymentProvider: paymentProvider);
    _notificationPrefsBloc = NotificationPrefsBloc(prefs: sharedPreferences);
  }

  static AuthBloc get authBloc => _authBloc;
  static BookingBloc get bookingBloc => _bookingBloc;
  static BookingCreateBloc get bookingCreateBloc => _bookingCreateBloc;
  static ConversationsBloc get conversationsBloc => _conversationsBloc;
  static InspectionRequestBloc get inspectionRequestBloc => _inspectionRequestBloc;
  static LoyaltyBloc get loyaltyBloc => _loyaltyBloc;
  static MapsBloc get mapsBloc => _mapsBloc;
  static ServicesBloc get servicesBloc => _servicesBloc;
  static ThemeCubit get themeCubit => _themeCubit;
  static PromotionBloc get promotionBloc => _promotionBloc;
  static GalleryBloc get galleryBloc => _galleryBloc;
  static ScratchCardBloc get scratchCardBloc => _scratchCardBloc;
  static ReferralBloc get referralBloc => _referralBloc;
  static NotificationBloc get notificationBloc => _notificationBloc;
  static PersonalInfoBloc get personalInfoBloc => _personalInfoBloc;
  static MyVehiclesBloc get myVehiclesBloc => _myVehiclesBloc;
  static PaymentMethodsBloc get paymentMethodsBloc => _paymentMethodsBloc;
  static NotificationPrefsBloc get notificationPrefsBloc => _notificationPrefsBloc;
}
