

import 'package:foodify/screens/splash/splashcontroller.dart';
import 'package:get/get.dart';

class Splashbindings extends Bindings {
  @override
  void dependencies(){
    Get.put<Splashcontroller>(Splashcontroller());
  }
}