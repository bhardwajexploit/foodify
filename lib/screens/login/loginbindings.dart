
import 'package:get/get.dart';

import 'logincontroller.dart';

class Loginbindings extends Bindings{
  @override
  void dependencies() {
    Get.put<Logincontroller>(Logincontroller());
  }
}