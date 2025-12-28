import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/bookingModel.dart';
import '../../model/resturantModel.dart';
import '../../model/userModel.dart';
import 'dashboard_repo.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;
  /// Clearing Streams
  StreamSubscription? _bookingSub;

  final RestaurantRepository _repo = RestaurantRepository();

  /// Cached Names and number
  Map<String, String> restaurantNameCache = {};
  Map<String, String> tableNumberCache = {};

  RxBool isLoading = false.obs;
  RxList<Restaurant> restaurants = <Restaurant>[].obs;

  RxList<BookingModel> bookingHistory = <BookingModel>[].obs;
  RxBool isHistoryLoading = false.obs;

  Rx<AppUser?> user = Rx<AppUser?>(null);

  final nameController = RxString("");
  final passwordController = RxString("");
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController currentPasswordTextController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    loadUser();
    loadRestaurants();
    loadUserBookingHistory();
  }

  void changeTab(int index) {
    if (index >= 0 && index <= 2) {
      tabIndex.value = index;
    }
  }
  void gotoBooks(){
    Get.until((route) => route.isFirst);  // Back to root
    Future.delayed(const Duration(milliseconds: 100), () {
      changeTab(1);
    });
  }


  // ---------- CACHE HELPERS ----------
  Future<String?> getRestaurantNameCached(String id) async {
    if (restaurantNameCache.containsKey(id)) return restaurantNameCache[id];
    final name = await _repo.getRestaurantName(id);
    if (name != null) restaurantNameCache[id] = name;
    return name;
  }

  Future<String?> getTableNumberCached(String id) async {
    if (tableNumberCache.containsKey(id)) return tableNumberCache[id];
    final num = await _repo.getTableNumber(id);
    if (num != null) tableNumberCache[id] = num;
    return num;
  }

  /// loadusers
  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      user.value = await _repo.getCurrentUser();

      if (user.value != null) {
        nameController.value = user.value!.name;
        nameTextController.text = user.value!.name;   // <-- sync UI
      }

    } catch (_) {
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed("/welcome");
  }
  Future<void> updateName() async {
    try {
      final newName = nameTextController.text.trim();

      if (newName.isEmpty) {
        Get.snackbar("Invalid", "Name cannot be empty");
        return;
      }

      await _repo.updateName(newName);

      nameController.value = newName;   // keep Rx in sync

      await loadUser();                 // refresh profile

      Get.snackbar("Updated", "Name updated successfully");

    } catch (_) {
      Get.snackbar("Error", "Failed to update name");
    }
  }


  Future<void> changePassword() async {
    try {
      final currentPw = currentPasswordTextController.text.trim();
      final newPw = passwordTextController.text.trim();

      if (currentPw.isEmpty || newPw.isEmpty) {
        Get.snackbar("Invalid", "Both fields are required");
        return;
      }

      await _repo.updatePassword(
        currentPassword: currentPw,
        newPassword: newPw,
      );

      // Clear fields
      currentPasswordTextController.clear();
      passwordTextController.clear();

      Get.snackbar("Success", "Password updated. Please login again");

      // 🔐 Logout after password change
      await logout();

    } catch (e) {
      Get.snackbar("Error", "Password update failed");
    }
  }
  // ---------- RESTAURANTS ----------
  Future<void> loadRestaurants() async {
    try {
      isLoading.value = true;
      restaurants.value = await _repo.fetchRestaurants();
    } catch (_) {
      Get.snackbar("Error", "Failed to load restaurants");
    } finally {
      isLoading.value = false;
    }
  }
  // cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _repo.cancelBooking(bookingId);
      Get.snackbar("Cancelled", "Booking cancelled successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to cancel booking");
    }
  }

  // ---------- BOOKING HISTORY ----------
  Future<void> loadUserBookingHistory() async {
    try {
      // 🔹 CRITICAL: Cancel + clear everything first
      await _bookingSub?.cancel();
      _bookingSub = null;
      bookingHistory.clear();
      isHistoryLoading.value = true;

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        isHistoryLoading.value = false;
        return;
      }

      // 🔹 Fresh stream subscription
      _bookingSub = _repo.listenUserBookings(uid).listen(
            (bookings) {
          // ✅ bookings will be EMPTY [] since collection deleted
          bookingHistory.assignAll(bookings);  // Force replace
          isHistoryLoading.value = false;
        },
        onError: (error) {
          bookingHistory.clear();  // Force empty
          isHistoryLoading.value = false;
        },
      );

    } catch (e) {
      bookingHistory.clear();  // Force empty
      isHistoryLoading.value = false;
    }
  }


}
