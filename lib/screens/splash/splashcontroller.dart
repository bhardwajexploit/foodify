import 'package:get/get.dart';

class Splashcontroller extends GetxController{

  @override
  void onInit(){
    super.onInit();
    _navigate();
  }
  void _navigate() async{
    await  Future.delayed(Duration(seconds:3));
    Get.offAllNamed('/welcome');
  }
}