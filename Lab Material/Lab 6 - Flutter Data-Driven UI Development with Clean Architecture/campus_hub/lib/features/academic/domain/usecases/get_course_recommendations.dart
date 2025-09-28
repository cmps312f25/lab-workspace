import '../entities/course.dart';
import '../contracts/academic_repository.dart';
import '../../../user_management/domain/contracts/user_repository.dart';

class GetCourseRecommendations {
  final AcademicRepository academicRepository;
  final UserRepository userRepository;

  GetCourseRecommendations(this.academicRepository, this.userRepository);

  Future<List<Course>> call(String studentId) async {
    // Get student's completed and struggling courses
    final student = await userRepository.getStudentById(studentId);
    if (student == null) return [];

    final allCourses = await academicRepository.getAllCourses();
    final recommendations = <Course>[];

    for (final course in allCourses) {
      // Skip courses already completed
      if (student.hasCompleted(course.code)) continue;

      // Skip courses student is already struggling with
      //why? because we don't want to recommend courses that the student is already struggling wi
      if (student.needsHelpWith(course.code)) continue;

      // Check if prerequisites are met
      bool prerequisitesMet = true;
      for (final prereq in course.prerequisites) {
        if (!student.hasCompleted(prereq)) {
          prerequisitesMet = false;
          break;
        }
      }

      if (!prerequisitesMet) continue;

      // Recommend courses based on student's year and major
      bool shouldRecommend = false;

      // Same department courses
      if (course.deptCode == _getDepartmentCode(student.major)) {
        shouldRecommend = true;
      }

      // Core courses for all students
      if (course.code.startsWith('ENGL') || course.code.startsWith('STAT')) {
        shouldRecommend = true;
      }

      // Level-appropriate courses
      final appropriateLevel = _getCourseLevel(student.year);
      if (course.level == appropriateLevel ||
          (student.year >= 3 && course.level == 'sophomore')) {
        shouldRecommend = true;
      }

      if (shouldRecommend) {
        recommendations.add(course);
      }
    }

    // Sort by level (easier courses first), then by department relevance
    recommendations.sort((a, b) {
      final levelOrder = ['freshman', 'sophomore', 'junior', 'senior'];
      final aIndex = levelOrder.indexOf(a.level);
      final bIndex = levelOrder.indexOf(b.level);

      if (aIndex != bIndex) return aIndex.compareTo(bIndex);

      // Prioritize major-related courses
      final aMajorRelevant = a.deptCode == _getDepartmentCode(student.major);
      final bMajorRelevant = b.deptCode == _getDepartmentCode(student.major);

      if (aMajorRelevant && !bMajorRelevant) return -1;
      if (!aMajorRelevant && bMajorRelevant) return 1;

      return a.code.compareTo(b.code);
    });

    return recommendations.take(10).toList(); // Limit to top 10 recommendations
  }

  String _getDepartmentCode(String major) {
    switch (major.toLowerCase()) {
      case 'computer science':
        return 'CMPS';
      case 'mathematics':
        return 'MATH';
      case 'physics':
        return 'PHYS';
      case 'chemistry':
        return 'CHEM';
      default:
        return '';
    }
  }

  String _getCourseLevel(int year) {
    switch (year) {
      case 1:
        return 'freshman';
      case 2:
        return 'sophomore';
      case 3:
        return 'junior';
      case 4:
      default:
        return 'senior';
    }
  }
}
