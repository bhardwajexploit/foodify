


import 'package:foodify/screens/Booking/bookingformscreen.dart';

abstract class AppRoutes {
  AppRoutes._();
  static const registerPage=_Paths.RegisterPage;
  static const sPLASH = _Paths.SPLASH;
  static const loginpage=_Paths.LoginPage;
  static const welcomeScreen=_Paths.Welcome;
  static const homePage=_Paths.HomePAge;
  static const bookingPage=_Paths.BookingPage;
  static const tablebooking=_Paths.TableBooking;
}

abstract class _Paths {
  static const BookingPage='/booking';
  static const HomePAge='/home';
  static const RegisterPage='/register';
  static const LoginPage='/login';
  static const SPLASH = "/splash";
  static const Welcome='/welcome';
  static const TableBooking='/table';
}