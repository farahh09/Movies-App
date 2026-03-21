import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? userModel;
  bool isLoading = false;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      String? uid = _auth.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}