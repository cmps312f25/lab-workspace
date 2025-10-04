# User Management Feature

This feature handles all user-related operations in the Campus Hub tutoring app, including students, tutors, and admins.

## 📁 File Structure

```
user_management/
├── domain/
│   ├── entities/
│   │   ├── user.dart              # Abstract base class for all users
│   │   ├── student.dart           # Student/Tutor entity (extends User)
│   │   └── admin.dart             # Admin entity (extends User)
│   ├── contracts/
│   │   └── user_repository.dart   # Repository interface
│   └── usecases/
│       └── get_top_rated_tutors.dart # Get highest rated tutors
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── user_local_data_source.dart      # Data source interface
│   │       └── user_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── user_repository_impl.dart            # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### User (Abstract Base Class)
```dart
abstract class User {
  final String id;
  final String role;        // "student", "tutor", "admin"
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
}
```

### Student Entity
Represents both regular students and tutors (tutors are students with role="tutor").

**Key Fields:**
- `major`: Student's academic major
- `year`: Academic year (1-4)
- `strugglingCourses`: Courses the student needs help with
- `completedCourses`: Courses the student has passed
- `tutoringCourses`: Courses the student can tutor (tutors only)
- `ratings`: List of ratings received (tutors only)
- `bio`: Tutor's description (tutors only)

**Key Methods:**
```dart
bool get isTutor => role == 'tutor';
bool get isStudent => role == 'student';
double get averageRating; // For tutors
bool canTutorCourse(String courseId);
bool needsHelpWith(String courseId);
bool hasCompleted(String courseId);
```

### Admin Entity
```dart
class Admin extends User {
  final List<String> permissions;
}
```

## 🔌 Repository Interface

### UserRepository
```dart
abstract class UserRepository {
  // Basic CRUD operations
  Future<List<Student>> getStudents();
  Future<List<Student>> getTutors();
  Future<List<Admin>> getAdmins();
  Future<Student?> getStudentById(String id);
  Future<Admin?> getAdminById(String id);
  
  // Search and filtering
  Future<List<Student>> searchTutors(String query);
  Future<List<Student>> getTutorsByCourse(String courseId);
  Future<List<Student>> getTutorsByDepartment(String departmentId);
  Future<List<Student>> getTopRatedTutors({int minReviews = 5});
  Future<List<Student>> getStrugglingStudents();
  
  // Tutor-specific operations
  Future<double> getTutorAverageRating(String tutorId);
  Future<List<Student>> getTutorsByRating(double minRating);
}
```

## 🎯 Use Cases Documentation

### GetTopRatedTutors
**Purpose**: Get highest-rated tutors with complex filtering and ranking logic.

**Parameters**:
- `limit`: Maximum number of tutors to return (default: 10)
- `minReviews`: Minimum number of reviews required (default: 3)
- `departmentCode`: Optional department filter

**Returns**: `Future<List<Student>>` - Top-rated tutors

**Business Logic**:
- Filters tutors with sufficient reviews for reliability
- Applies department filtering by checking tutoring courses
- Sorts by average rating, then by number of reviews
- Returns top tutors based on comprehensive criteria

**Complexity**: Multi-criteria filtering, sorting, and ranking logic that cannot be achieved with a single repository call.

## 💾 Data Source Implementation

### UserLocalDataSource
**Purpose**: Interface for local data access operations.

**Methods**:
```dart
Future<List<Student>> getStudents();  // Loads all students/tutors
Future<List<Admin>> getAdmins();      // Loads all admins
Future<void> saveStudent(Student student); // Saves student data
```

**Architecture Principle**: Data source is "dumb" - only loads raw data, no filtering or business logic.

### UserLocalDataSourceImpl
**Purpose**: JSON file implementation of data source.

**Data Source**: `assets/json/users_sample.json`

**Key Features**:
- Loads raw data from JSON assets
- Parses JSON to entity objects
- Handles data parsing errors
- **No business logic** - only data loading

**Error Handling**:
- Catches JSON parsing errors
- Returns `DataParsingFailure` for invalid data
- Logs errors for debugging

## 🔄 Repository Implementation

### UserRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `UserLocalDataSource` - For data access

**Key Features**:
- Implements all repository interface methods
- **Handles all business logic** (filtering, sorting, validation)
- Coordinates data sources
- Returns processed results

**Business Logic Examples**:
- **Tutor Filtering**: Filters students by `isTutor` property
- **ID Lookup**: Searches through loaded data to find specific users
- **Search**: Filters by name, major, email
- **Rating Filter**: Applies minimum rating requirements
- **Course Filter**: Ensures tutors can teach specific courses
- **Sorting**: Sorts by rating, name, or year

**Architecture Principle**: Repository handles all business logic, data source only loads raw data.

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON File
5. **Results** ← JSON File ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Tutor Validation**: Only students with `role="tutor"` can be tutors
2. **Course Teaching**: Tutors can only teach courses in their `tutoringCourses` list
3. **Rating Calculation**: Average rating calculated from `ratings` list
4. **Student Help**: Students with `strugglingCourses` need academic assistance
5. **Admin Permissions**: Admins have specific permission lists

## 🚀 Usage Examples

```dart
// Search for Flutter tutors
final tutors = await searchTutorsUseCase.call(
  SearchTutorsParams(
    query: "Flutter",
    courseId: "CMPS312",
    minRating: 4.0,
    sortBy: "rating",
  ),
);

// Get top-rated CS tutors
final topTutors = await getTopRatedTutorsUseCase.call(
  GetTopRatedTutorsParams(
    minReviews: 10,
    departmentId: "dept_cs",
    limit: 5,
  ),
);

// Find students needing help
final strugglingStudents = await getStrugglingStudentsUseCase.call();
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: User, Student, Admin classes
