import 'dart:async';
import 'package:chat_app/features/auth/domain/contracts/auth_repo.dart';
import 'package:chat_app/features/auth/domain/entities/app_user.dart';
import 'package:chat_app/features/auth/presentation/providers/repo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for authentication
class AuthData {
  final AppUser? user;
  final bool isLoading;

  AuthData({this.user, this.isLoading = false});

  bool get isAuthenticated => user != null;
}

/// AuthNotifier - manages authentication state
/// Day 1: Authentication (signup, login, logout)
class AuthNotifier extends AsyncNotifier<AuthData> {
  AuthRepository get _authRepo => ref.read(authRepoProvider);
  late final StreamSubscription _authSubscription;

  @override
  Future<AuthData> build() async {
    // Listen to auth state changes
    _authSubscription = _authRepo.authStateChanges().listen((user) {
      state = AsyncData(AuthData(user: user));
    });

    // Clean up on dispose
    ref.onDispose(() {
      _authSubscription.cancel();
    });

    // Check if user is already logged in
    final currentUser = _authRepo.currentUser;
    return AuthData(user: currentUser);
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      await _authRepo.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authRepo.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authRepo.signOut();
      state = AsyncData(AuthData());
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for AuthNotifier
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthData>(() => AuthNotifier());
