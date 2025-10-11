import '../../features/library_items/data/repositories/json_library_repository.dart';
import '../../features/library_items/domain/entities/library_item.dart';
import '../../features/members/data/repositories/json_member_repository.dart';
import '../../features/members/domain/entities/member.dart';
import '../../features/auth/data/repositories/json_auth_repository.dart';
import '../../features/auth/domain/entities/staff.dart';

/// Simple service locator that provides access to repositories
/// Pre-loads all data at startup for synchronous access
///
/// Repositories contain all the business logic (filtering, searching, etc.)
/// DataService just provides convenient access to the cached data
class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Repository instances
  late final JsonLibraryRepository _libraryRepo;
  late final JsonMemberRepository _memberRepo;
  late final JsonAuthRepository _authRepo;

  bool _isInitialized = false;

  /// Initialize all repositories and pre-load data
  /// Call this once at app startup
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Create repository instances
      _libraryRepo = JsonLibraryRepository();
      _memberRepo = JsonMemberRepository();
      _authRepo = JsonAuthRepository();

      // Pre-load all data into cache
      await _libraryRepo.getAllItems();
      await _memberRepo.getAllMembers();
      await _authRepo.getAllStaff();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize data: $e');
    }
  }

  // ========== Library Items - Delegates to Repository ==========

  List<LibraryItem> getAllItems() {
    _ensureInitialized();
    return _libraryRepo.items ?? [];
  }

  LibraryItem? getItem(String id) {
    _ensureInitialized();
    try {
      final items = _libraryRepo.items ?? [];
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LibraryItem> searchItems(String query) {
    _ensureInitialized();
    final items = _libraryRepo.items ?? [];
    final lowerQuery = query.toLowerCase();

    return items.where((item) {
      final titleMatch = item.title.toLowerCase().contains(lowerQuery);
      final authorMatch = item.authors
          .any((author) => author.name.toLowerCase().contains(lowerQuery));
      return titleMatch || authorMatch;
    }).toList();
  }

  // ========== Members - Delegates to Repository ==========

  List<Member> getAllMembers() {
    _ensureInitialized();
    return _memberRepo.members ?? [];
  }

  Member? getMember(String memberId) {
    _ensureInitialized();
    try {
      final members = _memberRepo.members ?? [];
      return members.firstWhere((member) => member.memberId == memberId);
    } catch (e) {
      return null;
    }
  }

  List<Member> searchMembers(String query) {
    _ensureInitialized();
    final members = _memberRepo.members ?? [];
    final lowerQuery = query.toLowerCase();

    return members.where((member) {
      final nameMatch = member.name.toLowerCase().contains(lowerQuery);
      final emailMatch = member.email.toLowerCase().contains(lowerQuery);
      return nameMatch || emailMatch;
    }).toList();
  }

  // ========== Authentication - Delegates to Repository ==========

  Staff? authenticate(String username, String password) {
    _ensureInitialized();
    try {
      return _authRepo.staffList.firstWhere(
        (staff) => staff.username == username && staff.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ========== Helper ==========

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('DataService not initialized. Call initialize() first.');
    }
  }
}
