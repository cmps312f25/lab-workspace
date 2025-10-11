import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/faculty_member.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/student_member.dart';

class JsonMemberRepository implements MemberRepository {
  List<Member>? members;

  /// Load members from JSON file
  Future<List<Member>> _loadMembers() async {
    if (members != null) return members!;

    try {
      final String membersJson =
          await rootBundle.loadString('assets/data/members_json.json');
      final List<dynamic> membersData = json.decode(membersJson);

      members = membersData.map((memberJson) {
        final type = memberJson['type'] as String;
        if (type == 'StudentMember') {
          return StudentMember.fromJson(memberJson);
        } else if (type == 'FacultyMember') {
          return FacultyMember.fromJson(memberJson);
        } else {
          throw Exception('Unknown member type: $type');
        }
      }).toList();

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
      return members.firstWhere((member) => member.memberId == memberId);
    } catch (e) {
      throw Exception('Member with ID $memberId not found');
    }
  }

  @override
  Future<void> addMember(Member member) async {
    final members = await _loadMembers();

    // Validate unique ID
    if (members.any((m) => m.memberId == member.memberId)) {
      throw Exception('Member with ID ${member.memberId} already exists');
    }

    // Validate unique email
    if (members.any((m) => m.email == member.email)) {
      throw Exception('Member with email ${member.email} already exists');
    }

    members!.add(member);
  }

  @override
  Future<void> updateMember(Member member) async {
    final members = await _loadMembers();
    final index =
        members.indexWhere((m) => m.memberId == member.memberId);

    if (index == -1) {
      throw Exception('Member with ID ${member.memberId} not found');
    }

    members![index] = member;
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

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    members = null;
  }
}
