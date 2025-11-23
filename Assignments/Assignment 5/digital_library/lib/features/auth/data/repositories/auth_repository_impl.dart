import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class AuthRepositoryImpl implements AuthRepository {
  List<Staff> staffList = [];

  @override
  Future<List<Staff>> getAllStaff() async {
    if (staffList.isEmpty) {
      final String jsonString =
          await rootBundle.loadString('assets/data/staff_json.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      staffList = jsonList.map((json) => Staff.fromJson(json)).toList();
    }
    return staffList;
  }

  @override
  Future<Staff?> getStaffByUsername(String username) async {
    await getAllStaff();
    try {
      return staffList.firstWhere((staff) => staff.username == username);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Staff?> authenticate(String username, String password) async {
    await getAllStaff(); // Ensure data is loaded before checking
    try {
      return staffList.firstWhere(
        (staff) => staff.username == username && staff.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== Stream methods (convert Future to Stream) ====================

  @override
  Stream<List<Staff>> watchAllStaff() async* {
    yield await getAllStaff();
  }

  @override
  Stream<Staff?> watchStaffByUsername(String username) async* {
    yield await getStaffByUsername(username);
  }

  // ==================== CRUD operations ====================

  @override
  Future<void> addStaff(Staff staff) async {
    await getAllStaff();
    if (staffList.any((s) => s.staffId == staff.staffId)) {
      throw Exception('Staff with ID ${staff.staffId} already exists');
    }
    staffList.add(staff);
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    await getAllStaff();
    final index = staffList.indexWhere((s) => s.staffId == staff.staffId);
    if (index == -1) {
      throw Exception('Staff with ID ${staff.staffId} not found');
    }
    staffList[index] = staff;
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    await getAllStaff();
    final index = staffList.indexWhere((s) => s.staffId == staffId);
    if (index == -1) {
      throw Exception('Staff with ID $staffId not found');
    }
    staffList.removeAt(index);
  }
}
