import 'package:get/get.dart';
import 'package:rawnes/modules/login/login_binding.dart';
import 'package:rawnes/modules/login/login_view.dart';
import 'package:rawnes/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static const HOME = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
