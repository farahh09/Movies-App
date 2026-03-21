import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  User? get currentUser => _auth.currentUser;

  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String imagePath,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.updatePhotoURL(imagePath);

        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': name,
          'email': email,
          'phone_number': phone,
          'image_path': imagePath,
          'watch_list': 0,
          'watch_history': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await credential.user!.reload();
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "Cancelled";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? "User",
          'email': userCredential.user!.email,
          'phone_number': userCredential.user!.phoneNumber ?? "",
          'image_path': userCredential.user!.photoURL ?? "assets/images/gamer (1) (1).png",
          'watch_list': 0,
          'watch_history': 0,
        }, SetOptions(merge: true));
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? "Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<String?> updatePasswordWithOtp({
    required String otp,
    required String newPassword,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await userCredential.user!.updatePassword(newPassword);
        return "success";
      }
      return "User not found";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProfile({required String name, required String photoUrl}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.updatePhotoURL(photoUrl);

        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'image_path': photoUrl,
        });

        await user.reload();
        return "success";
      }
      return "User not logged in";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
        return "success";
      }
      return "User not logged in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-auth') return "re-authenticate";
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> incrementCounter(String fieldName) async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        fieldName: FieldValue.increment(1),
      });
    }
  }
}