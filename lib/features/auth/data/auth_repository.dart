import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../domain/models/app_user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static bool get isFirebaseReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Never _throwFirebaseNotConfigured() {
    throw Exception(
      'Firebase is not configured yet. Open firebase_options.dart and '
      'replace the Android stub values with your real project keys, or run '
      '`flutterfire configure --project=<YOUR_PROJECT_ID>` to regenerate. '
      'You also need android/app/google-services.json from Firebase Console.',
    );
  }

  Stream<AppUser?> authStateChanges() {
    if (!isFirebaseReady) {
      return Stream<AppUser?>.value(null);
    }
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchUserFromFirestore(firebaseUser.uid);
    });
  }

  Future<AppUser?> get currentUser async {
    if (!isFirebaseReady) return null;
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      return _fetchUserFromFirestore(firebaseUser.uid);
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!isFirebaseReady) _throwFirebaseNotConfigured();
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Sign-in failed: no user returned');
      }
      final appUser = await _fetchUserFromFirestore(user.uid);
      if (appUser == null) {
        throw Exception('User profile not found');
      }
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' ||
          e.code == 'not-found' ||
          e.message?.contains('not configured') == true) {
        _throwFirebaseNotConfigured();
      }
      rethrow;
    }
  }

  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!isFirebaseReady) _throwFirebaseNotConfigured();
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Sign-up failed: no user returned');
      }

      final appUser = AppUser(
        uid: user.uid,
        email: user.email ?? email.trim(),
        displayName: displayName.trim(),
        role: UserRole.customer,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(appUser.toFirestore());
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' ||
          e.code == 'not-found' ||
          e.message?.contains('not configured') == true) {
        _throwFirebaseNotConfigured();
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!isFirebaseReady) return;
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  Future<AppUser?> _fetchUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'operation-not-allowed':
        return 'Sign-in with email is not enabled in Firebase Console → Authentication → Sign-in method.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'missing-client-identifier':
      case 'api-key-not-valid':
      case 'invalid-api-key':
        return _firebaseNotConfiguredMessage();
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return 'Authentication failed ($code). Please check your Email or Password.';
    }
  }

  String _firebaseNotConfiguredMessage() {
    return 'Firebase Auth not connected yet. Run `flutterfire configure --project=<YOUR_PROJECT_ID>` '
        'and enable Email/Password sign-in in Firebase Console → Authentication → Sign-in method.';
  }
}
