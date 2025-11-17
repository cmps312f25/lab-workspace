import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/contracts/auth_repository.dart';

/// Auth Repository Provider
/// Provides access to the authentication repository
/// Uses hardcoded credentials - no API calls needed
final authRepoProvider = FutureProvider<AuthRepository>((ref) async {
  return AuthRepositoryImpl();
});
