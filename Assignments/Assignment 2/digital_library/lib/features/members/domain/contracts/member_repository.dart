import '../entities/member.dart';

abstract class MemberRepository {
  /// Get all members
  Future<List<Member>> getAllMembers();

  /// Get a specific member by ID
  /// Throws exception if not found
  Future<Member> getMember(String memberId);

  /// Add a new member
  /// Validates unique ID and email
  Future<void> addMember(Member member);

  /// Update existing member
  Future<void> updateMember(Member member);

  /// Search members by name or email
  Future<List<Member>> searchMembers(String query);
}
