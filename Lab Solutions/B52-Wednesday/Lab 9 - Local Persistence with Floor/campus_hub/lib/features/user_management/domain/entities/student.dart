// TODO: Phase 1.3 - Add Floor Annotations to Student Entity
//
// PART 1: Basic Floor Annotations
// 1. Import the Floor package: import 'package:floor/floor.dart';
// 2. Add @entity annotation above the class (lowercase is fine for Student - no foreign keys needed)
// 3. Add @primaryKey annotation above the 'id' field
//
// Note: Student is a PARENT entity in the relationships:
// - Student (1) → Session (many) - A tutor can have many sessions
// - Student (1) → Booking (many) - A student can make many bookings
//
// Since Student doesn't reference any other entities (it's the "one" side),
// we don't need to add foreign keys here. The foreign keys are defined
// in Session and Booking entities (the "many" side).
//
// Hint: Check Lab 9 document Phase 1.3 for details!

import '../../../../core/domain/enums/user_role.dart';

// TODO: Add @entity annotation here

class Student {
  // TODO: Add @primaryKey annotation here
  final String id;

  // Floor doesn't support enums directly - store as String
  final String role;

  final String name;
  final String email;
  final String password;
  final String? avatarUrl;

  // Floor doesn't support DateTime directly - store as milliseconds
  final int createdAtMillis;

  final String major;
  final int year;

  // Floor doesn't support Lists directly - store as comma-separated Strings
  final String strugglingCourses; // Courses they need help with
  final String completedCourses; // Courses they've already passed

  // Student-specific fields (role = "student")
  final String achievements;
  final String interests;
  final String studyPreferences; // JSON string

  // Tutor-specific fields (role = "tutor")
  final String? bio;
  final String tutoringCourses; // Courses they can teach (subset of completedCourses)
  final String ratings; // Comma-separated ratings

  const Student({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
    required this.createdAtMillis,
    required this.major,
    required this.year,
    required this.strugglingCourses,
    required this.completedCourses,
    this.achievements = '',
    this.interests = '',
    this.studyPreferences = '{}',
    this.bio,
    this.tutoringCourses = '',
    this.ratings = '',
  });

  // Helper getters for convenient access
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
  UserRole get userRole => UserRole.fromString(role);

  List<String> get strugglingCoursesList =>
      strugglingCourses.isEmpty ? [] : strugglingCourses.split(',');
  List<String> get completedCoursesList =>
      completedCourses.isEmpty ? [] : completedCourses.split(',');
  List<String> get achievementsList =>
      achievements.isEmpty ? [] : achievements.split(',');
  List<String> get interestsList =>
      interests.isEmpty ? [] : interests.split(',');
  List<String> get tutoringCoursesList =>
      tutoringCourses.isEmpty ? [] : tutoringCourses.split(',');
  List<double> get ratingsList =>
      ratings.isEmpty ? [] : ratings.split(',').map((r) => double.parse(r)).toList();

  // Factory for creating from native types
  factory Student.create({
    required String id,
    required UserRole role,
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
    required DateTime createdAt,
    required String major,
    required int year,
    required List<String> strugglingCourses,
    required List<String> completedCourses,
    List<String> achievements = const [],
    List<String> interests = const [],
    Map<String, String> studyPreferences = const {},
    String? bio,
    List<String> tutoringCourses = const [],
    List<double> ratings = const [],
  }) {
    return Student(
      id: id,
      role: role.value,
      name: name,
      email: email,
      password: password,
      avatarUrl: avatarUrl,
      createdAtMillis: createdAt.millisecondsSinceEpoch,
      major: major,
      year: year,
      strugglingCourses: strugglingCourses.join(','),
      completedCourses: completedCourses.join(','),
      achievements: achievements.join(','),
      interests: interests.join(','),
      studyPreferences: studyPreferences.toString(),
      bio: bio,
      tutoringCourses: tutoringCourses.join(','),
      ratings: ratings.map((r) => r.toString()).join(','),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] is String
        ? json['role'] as String
        : (json['role'] as UserRole).value;

    return Student(
      id: json['id'] as String,
      role: roleStr,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAtMillis: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String).millisecondsSinceEpoch
          : json['createdAtMillis'] as int,
      major: (json['major'] as String?) ?? 'Unknown',
      year: (json['year'] as int?) ?? 1,
      strugglingCourses: json['strugglingCourses'] is String
          ? json['strugglingCourses'] as String
          : (json['strugglingCourses'] as List).cast<String>().join(','),
      completedCourses: json['completedCourses'] is String
          ? json['completedCourses'] as String
          : (json['completedCourses'] as List).cast<String>().join(','),

      // Student-specific fields
      achievements: json['role'] == 'student' && json['achievements'] != null
          ? (json['achievements'] is String
              ? json['achievements'] as String
              : (json['achievements'] as List).cast<String>().join(','))
          : '',
      interests: json['role'] == 'student' && json['interests'] != null
          ? (json['interests'] is String
              ? json['interests'] as String
              : (json['interests'] as List).cast<String>().join(','))
          : '',
      studyPreferences: json['role'] == 'student' && json['studyPreferences'] != null
          ? (json['studyPreferences'] is String
              ? json['studyPreferences'] as String
              : (json['studyPreferences'] as Map).toString())
          : '{}',

      // Tutor-specific fields
      bio: json['bio'] as String?,
      tutoringCourses: json['role'] == 'tutor' && json['tutoringCourses'] != null
          ? (json['tutoringCourses'] is String
              ? json['tutoringCourses'] as String
              : (json['tutoringCourses'] as List).cast<String>().join(','))
          : '',
      ratings: json['role'] == 'tutor' && json['ratings'] != null
          ? (json['ratings'] is String
              ? json['ratings'] as String
              : (json['ratings'] as List)
                  .map((r) => (r as num).toDouble())
                  .join(','))
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'role': role,
      'name': name,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'major': major,
      'year': year,
      'strugglingCourses': strugglingCoursesList,
      'completedCourses': completedCoursesList,
    };

    if (role == 'student') {
      json.addAll({
        'achievements': achievementsList,
        'interests': interestsList,
        'studyPreferences': studyPreferences,
      });
    } else if (role == 'tutor') {
      json.addAll({
        'bio': bio,
        'tutoringCourses': tutoringCoursesList,
        'ratings': ratingsList,
      });
    }

    return json;
  }

  bool get isTutor => userRole == UserRole.tutor;
  bool get isStudent => userRole == UserRole.student;

  double get averageRating {
    final ratingList = ratingsList;
    if (ratingList.isEmpty) return 0.0;
    return ratingList.reduce((a, b) => a + b) / ratingList.length;
  }

  // Business logic helpers
  bool canTutorCourse(String courseId) {
    return isTutor && tutoringCoursesList.contains(courseId);
  }

  bool needsHelpWith(String courseId) {
    return strugglingCoursesList.contains(courseId);
  }

  bool hasCompleted(String courseId) {
    return completedCoursesList.contains(courseId);
  }

  @override
  String toString() {
    if (isTutor) {
      return 'Tutor(id: $id, name: $name, tutoringCourses: ${tutoringCoursesList.length}, avgRating: ${averageRating.toStringAsFixed(1)})';
    }
    return 'Student(id: $id, name: $name, major: $major, year: $year, struggling: ${strugglingCoursesList.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
