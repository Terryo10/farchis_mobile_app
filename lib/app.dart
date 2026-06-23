import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'presentation/router/auth_guard.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/theme/theme_cubit.dart';

class FarchisApp extends StatefulWidget {
  const FarchisApp({super.key});

  @override
  State<FarchisApp> createState() => _FarchisAppState();
}

class _FarchisAppState extends State<FarchisApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(authGuard: AuthGuard(Injection.secureStorage));
    NotificationService.initialize(_appRouter);
    Injection.authBloc.add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: Injection.authRepository),
        RepositoryProvider.value(value: Injection.bookingRepository),
        RepositoryProvider.value(value: Injection.serviceRepository),
        RepositoryProvider.value(value: Injection.loyaltyRepository),
        RepositoryProvider.value(value: Injection.scratchCardRepository),
        RepositoryProvider.value(value: Injection.paymentRepository),
        RepositoryProvider.value(value: Injection.galleryRepository),
        RepositoryProvider.value(value: Injection.articleRepository),
        RepositoryProvider.value(value: Injection.reviewRepository),
        RepositoryProvider.value(value: Injection.promotionRepository),
        RepositoryProvider.value(value: Injection.referralRepository),
        RepositoryProvider.value(value: Injection.notificationRepository),
        RepositoryProvider.value(value: Injection.vehicleRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: Injection.themeCubit),
          BlocProvider.value(value: Injection.authBloc),
          BlocProvider.value(value: Injection.bookingBloc),
          BlocProvider.value(value: Injection.bookingCreateBloc),
          BlocProvider.value(value: Injection.loyaltyBloc),
          BlocProvider.value(value: Injection.mapsBloc),
          BlocProvider.value(value: Injection.servicesBloc),
          BlocProvider.value(value: Injection.promotionBloc),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Farchis Automotive',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              routerConfig: _appRouter.config(),
              builder: (context, child) {
                FlutterNativeSplash.remove();
                return child!;
              },
            );
          },
        ),
      ),
    );
  }
}
