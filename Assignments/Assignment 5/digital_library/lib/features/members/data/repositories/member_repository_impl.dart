import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

class MemberRepositoryImpl implements MemberRepository {
  List<Member>? members;

  /// Load members from JSON file
  Future<List<Member>> _loadMembers() async {
    if (members != null) return members!;

    try {
      final String membersJson =
          await rootBundle.loadString('assets/data/members_json.json');
      final List<dynamic> membersData = json.decode(membersJson);

      // Create Member entities (supports both students and faculty)
      members = membersData
          .map((memberJson) => Member.fromJson(memberJson))
          .toList();

      return members!;
    } catch (e) {
      throw Exception('Failed to load members: $e');
    }
  }

  @override
  Future<List<Member>> getAllMembers() async {
    return await _loadMembers();
  }

  @override
  Future<Member> getMember(String memberId) async {
    final members = await _loadMembers();
    try {
      return members.firstWhere((member) => member.id == memberId);
    } catch (e) {
      throw Exception('Member with ID $memberId not found');
    }
  }

  @override
  Future<void> addMember(Member member) async {
    final members = await _loadMembers();

    // Validate unique ID
    if (members.any((m) => m.id == member.id)) {
      throw Exception('Member with ID ${member.id} already exists');
    }

    // Validate unique email
    if (members.any((m) => m.email == member.email)) {
      throw Exception('Member with email ${member.email} already exists');
    }

    members.add(member);
  }

  @override
  Future<void> updateMember(Member member) async {
    final members = await _loadMembers();
    final index =
        members.indexWhere((m) => m.id == member.id);

    if (index == -1) {
      throw Exception('Member with ID ${member.id} not found');
    }

    members[index] = member;
  }

  @override
  Future<List<Member>> searchMembers(String query) async {
    final members = await _loadMembers();
    final lowerQuery = query.toLowerCase();

    return members.where((member) {
      // Search in name
      if (member.name.toLowerCase().contains(lowerQuery)) return true;

      // Search in email
      if (member.email.toLowerCase().contains(lowerQuery)) return true;

      return false;
    }).toList();
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Member>> watchAllMembers() async* {
    yield await getAllMembers();
  }

  @override
  Stream<Member?> watchMember(String memberId) async* {
    try {
      yield await getMember(memberId);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Member>> watchMembersByType(String memberType) async* {
    final members = await getAllMembers();
    yield members.where((m) => m.memberType == memberType).toList();
  }

  @override
  Stream<List<Member>> watchSearchResults(String query) async* {
    yield await searchMembers(query);
  }

  // ==================== Additional CRUD ====================

  @override
  Future<void> deleteMember(String memberId) async {
    final members = await _loadMembers();
    final index = members.indexWhere((m) => m.id == memberId);

    if (index == -1) {
      throw Exception('Member with ID $memberId not found');
    }

    members.removeAt(index);
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    members = null;
  }
}
