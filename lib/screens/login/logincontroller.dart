
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  import '../../data/remote/authservice.dart';

  class Logincontroller extends GetxController {
    final Authservice _authService = Authservice();
    var isPasswordVisible = false.obs;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final RxBool isLoading = false.obs; // ✅ camelCase + getter

    bool get loading => isLoading.value; // ✅ Public ge
    Future<void> loginUser() async {
      isLoading.value = true;
      try {
        final cred = await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        debugPrint('✅ [LOGIN] SUCCESS! UID: ${cred.user?.uid}');

        Get.offAllNamed('/home');
        Get.snackbar(
          "Welcome back",
          'login Sucessfull',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );

      } on FirebaseAuthException catch (e) {
        debugPrint('❌ [LOGIN] FirebaseAuthException: ${e.code} - ${e.message}');
        Get.snackbar(
          '${e.message}',
          e.code,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      } catch (e) {
        debugPrint('❌ [LOGIN] Unknown error: $e');
        Get.snackbar('Error', "unknown", backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
        debugPrint('🏁 [LOGIN] Login process completed');
      }
    }
  }
