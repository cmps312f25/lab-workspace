import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

class MemberRepositoryImpl implements MemberRepository {
  final Dio _dio;

  // In-memory storage - loaded once from JSON and then modified in memory
  List<Member>? _cachedMembers;

  MemberRepositoryImpl(this._dio);

  Future<List<Member>> _loadMembersFromJson() async {
    // Return cached data if already loaded
    if (_cachedMembers != null) {
      return _cachedMembers!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/members_json.json');
      final List<dynamic> data = json.decode(jsonString) as List;
      _cachedMembers = data.map((json) => Member.fromJson(json)).toList();
      return _cachedMembers!;
    } catch (e) {
      throw Exception('Failed to load members from JSON: $e');
    }
  }

  @override
  Future<List<Member>> getAllMembers() async {
    try {
      return await _loadMembersFromJson();
    } catch (e) {
      throw Exception('Failed to fetch members: $e');
    }
  }

  @override
  Future<Member> getMember(String id) async {
    try {
      final members = await _loadMembersFromJson();
      final member = members.firstWhere(
        (member) => member.id == id,
        orElse: () => throw Exception('Member with ID $id not found'),
      );
      return member;
    } catch (e) {
      throw Exception('Failed to fetch member: $e');
    }
  }

  @override
  Future<List<Member>> searchMembers(String query) async {
    try {
      final members = await _loadMembersFromJson();

      final lowerQuery = query.toLowerCase();
      return members.where((member) {
        if (member.name.toLowerCase().contains(lowerQuery)) return true;
        if (member.email.toLowerCase().contains(lowerQuery)) return true;
        return false;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search members: $e');
    }
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Member>> watchAllMembers() async* {
    yield await getAllMembers();
  }

  @override
  Stream<Member?> watchMember(String id) async* {
    try {
      yield await getMember(id);
    } catch (e) {
      yield null;
    }
  }

  @override
  Stream<List<Member>> watchMembersByType(String memberType) async* {
    try {
      final members = await _loadMembersFromJson();

      yield members.where((member) => member.memberType == memberType).toList();
    } catch (e) {
      yield [];
    }
  }

  @override
  Stream<List<Member>> watchSearchResults(String query) async* {
    yield await searchMembers(query);
  }

  // ==================== CRUD operations (In-Memory) ====================

  @override
  Future<void> addMember(Member member) async {
    try {
      final members = await _loadMembersFromJson();
      members.add(member);
      _cachedMembers = members;
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  @override
  Future<void> updateMember(Member member) async {
    try {
      final members = await _loadMembersFromJson();
      final index = members.indexWhere((m) => m.id == member.id);

      if (index == -1) {
        throw Exception('Member with ID ${member.id} not found');
      }

      members[index] = member;
      _cachedMembers = members;
    } catch (e) {
      throw Exception('Failed to update member: $e');
    }
  }

  @override
  Future<void> deleteMember(String id) async {
    try {
      final members = await _loadMembersFromJson();
      final initialLength = members.length;
      members.removeWhere((m) => m.id == id);

      if (members.length == initialLength) {
        throw Exception('Member with ID $id not found');
      }

      _cachedMembers = members;
    } catch (e) {
      throw Exception('Failed to delete member: $e');
    }
  }
}
