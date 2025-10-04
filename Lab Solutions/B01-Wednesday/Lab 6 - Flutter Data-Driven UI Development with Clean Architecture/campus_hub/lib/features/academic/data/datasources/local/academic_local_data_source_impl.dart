import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/department.dart';
import '../../../domain/entities/course.dart';

class AcademicLocalDataSource {
  Future<List<Department>> getDepartments() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/departments_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Department.fromJson(json)).toList();
  }

  Future<List<Course>> getCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/courses_catalog.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Course.fromJson(json)).toList();
  }
}
