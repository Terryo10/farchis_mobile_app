import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app.dart';
import 'core/constants/api_constants.dart';
import 'core/di/injection.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize dependency injection, network, storage
  await Injection.init();

  // Initialize Stripe (publishable key must match the backend's STRIPE_KEY)
  Stripe.publishableKey = ApiConstants.stripePublishableKey;
  await Stripe.instance.applySettings();

  runApp(const FarchisApp());
}
