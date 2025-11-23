import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo_providers.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

/// State class to hold authentication state
class AuthState {
  final Staff? currentStaff;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({
    this.currentStaff,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    Staff? currentStaff,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      currentStaff: currentStaff ?? this.currentStaff,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for managing authentication state
class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepo;

  @override
  Future<AuthState> build() async {
    // Get the repository from the provider
    _authRepo = await ref.read(authRepoProvider.future);

    // Load staff data
    await _authRepo.getAllStaff();

    // Initialize with unauthenticated state
    return AuthState();
  }

  /// Authenticate a staff member
  Future<bool> authenticate(String username, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Get repository from provider (in case build() hasn't completed yet)
      final authRepo = await ref.read(authRepoProvider.future);
      final staff = await authRepo.authenticate(username, password);

      if (staff != null) {
        return AuthState(
          currentStaff: staff,
          isAuthenticated: true,
        );
      } else {
        return AuthState(
          errorMessage: 'Invalid username or password',
        );
      }
    });

    // Return true if authentication was successful
    return state.value?.isAuthenticated ?? false;
  }

  /// Logout the current staff member
  void logout() {
    state = AsyncValue.data(AuthState());
  }

  /// Get current staff (convenience method)
  Staff? get currentStaff => state.value?.currentStaff;

  /// Check if user is authenticated (convenience method)
  bool get isAuthenticated => state.value?.isAuthenticated ?? false;
}

/// Provider for auth notifier
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
