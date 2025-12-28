
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodify/screens/Register/register_repo.dart';
import 'package:get/get.dart';

import '../../data/remote/authservice.dart';

class RegisterController extends GetxController {

  var isPasswordVisible = false.obs;
  final RegisterRepo _repo = RegisterRepo();
  final Authservice _authService = Authservice();

  // Text fields
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();

  // State
  final _loading = false.obs;
  final _error = ''.obs;

  bool get loading => _loading.value;
  String get error => _error.value;

  Future<void> createUser() async {

    // Basic empty validation
    if (email.text.trim().isEmpty ||
        password.text.trim().isEmpty ||
        name.text.trim().isEmpty) {
      _error.value = 'All fields are required';
      return;
    }

    _loading.value = true;
    _error.value = '';

    try {
      // 1. Create user in Firebase Auth
      dynamic credential = await _authService.registerUser(
        email: email.text.trim(),
        password: password.text.trim(),
        name: name.text.trim(),
      );

      // 2. Create Firestore profile
      if (credential?.user != null) {
        await _repo.createUser(
          uid: credential!.user!.uid,  // Fixed null safety
          name: name.text.trim(),
          email: email.text.trim(),
        );
      }
      Get.snackbar("Register ", "succesfull");
      // 3. Navigate to login
      print('➡️ [REGISTER] Navigating to /login');
      Get.toNamed('/login');

    } on FirebaseAuthException catch (e) {
      _error.value = _mapFirebaseError(e);
      Get.snackbar(
        'Registration failed',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purple
      );
    } catch (e) {
      _error.value = 'Something went wrong. Please try again.';
      Get.snackbar('Error', _error.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      _loading.value = false;
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters).';
      default:
        return e.message ?? 'Unknown error occurred.';
    }
  }


}
