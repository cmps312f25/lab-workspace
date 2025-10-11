import '../entities/staff.dart';

abstract class AuthRepository {
  Future<List<Staff>> getAllStaff();
  Staff? authenticate(String username, String password);
}
