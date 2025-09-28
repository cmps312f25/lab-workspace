# Session Management Feature

This feature handles tutoring session operations in the Campus Hub app, including creating, managing, and querying tutoring sessions.

## 📁 File Structure

```
session_management/
├── domain/
│   ├── entities/
│   │   └── session.dart           # Session entity
│   ├── contracts/
│   │   └── session_repository.dart # Repository interface
│   └── usecases/
│       └── get_available_sessions.dart # Find available sessions
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── session_local_data_source.dart      # Data source interface
│   │       └── session_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── session_repository_impl.dart           # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### Session Entity
Represents a tutoring session with all necessary information.

```dart
class Session {
  final String id;           // Unique session identifier
  final String tutorId;       // ID of the tutor conducting the session
  final String courseId;      // Course being taught (e.g., "CMPS312")
  final DateTime start;       // Session start time
  final DateTime end;         // Session end time
  final int capacity;         // Maximum number of students
  final String location;      // Physical location (e.g., "Library 2F, Room 204")
  final String status;         // "open", "closed", "cancelled"
}
```

**Key Methods**:
```dart
Duration get duration => end.difference(start);
bool get isActive => status == "open";
bool get isUpcoming => start.isAfter(DateTime.now());
bool get isPast => end.isBefore(DateTime.now());
bool get isFull => currentBookings >= capacity;
```

**JSON Serialization**:
```dart
factory Session.fromJson(Map<String, dynamic> json);
Map<String, dynamic> toJson();
```

## 🔌 Repository Interface

### SessionRepository
```dart
abstract class SessionRepository {
  // Basic CRUD operations
  Future<List<Session>> getSessions();
  Future<Session?> getSessionById(String id);
  Future<void> saveSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(String id);
  
  // Query operations
  Future<List<Session>> getSessionsByCourse(String courseId);
  Future<List<Session>> getSessionsByTutor(String tutorId);
  Future<List<Session>> getSessionsByDepartment(String departmentId);
  Future<List<Session>> getAvailableSessions();
  Future<List<Session>> getSessionsByDateRange(DateTime start, DateTime end);
  Future<List<Session>> getSessionsByLocation(String location);
}
```

## 🎯 Use Cases Documentation

### GetAvailableSessions
**Purpose**: Find sessions that are open for booking with available capacity.

**Parameters**:
- `courseId`: Filter by specific course (optional)
- `dateRange`: Filter by date range (optional)
- `location`: Filter by location (optional)
- `tutorId`: Filter by specific tutor (optional)

**Returns**: `Future<List<Session>>` - Available sessions

**Business Logic**:
- Filters sessions with status="open"
- Checks capacity availability
- Applies optional filters (course, date, location, tutor)
- Sorts by start time
- Excludes past sessions

**Key Features**:
- Capacity validation
- Date filtering
- Course-specific filtering
- Location-based filtering

### GetAvailableSessions
**Purpose**: Get sessions with complex filtering and capacity checking.

**Parameters**:
- `courseId`: Filter by specific course (optional)
- `startDate`: Filter by start date (optional)
- `endDate`: Filter by end date (optional)
- `location`: Filter by location (optional)

**Returns**: `Future<List<Session>>` - Available sessions with capacity

**Business Logic**:
- Filters sessions by course, date range, and location
- Checks actual capacity vs bookings
- Excludes full sessions
- Sorts by start time

**Complexity**: Multi-repository orchestration that combines session and booking data to determine true availability.

## 💾 Data Source Implementation

### SessionLocalDataSource
**Purpose**: Interface for local session data access.

**Methods**:
```dart
Future<List<Session>> getSessions();  // Loads all sessions
Future<void> saveSession(Session session);
Future<void> updateSession(Session session);
Future<void> deleteSession(String id);
```

**Architecture Principle**: Data source is "dumb" - only loads raw data, no filtering or business logic.

### SessionLocalDataSourceImpl
**Purpose**: JSON file implementation of session data source.

**Data Source**: `assets/json/sessions_sample.json`

**Key Features**:
- Loads raw session data from JSON assets
- Parses JSON to Session entities
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
    "id": "9b23c852",
    "tutorId": "202205023",
    "courseId": "CMPS312",
    "start": "2025-10-05T10:00:00Z",
    "end": "2025-10-05T11:00:00Z",
    "capacity": 5,
    "location": "Library 2F, Room 204",
    "status": "open"
  }
]
```

## 🔄 Repository Implementation

### SessionRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `SessionLocalDataSource` - For data access

**Key Features**:
- Implements all repository interface methods
- **Handles all business logic** (filtering, sorting, validation)
- Coordinates data sources
- Returns processed results

**Business Logic Examples**:
- **ID Lookup**: Searches through loaded data to find specific sessions
- **Availability Check**: Ensures sessions are open and have capacity
- **Date Filtering**: Filters by date ranges and excludes past sessions
- **Course Filtering**: Filters by specific courses
- **Location Filtering**: Filters by physical locations
- **Status Management**: Handles session status transitions

**Architecture Principle**: Repository handles all business logic, data source only loads raw data.

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON File
5. **Results** ← JSON File ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Session Status**: Only "open" sessions can be booked
2. **Capacity**: Sessions have maximum student capacity
3. **Time Validation**: Sessions have start and end times
4. **Course Association**: Sessions are tied to specific courses
5. **Tutor Assignment**: Each session has an assigned tutor
6. **Location**: Sessions have physical locations

## 🚀 Usage Examples

```dart
// Get available Flutter sessions
final sessions = await getAvailableSessionsUseCase.call(
  GetAvailableSessionsParams(
    courseId: "CMPS312",
    dateRange: DateRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(days: 7)),
    ),
  ),
);

// Get tutor's upcoming sessions
final tutorSessions = await getSessionsByTutorUseCase.call(
  GetSessionsByTutorParams(
    tutorId: "202205023",
    includePast: false,
    status: "open",
  ),
);

// Get CS department sessions
final deptSessions = await getSessionsByDepartmentUseCase.call(
  GetSessionsByDepartmentParams(
    departmentId: "dept_cs",
    includePast: false,
  ),
);
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: Session class

## 📈 Performance Considerations

- **Caching**: Sessions are loaded once and cached
- **Filtering**: Business logic filters are applied efficiently
- **Sorting**: Results are sorted by start time for better UX
- **Memory**: Large session lists are handled efficiently

## 🛡️ Error Handling

- **Data Parsing**: Handles malformed JSON data
- **Validation**: Validates session data integrity
- **Network**: Handles data source failures
- **Business Logic**: Validates business rules

## 🔄 Future Enhancements

- **Real-time Updates**: WebSocket integration for live session updates
- **Conflict Detection**: Prevent double-booking
- **Recurring Sessions**: Support for recurring session patterns
- **Session Templates**: Pre-defined session templates
- **Analytics**: Session attendance and performance metrics
