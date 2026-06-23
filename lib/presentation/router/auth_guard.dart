import 'package:auto_route/auto_route.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final FlutterSecureStorage secureStorage;

  AuthGuard(this.secureStorage);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replace(const LoginRoute());
    }
  }
}
