import 'dart:async';
import 'package:chat_app/features/auth/domain/contracts/auth_repo.dart';
import 'package:chat_app/features/auth/domain/entities/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of AuthRepository using Supabase Auth.
///
/// YOUR TASK: Implement the authentication methods below.
///
/// Supabase Auth provides:
/// - _client.auth.signUp(email:, password:, data:) - Create new account
/// - _client.auth.signInWithPassword(email:, password:) - Login existing user
/// - _client.auth.signOut() - Logout current user
/// - _client.auth.currentUser - Get currently logged in user
/// - _client.auth.onAuthStateChange - Stream of auth state changes
class AuthRepoImpl implements AuthRepository {
  final SupabaseClient _client;
  final String profilesTable = "profiles";

  // _client.auth.currentUser;

  AuthRepoImpl(this._client);

  /// Get the currently logged in user (already implemented for you)
  @override
  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return AppUser(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
    );
  }

  /// Stream of auth state changes (already implemented for you)
  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      if (user == null) return null;

      return AppUser(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
      );
    });
  }

  /// TODO 1: Implement Sign Up
  ///
  /// Steps:
  /// 1. Call _client.auth.signUp() with email, password, and data (display_name)
  /// 2. Check if user was returned, throw exception if not
  /// 3. Create an AppUser object with the user's info
  /// 4. Insert the user profile into the 'profiles' table using _client.from(profilesTable).insert()
  /// 5. Return the AppUser
  ///
  /// Hint: Use appUser.toJson() when inserting into the database
  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // TODO: Implement sign up
    // 1. Call _client.auth.signUp(email: email, password: password, data: {'display_name': displayName})
    // 2. Get the user from response.user
    // 3. Create AppUser and insert into profiles table
    // 4. Return the AppUser
    try {
      // step 1 : to create the user with email , password and name
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      if (response.user == null) {
        throw ("Unable to signup the user");
      }

      // we successfully created the user so now let us return the user
      // that was created in the database
      final appUser = AppUser(
        id: response.user!.id,
        email: email,
        displayName: response.user!.appMetadata['display_name'],
      );

      // we need to add this user to the profile table
      await _client.from(profilesTable).insert(appUser.toJson());

      return appUser;
    } catch (e) {
      throw ("Unable to register the user $e");
    }
  }

  /// TODO 2: Implement Sign In
  ///
  /// Steps:
  /// 1. Call _client.auth.signInWithPassword() with email and password
  /// 2. Check if user was returned, throw exception if not
  /// 3. Create and return an AppUser object with the user's info
  ///
  /// Hint: User metadata contains 'display_name' at user.userMetadata?['display_name']
  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    // TODO: Implement sign in
    // 1. Call _client.auth.signInWithPassword(email: email, password: password)
    // 2. Get the user from response.user
    // 3. Return AppUser with the user's info
    try {
      // step 1 : to create the user with email , password and name
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ("Unable to signup the user");
      }

      // we successfully created the user so now let us return the user
      // that was created in the database
      final appUser = AppUser(
        id: response.user!.id,
        email: email,
        displayName: response.user!.appMetadata['display_name'],
      );

      return appUser;
    } catch (e) {
      throw ("Unable to register the user $e");
    }
  }

  /// TODO 3: Implement Sign Out
  ///
  /// Steps:
  /// 1. Call _client.auth.signOut()
  ///
  /// This is the simplest one - just one line of code!
  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get user profile from database (already implemented for you)
  @override
  Future<AppUser?> getUserProfile(String userId) async {
    try {
      final data = await _client
          .from(profilesTable)
          .select()
          .eq('id', userId)
          .single();
      return AppUser.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Update user profile in database (already implemented for you)
  @override
  Future<void> updateUserProfile(AppUser user) async {
    try {
      await _client.from(profilesTable).update(user.toJson()).eq('id', user.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
