import 'package:flutter/animation.dart';
import 'package:foodify/screens/Booking/booking_bindings.dart';
import 'package:foodify/screens/Booking/bookingformscreen.dart';
import 'package:foodify/screens/table_selection/table_selection_bindings.dart';

import '../../screens/Register/register.dart';
import '../../screens/Register/register_bindings.dart';
import '../../screens/dashboard /dashboard_bindings.dart';
import '../../screens/dashboard /dashboard_navigation.dart';
import '../../screens/login/loginbindings.dart';
import '../../screens/login/loginpage.dart';
import '../../screens/splash/splash.dart';
import '../../screens/splash/splashbindings.dart';
import '../../screens/table_selection/table_selection.dart';
import '../../screens/welcome/welcomepage.dart';
import '../constants/app_routes.dart';

import 'package:get/get.dart';
class AppPages {
  AppPages._();
  static final routes =[
    GetPage(name: AppRoutes.sPLASH, page: () => Splash(),binding: Splashbindings()),
    GetPage(name: AppRoutes.loginpage, page:() => LoginPage(),binding: Loginbindings(),
     transition: Transition.rightToLeft,                // animation
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,),
    GetPage(name: AppRoutes.welcomeScreen, page: () => WelcomeScreen()),
    GetPage(name:AppRoutes.registerPage,page: () =>RegisterPage(),binding: RegisterBindings()),
    GetPage(name: AppRoutes.homePage, page: () => DashboardNavigation(),binding: DashboardBindings()),
    GetPage(name: AppRoutes.bookingPage, page: () => BookingFormScreen(),binding: BookingBindings()),
    GetPage(name: '/table-selection', page: () => const TableSelectionScreen(),binding: TableSelectionBindings()),
  ];
}