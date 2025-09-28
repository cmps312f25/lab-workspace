import '../entities/student.dart';
import '../contracts/user_repository.dart';

class GetTopRatedTutors {
  final UserRepository repository;

  GetTopRatedTutors(this.repository);

  Future<List<Student>> call({
    int limit = 10,
    int minReviews = 3,
    String? departmentCode,
  }) async {
    var tutors = await repository.getAllTutors();

    // Filter tutors with enough reviews to be considered reliable
    tutors = tutors
        .where((tutor) => tutor.ratings.length >= minReviews)
        .toList();

    // Filter by department if specified
    if (departmentCode != null) {
      tutors = tutors.where((tutor) {
        // Check if tutor teaches any courses in this department
        return tutor.tutoringCourses.any(
          (courseId) => courseId.startsWith(departmentCode),
        );
      }).toList();
    }

    // Sort by average rating, then by number of reviews
    tutors.sort((a, b) {
      final ratingComparison = b.averageRating.compareTo(a.averageRating);
      if (ratingComparison != 0) return ratingComparison;
      return b.ratings.length.compareTo(a.ratings.length);
    });

    // Return top tutors
    return tutors.take(limit).toList();
  }
}
