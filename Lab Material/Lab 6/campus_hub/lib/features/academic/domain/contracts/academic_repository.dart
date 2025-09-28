import '../entities/department.dart';
import '../entities/course.dart';

abstract class AcademicRepository {
  // Department operations
  Future<List<Department>> getAllDepartments();
  Future<Department?> getDepartmentById(String id);
  Future<Department?> getDepartmentByName(String name);

  // Course operations
  Future<List<Course>> getAllCourses();
  Future<Course?> getCourseByCode(String code);
  Future<List<Course>> getCoursesByDepartment(String deptCode);
  Future<List<Course>> getCoursesByCredits(int credits);

  // Search operations
  Future<List<Course>> searchCourses(String query);
  Future<List<Department>> searchDepartments(String query);

  // Statistics
  Future<int> getTotalCoursesCount();
  Future<int> getTotalDepartmentsCount();
  Future<Map<String, int>> getCourseCountByDepartment();

  // Business logic
  Future<List<String>> getAvailableDepartmentCodes();
  Future<List<int>> getAvailableCreditOptions();
}
