import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/student.dart';
import '../../../domain/entities/admin.dart';

class UserLocalDataSource {
  Future<List<Student>> getStudents() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/users_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    // Data source should only load raw data, not filter
    return jsonList
        .where((json) => json['role'] == 'student' || json['role'] == 'tutor')
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Admin>> getAdmins() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/users_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    // Data source should only load raw data, not filter
    return jsonList
        .where((json) => json['role'] == 'admin')
        .map((json) => Admin.fromJson(json))
        .toList();
  }

  Future<void> saveStudent(Student student) async {
    // For JSON files, we would need to read, modify, and write back
    // This is a placeholder for now - in a real app you'd implement file writing
    throw UnimplementedError('Saving to JSON files not implemented');
  }
}
