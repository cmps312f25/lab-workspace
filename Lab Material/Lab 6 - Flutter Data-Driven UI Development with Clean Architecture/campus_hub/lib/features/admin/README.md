# Admin Feature

This feature handles administrative operations in the Campus Hub app, including analytics, moderation, and system management.

## 📁 File Structure

```
admin/
├── domain/
│   ├── entities/
│   │   └── admin.dart           # Admin entity (inherited from User Management)
│   ├── contracts/
│   │   └── admin_repository.dart # Repository interface
│   └── usecases/
│       └── (no use cases implemented yet)
├── data/
│   ├── datasources/
│   │   └── local/
│   │       ├── admin_local_data_source.dart      # Data source interface
│   │       └── admin_local_data_source_impl.dart # JSON file implementation
│   └── repositories/
│       └── admin_repository_impl.dart            # Repository implementation
└── README.md
```

## 🏗️ Architecture Overview

This feature follows **Clean Architecture** principles:

- **Domain Layer**: Contains business entities, contracts, and use cases
- **Data Layer**: Contains data sources and repository implementations
- **Dependency Flow**: Data → Domain (Data layer depends on Domain layer)

## 📋 Entity Documentation

### Admin Entity
Represents an administrative user with specific permissions.

```dart
class Admin extends User {
  final List<String> permissions; // Admin permissions
}
```

**Key Methods**:
```dart
bool hasPermission(String permission) => permissions.contains(permission);
bool canViewAnalytics() => hasPermission("view_analytics");
bool canModerateReviews() => hasPermission("moderate_reviews");
bool canManageUsers() => hasPermission("manage_users");
bool canManageSessions() => hasPermission("manage_sessions");
```

**Permissions**:
- `view_analytics`: View system analytics and reports
- `moderate_reviews`: Moderate user reviews
- `manage_users`: Manage user accounts
- `manage_sessions`: Manage tutoring sessions

## 🔌 Repository Interface

### AdminRepository
```dart
abstract class AdminRepository {
  // Admin operations
  Future<List<Admin>> getAdmins();
  Future<Admin?> getAdminById(String id);
  Future<bool> hasPermission(String adminId, String permission);
  
  // Analytics operations
  Future<SystemAnalytics> getSystemAnalytics();
  Future<UserActivityMetrics> getUserActivityMetrics();
  Future<PerformanceMetrics> getPerformanceMetrics();
  Future<SystemHealth> getSystemHealth();
  
  // Moderation operations
  Future<List<Review>> getReviewsForModeration();
  Future<void> moderateReview(String reviewId, String action, String reason);
  Future<List<Session>> getSessionsForModeration();
  Future<void> moderateSession(String sessionId, String action, String reason);
  
  // User management
  Future<List<Student>> getUsersByStatus(String status);
  Future<void> updateUserStatus(String userId, String status);
  Future<List<Student>> getInactiveUsers();
}
```

## 🎯 Use Cases Documentation

**Note**: All simple pass-through use cases have been removed. Admin feature now relies on direct repository calls for simple operations and complex business logic is handled in the repository implementations.
1. **Review Validation**:
   - Checks if review exists
   - Validates admin permissions
   - Ensures review is not already moderated

2. **Moderation Actions**:
   - **Approve**: Review becomes visible to users
   - **Reject**: Review is hidden from users
   - **Flag**: Review requires further attention

3. **Audit Trail**:
   - Records moderation action
   - Logs admin who performed action
   - Records reason for action
   - Updates review status

**Use Cases**:
- Content moderation
- Quality assurance
- Community management
- Policy enforcement

### GetSystemHealth
**Purpose**: Get system health status and performance metrics.

**Parameters**:
- `includePerformance`: Include performance metrics (default: true)
- `includeErrors`: Include error metrics (default: true)
- `includeCapacity`: Include capacity metrics (default: true)

**Returns**: `Future<SystemHealth>` - System health status

**Business Logic**:
1. **Performance Metrics**:
   - Response times
   - Throughput rates
   - Resource utilization
   - Database performance

2. **Error Metrics**:
   - Error rates by feature
   - Error trends over time
   - Critical error identification
   - Error resolution tracking

3. **Capacity Metrics**:
   - User capacity utilization
   - Session capacity utilization
   - Storage capacity
   - Network capacity

**Use Cases**:
- System monitoring
- Performance optimization
- Capacity planning
- Issue identification

### GetUserActivityMetrics
**Purpose**: Get detailed user activity metrics and engagement data.

**Parameters**:
- `timeRange`: Time range for metrics (optional)
- `userType`: Filter by user type (optional)
- `includeEngagement`: Include engagement metrics (default: true)

**Returns**: `Future<UserActivityMetrics>` - User activity metrics

**Business Logic**:
1. **Activity Tracking**:
   - Login frequency
   - Feature usage patterns
   - Session duration
   - Action frequency

2. **Engagement Metrics**:
   - User retention rates
   - Feature adoption rates
   - User satisfaction scores
   - Churn analysis

3. **Behavioral Analysis**:
   - Peak usage times
   - Popular features
   - User journey analysis
   - Conversion rates

**Use Cases**:
- User engagement analysis
- Feature usage optimization
- User retention strategies
- Product improvement

### GetPerformanceMetrics
**Purpose**: Get system performance metrics and optimization insights.

**Parameters**:
- `timeRange`: Time range for metrics (optional)
- `includeDatabase`: Include database metrics (default: true)
- `includeNetwork`: Include network metrics (default: true)

**Returns**: `Future<PerformanceMetrics>` - Performance metrics

**Business Logic**:
1. **Response Time Analysis**:
   - API response times
   - Database query times
   - Feature load times
   - User interaction delays

2. **Resource Utilization**:
   - CPU usage patterns
   - Memory consumption
   - Storage utilization
   - Network bandwidth

3. **Optimization Insights**:
   - Bottleneck identification
   - Performance trends
   - Optimization opportunities
   - Capacity recommendations

**Use Cases**:
- Performance optimization
- System scaling
- Resource planning
- Issue resolution

## 💾 Data Source Implementation

### AdminLocalDataSource
**Purpose**: Interface for local admin data access.

**Methods**:
```dart
Future<List<Admin>> getAdmins();
Future<Admin?> getAdminById(String id);
Future<SystemAnalytics> getSystemAnalytics();
Future<UserActivityMetrics> getUserActivityMetrics();
Future<PerformanceMetrics> getPerformanceMetrics();
Future<SystemHealth> getSystemHealth();
```

### AdminLocalDataSourceImpl
**Purpose**: JSON file implementation of admin data source.

**Data Sources**: 
- `assets/json/users_sample.json` - User data
- `assets/json/sessions_sample.json` - Session data
- `assets/json/bookings_sample.json` - Booking data
- `assets/json/reviews_sample.json` - Review data

**Key Features**:
- Aggregates data from multiple sources
- Calculates analytics metrics
- Handles data parsing errors
- Provides comprehensive analytics

**Error Handling**:
- Catches JSON parsing errors
- Returns `DataParsingFailure` for invalid data
- Logs errors for debugging
- Handles missing data gracefully

## 🔄 Repository Implementation

### AdminRepositoryImpl
**Purpose**: Implements business logic and coordinates data sources.

**Dependencies**:
- `AdminLocalDataSource` - For data access
- `UserRepository` - For user data
- `SessionRepository` - For session data
- `BookingRepository` - For booking data
- `ReviewRepository` - For review data

**Key Features**:
- Implements all repository interface methods
- Applies business logic (filtering, sorting, validation)
- Handles errors from data sources
- Returns processed results

**Business Logic Examples**:
- **Analytics Calculation**: Computes system metrics
- **Permission Validation**: Validates admin permissions
- **Moderation Logic**: Implements content moderation
- **Performance Analysis**: Analyzes system performance

## 📊 Data Flow

1. **Presentation Layer** → Use Case
2. **Use Case** → Repository
3. **Repository** → Data Source
4. **Data Source** → JSON Files
5. **Results** ← JSON Files ← Data Source ← Repository ← Use Case ← Presentation

## 🎯 Key Business Rules

1. **Permission Validation**: Admins can only perform actions they have permissions for
2. **Audit Trail**: All admin actions are logged with timestamps and reasons
3. **Data Integrity**: Analytics calculations must be accurate and consistent
4. **Moderation Standards**: Content moderation follows established guidelines
5. **Performance Monitoring**: System performance is continuously monitored

## 🚀 Usage Examples

```dart
// Get system analytics
final analytics = await getAnalyticsUseCase.call(
  GetAnalyticsParams(
    timeRange: DateRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    ),
    includeUserMetrics: true,
    includeSessionMetrics: true,
  ),
);

// Moderate a review
await moderateReviewUseCase.call(
  ModerateReviewParams(
    reviewId: "r1",
    action: "approve",
    reason: "Content is appropriate",
    adminId: "admin001",
  ),
);

// Get system health
final health = await getSystemHealthUseCase.call(
  GetSystemHealthParams(
    includePerformance: true,
    includeErrors: true,
    includeCapacity: true,
  ),
);
```

## 🔧 Dependencies

- **Flutter Services**: For loading JSON assets
- **Dartz**: For functional programming (Either types)
- **Core Error**: For error handling
- **Domain Entities**: Admin class
- **User Management**: For user data and permissions
- **Session Management**: For session analytics
- **Booking Management**: For booking analytics
- **Review Management**: For review moderation

## 📈 Performance Considerations

- **Data Aggregation**: Efficiently aggregates data from multiple sources
- **Caching**: Analytics data is cached for performance
- **Optimization**: Complex calculations are optimized
- **Memory**: Large datasets are handled efficiently

## 🛡️ Error Handling

- **Data Parsing**: Handles malformed JSON data
- **Validation**: Validates admin permissions and actions
- **Business Logic**: Validates business rules
- **Audit Trail**: Logs all admin actions and errors

## 🔄 Future Enhancements

- **Real-time Analytics**: Live analytics dashboard
- **Advanced Moderation**: AI-powered content moderation
- **Predictive Analytics**: Predictive system insights
- **Automated Alerts**: Automated system monitoring and alerts
- **Advanced Reporting**: Comprehensive reporting system
