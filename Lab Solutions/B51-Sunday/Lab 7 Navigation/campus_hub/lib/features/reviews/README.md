# Reviews Feature

This feature handles review and rating operations in the Campus Hub app, including creating, managing, and querying reviews for tutoring sessions.

## 📁 File Structure

```
reviews/
├── domain/
│   ├── entities/
│   │   └── review.dart           # Review entity
│   ├── contracts/
│   │   └── review_repository.dart # Repository interface
│   └── usecases/
│       └── (no use cases implemented yet)
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── review_local_data_source.dart      # Data source interface
│   │       └── review_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── review_repository_impl.dart            # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### Review Entity
Represents a student's review and rating for a tutoring session.

```dart
class Review {
  final String id;           // Unique review identifier
  final String bookingId;     // ID of the booking being reviewed
  final String studentId;     // ID of the student who wrote the review
  final String tutorId;       // ID of the tutor being reviewed
  final String sessionId;     // ID of the session being reviewed
  final double rating;        // Rating (1.0 to 5.0)
  final String comment;       // Written review comment
  final DateTime createdAt;   // When the review was created
}
```

**Key Methods**:
```dart
bool get isPositive => rating >= 4.0;
bool get isNegative => rating <= 2.0;
bool get isNeutral => rating > 2.0 && rating < 4.0;
String get ratingText => _getRatingText(rating);
```

**JSON Serialization**:
```dart
factory Review.fromJson(Map<String, dynamic> json);
Map<String, dynamic> toJson();
```

## 🔌 Repository Interface

### ReviewRepository
```dart
abstract class ReviewRepository {
  // Basic CRUD operations
  Future<List<Review>> getReviews();
  Future<Review?> getReviewById(String id);
  Future<void> saveReview(Review review);
  Future<void> updateReview(Review review);
  Future<void> deleteReview(String id);
  
  // Query operations
  Future<List<Review>> getReviewsByTutor(String tutorId);
  Future<List<Review>> getReviewsByBooking(String bookingId);
  Future<List<Review>> getReviewsByStudent(String studentId);
  Future<List<Review>> getReviewsByRating(double minRating);
  Future<List<Review>> getReviewsBySession(String sessionId);
  
  // Statistics and analytics
  Future<double> getTutorAverageRating(String tutorId);
  Future<int> getTutorReviewCount(String tutorId);
  Future<ReviewStatistics> getReviewStatistics(String tutorId);
}
```

## 🎯 Use Cases Documentation

**Note**: All simple pass-through use cases have been removed. Reviews feature now relies on direct repository calls for simple operations and complex business logic is handled in the repository implementations.

## 💾 Data Source Implementation

### ReviewLocalDataSource
**Purpose**: Interface for local review data access.

**Methods**:
```dart
Future<List<Review>> getReviews();  // Loads all reviews
Future<void> saveReview(Review review);
Future<void> updateReview(Review review);
Future<void> deleteReview(String id);
```

**Architecture Principle**: Data source is "dumb" - only loads raw data, no filtering or business logic.

### ReviewLocalDataSourceImpl
**Purpose**: JSON file implementation of review data source.

**Data Source**: `assets/json/reviews_sample.json`

**Key Features**:
- Loads raw review data from JSON assets
- Parses JSON to Review entities
- Handles data parsing errors
- **No business logic** - only data loading

**Error Handling**:
- Catches JSON parsing errors
- Returns `DataParsingFailure` for invalid data
- Logs errors for debugging

**JSON Structure**:
```json
[
  {
    "id": "r1",
    "bookingId": "b1",
    "studentId": "202205001",
    "tutorId": "202205023",
    "sessionId": "9b23c852",
    "rating": 5.0,
    "comment": "Excellent explanation of Flutter widgets!",
    "createdAt": "2025-10-06T10:00:00Z"
  }
]
```

## 🔄 Repository Implementation

### ReviewRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `ReviewLocalDataSource` - For data access

**Key Features**:
- Implements all repository interface methods
- **Handles all business logic** (filtering, sorting, validation)
- Coordinates data sources
- Returns processed results

**Business Logic Examples**:
- **ID Lookup**: Searches through loaded data to find specific reviews
- **Rating Filtering**: Filters reviews by rating ranges
- **Date Filtering**: Filters by creation dates
- **Tutor Filtering**: Filters by tutor ID
- **Student Filtering**: Filters by student ID
- **Statistics Calculation**: Computes rating averages and distributions

**Architecture Principle**: Repository handles all business logic, data source only loads raw data.

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON File
5. **Results** ← JSON File ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Rating Range**: Ratings must be between 1.0 and 5.0
2. **One Review Per Booking**: Each booking can have only one review
3. **Review Timing**: Reviews can only be created after session completion
4. **Tutor Validation**: Reviews must reference valid tutors
5. **Student Validation**: Reviews must reference valid students
6. **Comment Length**: Comments have maximum length limits

## 🚀 Usage Examples

```dart
// Get tutor's reviews with high ratings
final highRatedReviews = await getReviewsByRatingUseCase.call(
  GetReviewsByRatingParams(
    minRating: 4.0,
    maxRating: 5.0,
    tutorId: "202205023",
    sortBy: "rating",
  ),
);

// Get tutor's average rating
final averageRating = await getTutorAverageRatingUseCase.call(
  GetTutorAverageRatingParams(
    tutorId: "202205023",
    minReviews: 3,
  ),
);

// Get review statistics
final statistics = await getReviewStatisticsUseCase.call(
  GetReviewStatisticsParams(
    tutorId: "202205023",
    timeRange: DateRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    ),
  ),
);
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: Review class
- **User Management**: For tutor and student validation
- **Booking Management**: For booking validation

## 📈 Performance Considerations

- **Caching**: Reviews are loaded once and cached
- **Filtering**: Business logic filters are applied efficiently
- **Sorting**: Results are sorted by specified criteria
- **Memory**: Large review lists are handled efficiently
- **Statistics**: Rating calculations are optimized

## 🛡️ Error Handling

- **Data Parsing**: Handles malformed JSON data
- **Validation**: Validates review data integrity
- **Business Logic**: Validates business rules
- **Rating Validation**: Ensures ratings are within valid range

## 🔄 Future Enhancements

- **Review Moderation**: Admin review moderation system
- **Review Responses**: Tutor responses to reviews
- **Review Analytics**: Advanced analytics and insights
- **Review Templates**: Pre-defined review templates
- **Review Notifications**: Automated review reminders
