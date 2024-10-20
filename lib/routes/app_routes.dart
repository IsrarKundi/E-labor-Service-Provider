import 'package:e_labors/authentication/views/login_screen.dart';
import 'package:e_labors/main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../home/views/home_screen.dart';
import '../profile/views/profile_screen.dart';


class AppRoutes {
  static const MAINSCREEN = '/main_screen';
  static const HOME = '/home';
  static const AUTHENTICATION = '/authentication';
  static const PROFILE = '/profile';
  // static const INTERVIEW = '/interview';
  // static const PRIVACYPOLICY = '/privacypolicy';
  // // static const SPLASH = '/splash';


  static List<GetPage> routes = [
    GetPage(
      name: HOME,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: MAINSCREEN,
      page: () => MainScreen(),
    ),
    GetPage(
      name: AUTHENTICATION,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileScreen(),
    ),
    // GetPage(
    //   name: PRIVACYPOLICY,
    //   page: () => PrivacyPolicy(),
    // ),
    // GetPage(
    //   name: SPLASH,
    //   page: () => SplashView(),
    // ),
  ];
}