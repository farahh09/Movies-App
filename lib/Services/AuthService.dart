import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
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
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
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

      await _auth.signInWithCredential(credential);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProfile({required String name, required String photoUrl}) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
      await _auth.currentUser?.updatePhotoURL(photoUrl);
      await _auth.currentUser?.reload();
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') return "re-authenticate";
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}