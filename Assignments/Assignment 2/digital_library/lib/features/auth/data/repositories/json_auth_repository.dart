import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class JsonAuthRepository implements AuthRepository {
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
  Staff? authenticate(String username, String password) {
    try {
      return staffList.firstWhere(
        (staff) => staff.username == username && staff.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
