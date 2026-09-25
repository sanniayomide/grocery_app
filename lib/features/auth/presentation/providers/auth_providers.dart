import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/auth_state.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

final authUserStreamProvider = StreamProvider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(const AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await _repository.currentUser;
    if (user != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = const AuthState(
        status: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
    );
    try {
      final user = await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        user: null,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
    );
    try {
      final user = await _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        user: null,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.signOut();
      state = const AuthState(
        status: AuthStatus.unauthenticated,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Sign out failed. Please try again.',
      );
    }
  }
}
