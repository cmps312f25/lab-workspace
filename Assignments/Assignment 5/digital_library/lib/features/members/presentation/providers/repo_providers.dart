import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/member_repository_impl.dart';
import '../../domain/contracts/member_repository.dart';

/// Member Repository Provider
/// Provides access to the members repository
/// Uses FutureProvider to support async initialization (for future database integration)
final memberRepoProvider = FutureProvider<MemberRepository>((ref) async {
  return MemberRepositoryImpl();
});
