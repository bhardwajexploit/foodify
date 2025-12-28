import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RegisterRepo {
  final FirebaseFirestore _db=FirebaseFirestore.instance;

  Future<void> createUser ({
    required String uid,
    required String name,
    required String email,
}) async {
      await _db.collection("users").doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
  }
  Future<DocumentSnapshot<Map<String, dynamic>>?>  getUser(String uid) async{
    final doc=await _db.collection("users").doc(uid).get();
    return doc.exists? doc : null;
  }

}
