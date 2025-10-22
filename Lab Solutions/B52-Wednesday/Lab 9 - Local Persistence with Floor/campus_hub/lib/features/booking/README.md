# Booking Feature

This feature handles student booking operations in the Campus Hub app, including creating, managing, and querying tutoring session bookings.

## 📁 File Structure

```
booking/
├── domain/
│   ├── entities/
│   │   └── booking.dart           # Booking entity
│   ├── contracts/
│   │   └── booking_repository.dart # Repository interface
│   └── usecases/
│       ├── create_booking_with_validation.dart # Create booking with validation
│       └── get_student_bookings_summary.dart # Get booking summary
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── booking_local_data_source.dart      # Data source interface
│   │       └── booking_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── booking_repository_impl.dart            # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### Booking Entity
Represents a student's booking for a tutoring session.

```dart
class Booking {
  final String id;           // Unique booking identifier
  final String sessionId;     // ID of the booked session
  final String studentId;     // ID of the student who booked
  final String status;        // "pending", "confirmed", "cancelled", "attended"
  final DateTime bookedAt;     // When the booking was made
  final String? reason;       // Reason for booking (optional)
}
```

**Key Methods**:
```dart
bool get isConfirmed => status == "confirmed";
bool get isCancelled => status == "cancelled";
bool get isPending => status == "pending";
bool get isAttended => status == "attended";
bool get canBeCancelled => isConfirmed || isPending;
```

**JSON Serialization**:
```dart
factory Booking.fromJson(Map<String, dynamic> json);
Map<String, dynamic> toJson();
```

## 🔌 Repository Interface

### BookingRepository
```dart
abstract class BookingRepository {
  // Basic CRUD operations
  Future<List<Booking>> getBookings();
  Future<Booking?> getBookingById(String id);
  Future<void> saveBooking(Booking booking);
  Future<void> updateBooking(Booking booking);
  Future<void> deleteBooking(String id);
  
  // Query operations
  Future<List<Booking>> getBookingsByStudent(String studentId);
  Future<List<Booking>> getBookingsBySession(String sessionId);
  Future<List<Booking>> getBookingsByStatus(String status);
  Future<List<Booking>> getUpcomingBookings(String studentId);
  Future<Booking?> getBookingByStudentAndSession(String studentId, String sessionId);
}
```

## 🎯 Use Cases Documentation

### GetBookingsByStudent
**Purpose**: Get all bookings made by a specific student.

**Parameters**:
- `studentId`: Student identifier
- `includePast`: Include past bookings (default: true)
- `status`: Filter by booking status (optional)

**Returns**: `Future<List<Booking>>` - Student's bookings

**Business Logic**:
- Filters bookings by studentId
- Optionally includes past bookings
- Filters by status if specified
- Sorts by booking date (newest first)

**Use Cases**:
- Student dashboard
- Booking history
- Academic progress tracking

### CreateBookingWithValidation
**Purpose**: Create a new booking with comprehensive validation.

**Parameters**:
- `booking`: Booking object to create
- `validateAvailability`: Check session availability (default: true)
- `validateStudent`: Check student eligibility (default: true)

**Returns**: `Future<Booking>` - Created booking

**Business Logic**:
1. **Session Validation**:
   - Checks if session exists
   - Verifies session is open for booking
   - Validates session capacity
   - Ensures session is not in the past

2. **Student Validation**:
   - Verifies student exists
   - Checks if student already booked this session
   - Validates student needs help with course (optional)

3. **Booking Creation**:
   - Creates booking with "pending" status
   - Sets booking timestamp
   - Records booking reason

**Key Features**:
- Comprehensive validation
- Conflict prevention
- Business rule enforcement
- Error handling

### GetStudentUpcomingBookings
**Purpose**: Get a student's upcoming confirmed bookings.

**Parameters**:
- `studentId`: Student identifier
- `limit`: Maximum number of results (optional)

**Returns**: `Future<List<Booking>>` - Upcoming bookings

**Business Logic**:
- Filters by studentId
- Includes only confirmed bookings
- Filters for future sessions
- Sorts by session start time
- Limits results if specified

**Use Cases**:
- Student dashboard
- Upcoming sessions reminder
- Calendar integration

### GetStudentBookingsSummary
**Purpose**: Get a summary of student's booking activity.

**Parameters**:
- `studentId`: Student identifier

**Returns**: `Future<BookingSummary>` - Booking summary

**Business Logic**:
- Counts total bookings
- Counts by status (confirmed, cancelled, attended)
- Calculates attendance rate
- Identifies favorite courses
- Provides booking trends

**Use Cases**:
- Student analytics
- Academic progress
- Usage statistics

### CancelBooking
**Purpose**: Cancel an existing booking.

**Parameters**:
- `bookingId`: Booking identifier
- `reason`: Cancellation reason (optional)

**Returns**: `Future<void>`

**Business Logic**:
- Validates booking exists
- Checks if booking can be cancelled
- Updates status to "cancelled"
- Records cancellation reason
- Updates session capacity

**Validation Rules**:
- Only confirmed or pending bookings can be cancelled
- Cannot cancel attended bookings
- Cannot cancel past sessions

### GetStudentBookingsSummary
**Purpose**: Get comprehensive booking summary for a student with statistics.

**Parameters**:
- `studentId`: Student identifier

**Returns**: `Future<Map<String, dynamic>>` - Booking summary with statistics

**Business Logic**:
- Categorizes bookings by status and time
- Calculates attendance rates
- Provides upcoming and pending bookings
- Aggregates booking statistics

**Complexity**: Complex data aggregation and statistics that cannot be achieved with a single repository call.

## 💾 Data Source Implementation

### BookingLocalDataSource
**Purpose**: Interface for local booking data access.

**Methods**:
```dart
Future<List<Booking>> getBookings();  // Loads all bookings
Future<void> saveBooking(Booking booking);
Future<void> updateBooking(Booking booking);
Future<void> deleteBooking(String id);
```

**Architecture Principle**: Data source is "dumb" - only loads raw data, no filtering or business logic.

### BookingLocalDataSourceImpl
**Purpose**: JSON file implementation of booking data source.

**Data Source**: `assets/json/bookings_sample.json`

**Key Features**:
- Loads raw booking data from JSON assets
- Parses JSON to Booking entities
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
    "id": "b1",
    "sessionId": "9b23c852",
    "studentId": "202205001",
    "status": "confirmed",
    "bookedAt": "2025-10-01T10:00:00Z",
    "reason": "Struggling with Flutter widgets in CMPS312"
  }
]
```

## 🔄 Repository Implementation

### BookingRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `BookingLocalDataSource` - For data access

**Key Features**:
- Implements all repository interface methods
- **Handles all business logic** (filtering, sorting, validation)
- Coordinates data sources
- Returns processed results

**Business Logic Examples**:
- **ID Lookup**: Searches through loaded data to find specific bookings
- **Status Filtering**: Filters bookings by status
- **Date Filtering**: Filters by booking dates
- **Student Filtering**: Filters by student ID
- **Session Filtering**: Filters by session ID
- **Capacity Management**: Tracks session capacity

**Architecture Principle**: Repository handles all business logic, data source only loads raw data.

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON File
5. **Results** ← JSON File ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Booking Status**: Valid statuses are "pending", "confirmed", "cancelled", "attended"
2. **Session Capacity**: Cannot exceed session capacity
3. **Student Eligibility**: Students can only book sessions for courses they need help with
4. **Time Validation**: Cannot book past sessions
5. **Conflict Prevention**: Students cannot book the same session twice
6. **Status Transitions**: Only valid status transitions are allowed

## 🚀 Usage Examples

```dart
// Create a new booking with validation
final booking = await createBookingWithValidationUseCase.call(
  CreateBookingWithValidationParams(
    booking: Booking(
      id: "b_new",
      sessionId: "9b23c852",
      studentId: "202205001",
      status: "pending",
      bookedAt: DateTime.now(),
      reason: "Need help with Flutter widgets",
    ),
    validateAvailability: true,
    validateStudent: true,
  ),
);

// Get student's upcoming bookings
final upcomingBookings = await getStudentUpcomingBookingsUseCase.call(
  GetStudentUpcomingBookingsParams(
    studentId: "202205001",
    limit: 5,
  ),
);

// Cancel a booking
await cancelBookingUseCase.call(
  CancelBookingParams(
    bookingId: "b1",
    reason: "Schedule conflict",
  ),
);
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: Booking class
- **Session Management**: For session validation
- **User Management**: For student validation

## 📈 Performance Considerations

- **Caching**: Bookings are loaded once and cached
- **Filtering**: Business logic filters are applied efficiently
- **Sorting**: Results are sorted by date for better UX
- **Memory**: Large booking lists are handled efficiently

## 🛡️ Error Handling

- **Data Parsing**: Handles malformed JSON data
- **Validation**: Validates booking data integrity
- **Business Logic**: Validates business rules
- **Conflict Detection**: Prevents double-booking

## 🔄 Future Enhancements

- **Real-time Updates**: WebSocket integration for live booking updates
- **Waitlist**: Support for session waitlists
- **Recurring Bookings**: Support for recurring session bookings
- **Booking Reminders**: Automated reminder notifications
- **Analytics**: Booking patterns and success metrics
