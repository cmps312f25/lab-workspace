import '../entities/staff.dart';

abstract class AuthRepository {
  // ==================== Future-based methods (for JSON repos) ====================

  /// Get all staff (one-time fetch)
  Future<List<Staff>> getAllStaff();

  /// Get staff by username (one-time fetch)
  Future<Staff?> getStaffByUsername(String username);

  /// Authenticate staff with username and password (one-time check)
  Future<Staff?> authenticate(String username, String password);

  // ==================== Stream-based methods (for DB repos) ====================

  /// Watch all staff (reactive - auto-updates UI)
  Stream<List<Staff>> watchAllStaff();

  /// Watch staff by username (reactive - auto-updates UI)
  Stream<Staff?> watchStaffByUsername(String username);

  // ==================== CRUD operations ====================

  /// Add new staff
  Future<void> addStaff(Staff staff);

  /// Update existing staff
  Future<void> updateStaff(Staff staff);

  /// Delete staff
  Future<void> deleteStaff(String staffId);
}
