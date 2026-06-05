import 'package:get/get.dart';
import 'package:rawnes/modules/aboutUs/about_binding.dart';
import 'package:rawnes/modules/aboutUs/about_view.dart';
import 'package:rawnes/modules/home/home_binding.dart';
import 'package:rawnes/modules/home/home_view.dart';
import 'package:rawnes/modules/login/login_binding.dart';
import 'package:rawnes/modules/login/login_view.dart';
import 'package:rawnes/modules/profile/profile_binding.dart';
import 'package:rawnes/modules/profile/profile_view.dart';
import 'package:rawnes/modules/register/register_binding.dart';
import 'package:rawnes/modules/register/register_view.dart';
import 'package:rawnes/modules/splash/splash_binding.dart';
import 'package:rawnes/modules/splash/splash_view.dart';
import 'package:rawnes/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static const HOME = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
  ];
}
