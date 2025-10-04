import 'user.dart';
import '../../../../core/domain/enums/user_role.dart';

class Student extends User {
  final String major;
  final int year;
  final List<String> strugglingCourses; // Courses they need help with
  final List<String> completedCourses; // Courses they've already passed

  // Student-specific fields (role = "student")
  final List<String> achievements;
  final List<String> interests;
  final Map<String, String> studyPreferences;

  // Tutor-specific fields (role = "tutor")
  final String? bio;
  final List<String>
  tutoringCourses; // Courses they can teach (subset of completedCourses)
  final List<double> ratings;

  const Student({
    required super.id,
    required super.role,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.createdAt,
    required this.major,
    required this.year,
    required this.strugglingCourses,
    required this.completedCourses,
    this.achievements = const [],
    this.interests = const [],
    this.studyPreferences = const {},
    this.bio,
    this.tutoringCourses = const [],
    this.ratings = const [],
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      role: UserRole.fromString(json['role'] as String),
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      major: json['major'] as String,
      year: json['year'] as int,
      strugglingCourses: List<String>.from(
        json['strugglingCourses'] as List? ?? [],
      ),
      completedCourses: List<String>.from(
        json['completedCourses'] as List? ?? [],
      ),

      // Student-specific fields
      achievements: json['role'] == 'student'
          ? List<String>.from(json['achievements'] as List? ?? [])
          : const [],
      interests: json['role'] == 'student'
          ? List<String>.from(json['interests'] as List? ?? [])
          : const [],
      studyPreferences: json['role'] == 'student'
          ? Map<String, String>.from(json['studyPreferences'] as Map? ?? {})
          : const {},

      // Tutor-specific fields
      bio: json['bio'] as String?,
      tutoringCourses:
          json['role'] == 'tutor' && json['tutoringCourses'] != null
          ? List<String>.from(json['tutoringCourses'] as List)
          : const [],
      ratings: json['role'] == 'tutor' && json['ratings'] != null
          ? List<double>.from(
              (json['ratings'] as List).map((r) => (r as num).toDouble()),
            )
          : const [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'role': role.value,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'major': major,
      'year': year,
      'strugglingCourses': strugglingCourses,
      'completedCourses': completedCourses,
    };

    if (role == UserRole.student) {
      json.addAll({
        'achievements': achievements,
        'interests': interests,
        'studyPreferences': studyPreferences,
      });
    } else if (role == UserRole.tutor) {
      json.addAll({
        'bio': bio,
        'tutoringCourses': tutoringCourses,
        'ratings': ratings,
      });
    }

    return json;
  }

  bool get isTutor => role == UserRole.tutor;
  bool get isStudent => role == UserRole.student;

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  // Business logic helpers
  bool canTutorCourse(String courseId) {
    return isTutor && tutoringCourses.contains(courseId);
  }

  bool needsHelpWith(String courseId) {
    return strugglingCourses.contains(courseId);
  }

  bool hasCompleted(String courseId) {
    return completedCourses.contains(courseId);
  }

  @override
  String toString() {
    if (isTutor) {
      return 'Tutor(id: $id, name: $name, tutoringCourses: ${tutoringCourses.length}, avgRating: ${averageRating.toStringAsFixed(1)})';
    }
    return 'Student(id: $id, name: $name, major: $major, year: $year, struggling: ${strugglingCourses.length})';
  }
}
