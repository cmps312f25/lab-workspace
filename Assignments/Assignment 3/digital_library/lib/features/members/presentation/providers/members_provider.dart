import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo_providers.dart';
import '../../domain/contracts/member_repository.dart';
import '../../domain/entities/member.dart';

/// State class to hold members data
class MembersState {
  final List<Member> members;
  final String searchQuery;

  MembersState({
    required this.members,
    this.searchQuery = '',
  });

  MembersState copyWith({
    List<Member>? members,
    String? searchQuery,
  }) {
    return MembersState(
      members: members ?? this.members,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier for managing members state
class MembersNotifier extends AsyncNotifier<MembersState> {
  late final MemberRepository _memberRepo;
  StreamSubscription<List<Member>>? _subscription;

  @override
  Future<MembersState> build() async {
    // Get the repository from the provider
    _memberRepo = await ref.read(memberRepoProvider.future);

    // Subscribe to members stream for reactive updates
    _subscription = _memberRepo.watchAllMembers().listen((members) {
      state = AsyncValue.data(
        MembersState(
          members: members,
          searchQuery: state.value?.searchQuery ?? '',
        ),
      );
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty state
    return MembersState(members: []);
  }

  /// Search members by query
  Future<void> searchMembers(String query) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final members = query.isEmpty
          ? await _memberRepo.getAllMembers()
          : await _memberRepo.searchMembers(query);

      return MembersState(
        members: members,
        searchQuery: query,
      );
    });
  }

  /// Get a specific member by ID
  Future<Member?> getMember(String memberId) async {
    try {
      return await _memberRepo.getMember(memberId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new member
  Future<void> addMember(Member member) async {
    try {
      await _memberRepo.addMember(member);
      // Refresh the list after adding
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing member
  Future<void> updateMember(Member member) async {
    try {
      await _memberRepo.updateMember(member);
      // Refresh the list after updating
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh members list
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final members = await _memberRepo.getAllMembers();
      return MembersState(members: members);
    });
  }
}

/// Provider for members notifier
final membersProvider = AsyncNotifierProvider<MembersNotifier, MembersState>(
  () => MembersNotifier(),
);
