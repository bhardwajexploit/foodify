import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/Register/register_repo.dart';
import 'package:flutter/material.dart';

class Authservice {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final RegisterRepo _repo = RegisterRepo();
  String get uID=>_firebaseAuth.currentUser!.uid;

  Future<UserCredential?> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      debugPrint('📧 [AuthService] Creating user: $email');
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ [AuthService] User created! UID: ${credentials.user!.uid}');

      if (credentials.user != null) {
        print('💾 [AuthService] Saving profile to Firestore...');
        await _repo.createUser(
          uid: credentials.user!.uid,
          name: name,
          email: email,
        );
        print('🎉 [AuthService] Profile saved!');
      }

      return credentials; // ✅ Returns UserCredential perfectly
    } on FirebaseAuthException catch (e) {
      // ✅ FIXED: Print the actual exception details
      print('❌ [AuthService] FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow; // Pass error to controller for user-friendly handling
    } catch (e) {
      print('❌ [AuthService] Unknown error: $e');
      rethrow;
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      print('❌ [AuthService] FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow; // Pass error to controller for user-friendly handling
    } catch (e) {
      print('❌ [AuthService] Unknown error: $e');
      rethrow;
    }
  }
}
