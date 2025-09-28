import '../entities/user.dart';
import '../entities/student.dart';
import '../entities/admin.dart';

abstract class UserRepository {
  // Get all users
  Future<List<User>> getAllUsers();

  // Get users by role
  Future<List<Student>> getAllStudents();
  Future<List<Student>> getAllTutors();
  Future<List<Admin>> getAllAdmins();

  // Get specific user
  Future<User?> getUserById(String id);
  Future<Student?> getStudentById(String id);
  Future<Admin?> getAdminById(String id);

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
  Future<void> updateUser(User user);
  Future<void> updateStudentProfile(Student student);
}
