import '../entities/student.dart';

abstract class UserRepository {
  // Get all users
  Future<List<Student>> getAllUsers();

  // Get users by role
  Future<List<Student>> getAllStudents();
  Future<List<Student>> getAllTutors();

  // Get specific user
  Future<Student?> getUserById(String id);
  Future<Student?> getStudentById(String id);

  // Tutor-specific operations
  Future<List<Student>> getTutorsByCourse(String courseId);
  Future<List<Student>> getTutorsByDepartment(String departmentCode);
  Future<List<Student>> getTopRatedTutors({int limit = 10});
  Future<List<Student>> searchTutors(String query);
  Future<List<Student>> getTutorsByMajor(String major);

  // Student-specific operations
  Future<List<Student>> getStudentsByMajor(String major);
  Future<List<Student>> getStudentsByYear(int year);

  // Update operations
  Future<void> updateUser(Student user);
  Future<void> updateStudentProfile(Student student);
}
