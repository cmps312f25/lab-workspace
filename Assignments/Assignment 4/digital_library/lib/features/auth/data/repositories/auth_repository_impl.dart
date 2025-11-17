import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Hardcoded admin credentials
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'admin123';

  static final Staff _adminStaff = Staff(
    staffId: 'S001',
    username: 'admin',
    fullName: 'Ahmed Al-Thani',
    role: 'Administrator',
    password: 'admin123',
  );

  @override
  Future<Staff?> authenticate(String username, String password) async {
    // Hardcoded authentication - no API call needed
    if (username == _adminUsername && password == _adminPassword) {
      return _adminStaff;
    }
    return null;
  }

  // Other methods not used in this simplified version
  @override
  Future<List<Staff>> getAllStaff() async {
    return [_adminStaff];
  }

  @override
  Future<Staff?> getStaffByUsername(String username) async {
    if (username == _adminUsername) {
      return _adminStaff;
    }
    return null;
  }

  @override
  Stream<List<Staff>> watchAllStaff() async* {
    yield await getAllStaff();
  }

  @override
  Stream<Staff?> watchStaffByUsername(String username) async* {
    yield await getStaffByUsername(username);
  }

  @override
  Future<void> addStaff(Staff staff) async {
    throw UnimplementedError('Staff management not implemented in this version');
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    throw UnimplementedError('Staff management not implemented in this version');
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    throw UnimplementedError('Staff management not implemented in this version');
  }
}
