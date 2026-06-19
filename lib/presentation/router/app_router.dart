import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../splash/splash_screen.dart';
import '../home/home_screen.dart';
import '../auth/login_screen.dart';
import '../auth/otp_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorPageBuilder: (context, state) {
    return NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text('Page not found: ${state.fullPath}'),
        ),
      ),
    );
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra as Map<String, dynamic>? ?? {};
        return OtpScreen(phone: phone['phone'] ?? '');
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
