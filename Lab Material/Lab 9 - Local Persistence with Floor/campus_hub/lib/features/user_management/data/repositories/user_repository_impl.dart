import '../../domain/entities/student.dart';
import '../../domain/contracts/user_repository.dart';
import '../datasources/local/user_local_data_source_impl.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Student>> getAllUsers() async {
    try {
      final students = await localDataSource.getStudents();
      return students;
    } catch (e) {
      throw Exception('Failed to load users: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getAllStudents() async {
    try {
      return await localDataSource.getStudents();
    } catch (e) {
      throw Exception('Failed to load students: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getAllTutors() async {
    try {
      final students = await localDataSource.getStudents();
      return students.where((student) => student.isTutor).toList();
    } catch (e) {
      throw Exception('Failed to load tutors: ${e.toString()}');
    }
  }

  @override
  Future<Student?> getUserById(String id) async {
    try {
      final students = await localDataSource.getStudents();
      try {
        return students.firstWhere((s) => s.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load user: ${e.toString()}');
    }
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      final students = await localDataSource.getStudents();
      try {
        return students.firstWhere((s) => s.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load student: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getTutorsByCourse(String courseId) async {
    try {
      final tutors = await getAllTutors();
      return tutors.where((tutor) => tutor.canTutorCourse(courseId)).toList();
    } catch (e) {
      throw Exception('Failed to load tutors by course: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getTutorsByDepartment(String departmentCode) async {
    try {
      final tutors = await getAllTutors();
      return tutors.where((tutor) {
        return tutor.tutoringCoursesList.any(
          (courseId) => courseId.startsWith(departmentCode),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load tutors by department: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getTopRatedTutors({int limit = 10}) async {
    try {
      final tutors = await getAllTutors();
      final topTutors = tutors
          .where((tutor) => tutor.ratings.isNotEmpty)
          .toList();

      topTutors.sort((a, b) => b.averageRating.compareTo(a.averageRating));

      return topTutors.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to load top rated tutors: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> searchTutors(String query) async {
    try {
      final tutors = await getAllTutors();
      final lowerQuery = query.toLowerCase();

      return tutors
          .where(
            (tutor) =>
                tutor.name.toLowerCase().contains(lowerQuery) ||
                (tutor.bio?.toLowerCase().contains(lowerQuery) ?? false) ||
                tutor.major.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search tutors: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getTutorsByMajor(String major) async {
    try {
      final tutors = await getAllTutors();
      return tutors
          .where((tutor) => tutor.major.toLowerCase() == major.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Failed to load tutors by major: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    try {
      final students = await getAllStudents();
      return students
          .where(
            (student) => student.major.toLowerCase() == major.toLowerCase(),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load students by major: ${e.toString()}');
    }
  }

  @override
  Future<List<Student>> getStudentsByYear(int year) async {
    try {
      final students = await getAllStudents();
      return students.where((student) => student.year == year).toList();
    } catch (e) {
      throw Exception('Failed to load students by year: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(Student user) async {
    try {
      await localDataSource.saveStudent(user);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> updateStudentProfile(Student student) async {
    try {
      await localDataSource.saveStudent(student);
    } catch (e) {
      throw Exception('Failed to update student profile: ${e.toString()}');
    }
  }
}
