
import 'package:flutter/material.dart';
import 'package:foodify/screens/history_user/booked_userhistory.dart';
import 'package:foodify/screens/profile%20/profile_Screen.dart';
import 'package:get/get.dart';
import '../restaurant_homescreen/home_dashboard.dart';
import 'dashboard_controller.dart';

class DashboardNavigation extends StatelessWidget{
  DashboardNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final c=Get.find<DashboardController>();
    return Scaffold(
      body: SafeArea(child: Obx(() => IndexedStack(
        index: c.tabIndex.value,
        children: [
         RestaurantHomeScreen(),
          BookingHistoryScreen(),
          ProfileScreen(),
        ],

      ))),
      bottomNavigationBar: Obx(() {
      final index=c.tabIndex.value;
      return NavigationBarTheme(data: NavigationBarThemeData(
        
      ), child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: c.changeTab,
          destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.history_sharp), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.verified_user), label: 'Profile'),
      ]));
      }),
    );
  }

}