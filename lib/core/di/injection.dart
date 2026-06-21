import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/loyalty/loyalty_bloc.dart';
import '../../blocs/services/services_bloc.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/loyalty_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/scratch_card_repository.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/article_repository.dart';
import '../../data/repositories/promotion_repository.dart';
import '../../data/repositories/referral_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../network/dio_client.dart';
import '../network/api_client.dart';

class DIContainer {
  static final DIContainer _instance = DIContainer._internal();

  factory DIContainer() {
    return _instance;
  }

  DIContainer._internal();

  late DioClient _dioClient;
  late ApiClient _apiClient;
  late FlutterSecureStorage _secureStorage;

  // Repositories
  late AuthRepository _authRepository;
  late ServiceRepository _serviceRepository;
  late BookingRepository _bookingRepository;
  late PaymentRepository _paymentRepository;
  late LoyaltyRepository _loyaltyRepository;
  late ScratchCardRepository _scratchCardRepository;
  late GalleryRepository _galleryRepository;
  late ArticleRepository _articleRepository;
  late PromotionRepository _promotionRepository;
  late ReferralRepository _referralRepository;
  late NotificationRepository _notificationRepository;
  late ReviewRepository _reviewRepository;
  late VehicleRepository _vehicleRepository;

  void initialize() {
    _dioClient = DioClient();
    _secureStorage = const FlutterSecureStorage();
    _apiClient = ApiClient(dio: _dioClient.dio);

    // Initialize repositories
    _authRepository = AuthRepository(apiClient: _apiClient);
    _serviceRepository = ServiceRepository(apiClient: _apiClient);
    _bookingRepository = BookingRepository(apiClient: _apiClient);
    _paymentRepository = PaymentRepository(apiClient: _apiClient);
    _loyaltyRepository = LoyaltyRepository(apiClient: _apiClient);
    _scratchCardRepository = ScratchCardRepository(apiClient: _apiClient);
    _galleryRepository = GalleryRepository(apiClient: _apiClient);
    _articleRepository = ArticleRepository(apiClient: _apiClient);
    _promotionRepository = PromotionRepository(apiClient: _apiClient);
    _referralRepository = ReferralRepository(apiClient: _apiClient);
    _notificationRepository = NotificationRepository(apiClient: _apiClient);
    _reviewRepository = ReviewRepository(apiClient: _apiClient);
    _vehicleRepository = VehicleRepository(apiClient: _apiClient);
  }

  // Network
  DioClient get dioClient => _dioClient;
  ApiClient get apiClient => _apiClient;

  // Repositories
  AuthRepository get authRepository => _authRepository;
  ServiceRepository get serviceRepository => _serviceRepository;
  BookingRepository get bookingRepository => _bookingRepository;
  PaymentRepository get paymentRepository => _paymentRepository;
  LoyaltyRepository get loyaltyRepository => _loyaltyRepository;
  ScratchCardRepository get scratchCardRepository => _scratchCardRepository;
  GalleryRepository get galleryRepository => _galleryRepository;
  ArticleRepository get articleRepository => _articleRepository;
  PromotionRepository get promotionRepository => _promotionRepository;
  ReferralRepository get referralRepository => _referralRepository;
  NotificationRepository get notificationRepository => _notificationRepository;
  ReviewRepository get reviewRepository => _reviewRepository;
  VehicleRepository get vehicleRepository => _vehicleRepository;

  // List of all repositories to be provided
  List<SingleChildWidget> getRepositoryProviders() {
    return [
      RepositoryProvider<AuthRepository>(create: (_) => _authRepository),
      RepositoryProvider<ServiceRepository>(create: (_) => _serviceRepository),
      RepositoryProvider<BookingRepository>(create: (_) => _bookingRepository),
      RepositoryProvider<PaymentRepository>(create: (_) => _paymentRepository),
      RepositoryProvider<LoyaltyRepository>(create: (_) => _loyaltyRepository),
      RepositoryProvider<ScratchCardRepository>(create: (_) => _scratchCardRepository),
      RepositoryProvider<GalleryRepository>(create: (_) => _galleryRepository),
      RepositoryProvider<ArticleRepository>(create: (_) => _articleRepository),
      RepositoryProvider<PromotionRepository>(create: (_) => _promotionRepository),
      RepositoryProvider<ReferralRepository>(create: (_) => _referralRepository),
      RepositoryProvider<NotificationRepository>(create: (_) => _notificationRepository),
      RepositoryProvider<ReviewRepository>(create: (_) => _reviewRepository),
      RepositoryProvider<VehicleRepository>(create: (_) => _vehicleRepository),
    ];
  }

  // List of all BLoCs to be provided
  List<SingleChildWidget> getBlocProviders() {
    return [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          authRepository: _authRepository,
          dioClient: _dioClient,
          secureStorage: _secureStorage,
        ),
      ),
      BlocProvider<ServicesBloc>(create: (_) => ServicesBloc(serviceRepository: _serviceRepository)),
      BlocProvider<BookingBloc>(create: (_) => BookingBloc(bookingRepository: _bookingRepository)),
      BlocProvider<LoyaltyBloc>(create: (_) => LoyaltyBloc(loyaltyRepository: _loyaltyRepository)),
    ];
  }
}
