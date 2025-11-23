import '../entities/member.dart';

abstract class MemberRepository {
  // ==================== Future-based methods (for JSON repos) ====================

  /// Get all members (one-time fetch)
  Future<List<Member>> getAllMembers();

  /// Get a specific member by ID (one-time fetch)
  /// Throws exception if not found
  Future<Member> getMember(String memberId);

  /// Search members by name or email (one-time fetch)
  Future<List<Member>> searchMembers(String query);

  // ==================== Stream-based methods (for DB repos) ====================

  /// Watch all members (reactive - auto-updates UI)
  Stream<List<Member>> watchAllMembers();

  /// Watch a specific member by ID (reactive - auto-updates UI)
  Stream<Member?> watchMember(String memberId);

  /// Watch members filtered by type (reactive - auto-updates UI)
  Stream<List<Member>> watchMembersByType(String memberType);

  /// Watch members filtered by search query (reactive - auto-updates UI)
  Stream<List<Member>> watchSearchResults(String query);

  // ==================== CRUD operations ====================

  /// Add a new member
  /// Validates unique ID and email
  Future<void> addMember(Member member);

  /// Update existing member
  Future<void> updateMember(Member member);

  /// Delete a member
  Future<void> deleteMember(String memberId);
}
