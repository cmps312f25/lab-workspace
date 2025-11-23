import 'package:chat_app/features/auth/domain/entities/app_user.dart';

/// Abstract repository defining authentication operations.
/// Day 1: Authentication (signup, login, logout)
abstract class AuthRepository {
  /// Get the currently authenticated user (null if not logged in)
  AppUser? get currentUser;

  /// Stream of auth state changes
  Stream<AppUser?> authStateChanges();

  /// Sign up with email and password
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with email and password
  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get user profile from profiles table
  Future<AppUser?> getUserProfile(String userId);

  /// Update user profile
  Future<void> updateUserProfile(AppUser user);
}
