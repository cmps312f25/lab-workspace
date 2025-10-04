import '../../domain/entities/department.dart';
import '../../domain/entities/course.dart';
import '../../domain/contracts/academic_repository.dart';
import '../datasources/local/academic_local_data_source_impl.dart';

class AcademicRepositoryImpl implements AcademicRepository {
  final AcademicLocalDataSource localDataSource;

  AcademicRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Department>> getAllDepartments() async {
    try {
      return await localDataSource.getDepartments();
    } catch (e) {
      throw Exception('Failed to load departments: ${e.toString()}');
    }
  }

  @override
  Future<Department?> getDepartmentById(String id) async {
    try {
      final departments = await localDataSource.getDepartments();
      try {
        return departments.firstWhere((dept) => dept.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load department: ${e.toString()}');
    }
  }

  @override
  Future<Department?> getDepartmentByName(String name) async {
    try {
      final departments = await getAllDepartments();
      try {
        return departments.firstWhere(
          (dept) => dept.name.toLowerCase() == name.toLowerCase(),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load department by name: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getAllCourses() async {
    try {
      return await localDataSource.getCourses();
    } catch (e) {
      throw Exception('Failed to load courses: ${e.toString()}');
    }
  }

  @override
  Future<Course?> getCourseByCode(String code) async {
    try {
      final courses = await localDataSource.getCourses();
      try {
        return courses.firstWhere((course) => course.code == code);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load course: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getCoursesByDepartment(String deptCode) async {
    try {
      final courses = await getAllCourses();
      return courses.where((course) => course.deptCode == deptCode).toList();
    } catch (e) {
      throw Exception('Failed to load courses by department: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getCoursesByCredits(int credits) async {
    try {
      final courses = await getAllCourses();
      return courses.where((course) => course.credits == credits).toList();
    } catch (e) {
      throw Exception('Failed to load courses by credits: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> searchCourses(String query) async {
    try {
      final courses = await getAllCourses();
      final lowerQuery = query.toLowerCase();

      return courses
          .where(
            (course) =>
                course.code.toLowerCase().contains(lowerQuery) ||
                course.title.toLowerCase().contains(lowerQuery) ||
                course.deptCode.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search courses: ${e.toString()}');
    }
  }

  @override
  Future<List<Department>> searchDepartments(String query) async {
    try {
      final departments = await getAllDepartments();
      final lowerQuery = query.toLowerCase();

      return departments
          .where(
            (dept) =>
                dept.name.toLowerCase().contains(lowerQuery) ||
                dept.id.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search departments: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalCoursesCount() async {
    try {
      final courses = await getAllCourses();
      return courses.length;
    } catch (e) {
      throw Exception('Failed to get total courses count: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalDepartmentsCount() async {
    try {
      final departments = await getAllDepartments();
      return departments.length;
    } catch (e) {
      throw Exception('Failed to get total departments count: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getCourseCountByDepartment() async {
    try {
      final courses = await getAllCourses();
      final counts = <String, int>{};

      for (final course in courses) {
        counts[course.deptCode] = (counts[course.deptCode] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception(
        'Failed to get course count by department: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<String>> getAvailableDepartmentCodes() async {
    try {
      final courses = await getAllCourses();
      final deptCodes = courses
          .map((course) => course.deptCode)
          .toSet()
          .toList();
      deptCodes.sort();
      return deptCodes;
    } catch (e) {
      throw Exception(
        'Failed to get available department codes: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<int>> getAvailableCreditOptions() async {
    try {
      final courses = await getAllCourses();
      final credits = courses.map((course) => course.credits).toSet().toList();
      credits.sort();
      return credits;
    } catch (e) {
      throw Exception(
        'Failed to get available credit options: ${e.toString()}',
      );
    }
  }
}
