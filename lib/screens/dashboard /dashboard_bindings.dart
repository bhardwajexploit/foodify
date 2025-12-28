


import 'package:get/get.dart';

import 'dashboard_controller.dart';

class DashboardBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() =>DashboardController());
  }
}