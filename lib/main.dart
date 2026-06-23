import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize dependency injection, network, storage
  await Injection.init();

  runApp(const FarchisApp());
}
