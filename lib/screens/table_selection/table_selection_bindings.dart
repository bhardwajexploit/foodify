
import 'package:foodify/screens/Booking/booking_controller.dart';
import 'package:get/get.dart';

class TableSelectionBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BookingController(),fenix: true);
  }

}
