import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodify/model/bookingModel.dart';
import 'package:foodify/model/userModel.dart';
import '../../model/resturantModel.dart';

class RestaurantRepository {
  final _db = FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  // ---------------- Restaurants ----------------
  Future<List<Restaurant>> fetchRestaurants() async {
    final snapshot = await _db.collection("restaurants").get();
    return snapshot.docs.map((doc) => Restaurant.fromDoc(doc)).toList();
  }

  // ---------------- Booking History ----------------
  Stream<List<BookingModel>> listenUserBookings(String userId) {
    return _db
        .collection("bookings")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => BookingModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> cancelBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "cancelled",
      "cancelledAt": DateTime.now(),
    });
  }

  // ---------------- Lookup Helpers ----------------
  Future<String?> getRestaurantName(String id) async {
    final doc = await _db.collection("restaurants").doc(id).get();
    return doc.data()?["name"];
  }

  Future<String?> getTableNumber(String id) async {
    final doc = await _db.collection("tables").doc(id).get();
    return doc.data()?["tableNumber"];
  }

  Future<AppUser?> getCurrentUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return AppUser.fromMap(doc.id, doc.data()!);
    } catch (e) {
      debugPrint("getCurrentUser error: $e");
      return null; // <<< IMPORTANT
    }
  }


  /// Update name
  Future<void> updateName(String name) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("users").doc(uid).update({
      "name": name,
    });
  }
  ///update pas
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final email = user.email;
    if (email == null) return;

    // ---- Re-authenticate first ----
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // ---- Update Password ----
    await user.updatePassword(newPassword);

    // ---- Force logout after password change ----
    await _auth.signOut();
  }

}
