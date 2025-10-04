# Academic Feature

This feature handles academic data operations in the Campus Hub app, including departments, courses, and academic recommendations.

## 📁 File Structure

```
academic/
├── domain/
│   ├── entities/
│   │   ├── department.dart       # Department entity
│   │   └── course.dart          # Course entity
│   ├── contracts/
│   │   └── academic_repository.dart # Repository interface
│   └── usecases/
│       └── get_course_recommendations.dart # Get course recommendations
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── academic_local_data_source.dart      # Data source interface
│   │       └── academic_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── academic_repository_impl.dart            # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### Department Entity
Represents an academic department at Qatar University.

```dart
class Department {
  final String id;           // Department identifier (e.g., "dept_cs")
  final String name;         // Department name (e.g., "Computer Science Department")
  final String? iconUrl;     // Department icon URL
  final String? description;  // Department description
}
```

**Key Methods**:
```dart
bool get hasIcon => iconUrl != null;
bool get hasDescription => description != null;
String get displayName => name;
```

**JSON Serialization**:
```dart
factory Department.fromJson(Map<String, dynamic> json);
Map<String, dynamic> toJson();
```

### Course Entity
Represents an academic course offered by the university.

```dart
class Course {
  final String code;           // Course code (e.g., "CMPS312")
  final String title;          // Course title (e.g., "Mobile Application Development")
  final String deptCode;       // Department code (e.g., "CMPS")
  final int credits;           // Credit hours
  final String level;          // Academic level ("freshman", "sophomore", "junior", "senior")
  final List<String> prerequisites; // Required prerequisite courses
}
```

**Key Methods**:
```dart
bool get isFreshmanLevel => level == "freshman";
bool get isSophomoreLevel => level == "sophomore";
bool get isJuniorLevel => level == "junior";
bool get isSeniorLevel => level == "senior";
bool get hasPrerequisites => prerequisites.isNotEmpty;
bool get isAdvanced => isJuniorLevel || isSeniorLevel;
bool get isIntroductory => isFreshmanLevel || isSophomoreLevel;
```

**JSON Serialization**:
```dart
factory Course.fromJson(Map<String, dynamic> json);
Map<String, dynamic> toJson();
```

## 🔌 Repository Interface

### AcademicRepository
```dart
abstract class AcademicRepository {
  // Department operations
  Future<List<Department>> getDepartments();
  Future<Department?> getDepartmentById(String id);
  Future<List<Department>> getDepartmentsByCode(String code);
  
  // Course operations
  Future<List<Course>> getCourses();
  Future<Course?> getCourseByCode(String code);
  Future<List<Course>> getCoursesByDepartment(String departmentId);
  Future<List<Course>> getCoursesByLevel(String level);
  Future<List<Course>> getCoursesByCredits(int credits);
  
  // Search and filtering
  Future<List<Course>> searchCourses(String query);
  Future<List<Course>> getCoursesByPrerequisites(List<String> prerequisites);
  Future<List<Course>> getRecommendedCourses(String studentId);
}
```

## 🎯 Use Cases Documentation

### GetCourseRecommendations
**Purpose**: Get personalized course recommendations for a student.

**Parameters**:
- `studentId`: Student identifier
- `major`: Student's major (optional)
- `year`: Student's academic year (optional)
- `completedCourses`: List of completed courses (optional)
- `strugglingCourses`: List of struggling courses (optional)

**Returns**: `Future<List<Course>>` - Recommended courses

**Business Logic**:
1. **Prerequisite Analysis**:
   - Identifies courses the student can take based on completed prerequisites
   - Excludes courses with unmet prerequisites
   - Prioritizes courses relevant to student's major

2. **Academic Level Matching**:
   - Recommends courses appropriate for student's year
   - Suggests introductory courses for struggling students
   - Proposes advanced courses for high-performing students

3. **Major Alignment**:
   - Prioritizes courses in student's major department
   - Suggests complementary courses from related departments
   - Balances core and elective recommendations

**Use Cases**:
- Academic planning
- Course selection assistance
- Prerequisite tracking
- Major progression


## 💾 Data Source Implementation

### AcademicLocalDataSource
**Purpose**: Interface for local academic data access.

**Methods**:
```dart
Future<List<Department>> getDepartments();  // Loads all departments
Future<List<Course>> getCourses();          // Loads all courses
```

**Architecture Principle**: Data source is "dumb" - only loads raw data, no filtering or business logic.

### AcademicLocalDataSourceImpl
**Purpose**: JSON file implementation of academic data source.

**Data Sources**: 
- `assets/json/departments_sample.json` - Department data
- `assets/json/courses_catalog.json` - Course data

**Key Features**:
- Loads raw academic data from JSON assets
- Parses JSON to entity objects
- Handles data parsing errors
- **No business logic** - only data loading

**Error Handling**:
- Catches JSON parsing errors
- Returns `DataParsingFailure` for invalid data
- Logs errors for debugging

**JSON Structure - Departments**:
```json
[
  {
    "id": "dept_cs",
    "name": "Computer Science Department",
    "iconUrl": "https://www.flaticon.com/svg/v2/svg/1055/1055666.svg",
    "description": "Programming, software development, and computer systems"
  }
]
```

**JSON Structure - Courses**:
```json
[
  {
    "code": "CMPS312",
    "title": "Mobile Application Development",
    "deptCode": "CMPS",
    "credits": 3,
    "level": "junior",
    "prerequisites": ["CMPS251", "CMPS151"]
  }
]
```

## 🔄 Repository Implementation

### AcademicRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `AcademicLocalDataSource` - For data access

**Key Features**:
- Implements all repository interface methods
- **Handles all business logic** (filtering, sorting, validation)
- Coordinates data sources
- Returns processed results

**Business Logic Examples**:
- **ID Lookup**: Searches through loaded data to find specific departments/courses
- **Course Filtering**: Filters courses by department, level, credits
- **Prerequisite Analysis**: Analyzes course prerequisites
- **Search Logic**: Implements course search functionality
- **Recommendation Engine**: Generates personalized course recommendations

**Architecture Principle**: Repository handles all business logic, data source only loads raw data.

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON File
5. **Results** ← JSON File ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Prerequisite Validation**: Students must complete prerequisites before taking advanced courses
2. **Academic Level**: Courses are categorized by academic level (freshman to senior)
3. **Department Alignment**: Courses belong to specific departments
4. **Credit System**: Courses have credit hour requirements
5. **Course Progression**: Logical course progression based on prerequisites

## 🚀 Usage Examples

```dart
// Get course recommendations for a student
final recommendations = await getCourseRecommendationsUseCase.call(
  GetCourseRecommendationsParams(
    studentId: "202205001",
    major: "Computer Science",
    year: 2,
    completedCourses: ["CMPS101", "CMPS151"],
    strugglingCourses: ["CMPS251"],
  ),
);

// Search for Flutter-related courses
final flutterCourses = await searchCoursesUseCase.call(
  SearchCoursesParams(
    query: "Flutter",
    departmentId: "dept_cs",
    level: "junior",
  ),
);

// Get CS department courses
final csCourses = await getCoursesByDepartmentUseCase.call(
  GetCoursesByDepartmentParams(
    departmentId: "dept_cs",
    level: "junior",
  ),
);
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: Department and Course classes
- **User Management**: For student data and recommendations

## 📈 Performance Considerations

- **Caching**: Academic data is loaded once and cached
- **Filtering**: Business logic filters are applied efficiently
- **Search**: Course search is optimized for performance
- **Memory**: Large course catalogs are handled efficiently

## 🛡️ Error Handling

- **Data Parsing**: Handles malformed JSON data
- **Validation**: Validates academic data integrity
- **Business Logic**: Validates business rules
- **Prerequisite Validation**: Ensures prerequisite requirements

## 🔄 Future Enhancements

- **Course Prerequisites**: Advanced prerequisite tracking
- **Academic Planning**: Automated academic planning tools
- **Course Analytics**: Course performance and success metrics
- **Prerequisite Visualization**: Visual prerequisite dependency graphs
- **Academic Progress**: Student academic progress tracking
