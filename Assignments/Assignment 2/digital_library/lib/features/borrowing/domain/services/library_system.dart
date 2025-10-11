import '../../../library_items/core/utils/library_item_extensions.dart';
import '../../../library_items/domain/contracts/library_repository.dart';
import '../../../members/domain/contracts/member_repository.dart';
import '../../../members/domain/contracts/payable.dart';
import '../entities/borrowed_item.dart';

class LibrarySystem {
  final LibraryRepository libraryRepository;
  final MemberRepository memberRepository;

  // Reservation system: itemId -> List of memberIds waiting
  final Map<String, List<String>> _reservations = {};

  LibrarySystem({
    required this.libraryRepository,
    required this.memberRepository,
  });

  /// Borrows an item for a member
  /// Validates member eligibility, item availability, and borrowing limits
  Future<BorrowedItem> borrowItem(String memberId, String itemId) async {
    // Get member and item
    final member = await memberRepository.getMember(memberId);
    final item = await libraryRepository.getItem(itemId);

    // Validate eligibility
    if (!member.canBorrowItem(item)) {
      if (!item.isAvailable) {
        throw Exception(
            'Item "${item.title}" is not available for borrowing');
      }
      final currentBorrowed =
          member.borrowedItems.where((bi) => !bi.isReturned).length;
      throw Exception(
          'Member has reached borrowing limit ($currentBorrowed/${member.maxBorrowLimit})');
    }

    // Create borrowed item
    final borrowedItem = BorrowedItem(
      item: item,
      borrowDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: member.borrowPeriod)),
    );

    // Update member's borrowed items
    member.borrowedItems.add(borrowedItem);

    // Update item availability
    item.isAvailable = false;

    // Update member in repository
    await memberRepository.updateMember(member);

    return borrowedItem;
  }

  /// Returns an item for a member
  /// Processes return, calculates fees, and handles payment if needed
  Future<Map<String, dynamic>> returnItem(
      String memberId, String itemId) async {
    // Get member
    final member = await memberRepository.getMember(memberId);

    // Find the borrowed item
    final borrowedItem = member.borrowedItems.firstWhere(
      (bi) => bi.item.id == itemId && !bi.isReturned,
      orElse: () => throw Exception(
          'Member has not borrowed item with ID $itemId or it is already returned'),
    );

    // Process return
    borrowedItem.processReturn();

    // Calculate fees
    final lateFee = borrowedItem.calculateLateFee();

    // Update item availability
    borrowedItem.item.isAvailable = true;

    // Handle fee payment for payable members
    bool feesPaid = false;
    if (member is Payable && lateFee > 0) {
      // In a real system, payment would be processed here
      // For now, we just track that fees are due
      feesPaid = false;
    } else {
      feesPaid = true;
    }

    // Update member in repository
    await memberRepository.updateMember(member);

    return {
      'borrowedItem': borrowedItem,
      'lateFee': lateFee,
      'feesPaid': feesPaid,
      'returnDate': borrowedItem.returnDate,
    };
  }

  /// Generates detailed overdue report
  Future<Map<String, dynamic>> generateOverdueReport() async {
    final members = await memberRepository.getAllMembers();

    final overdueDetails = <Map<String, dynamic>>[];
    double totalFees = 0.0;

    for (final member in members) {
      final overdueItems = member.getOverdueItems();
      if (overdueItems.isEmpty) continue;

      for (final borrowedItem in overdueItems) {
        final fee = borrowedItem.calculateLateFee();
        final cappedFee = member is Payable ? (fee > 50 ? 50 : fee) : fee;

        overdueDetails.add({
          'memberName': member.name,
          'memberId': member.memberId,
          'memberType': member.getMemberType(),
          'itemTitle': borrowedItem.item.title,
          'itemId': borrowedItem.item.id,
          'dueDate': borrowedItem.dueDate,
          'daysOverdue': borrowedItem.getDaysOverdue(),
          'lateFee': cappedFee,
        });

        totalFees += cappedFee;
      }
    }

    // Sort by days overdue descending
    overdueDetails
        .sort((a, b) => (b['daysOverdue'] as int).compareTo(a['daysOverdue'] as int));

    return {
      'overdueDetails': overdueDetails,
      'totalOverdueItems': overdueDetails.length,
      'totalFees': totalFees,
      'reportDate': DateTime.now(),
    };
  }

  /// Recommends items based on borrowing history and ratings
  Future<List<Map<String, dynamic>>> recommendItems(
      String memberId, int maxRecommendations) async {
    final member = await memberRepository.getMember(memberId);
    final allItems = await libraryRepository.getAllItems();

    if (member.borrowedItems.isEmpty) {
      // New member: recommend popular items
      return allItems.getPopularityScore().take(maxRecommendations).toList();
    }

    // Get categories member has borrowed from
    final borrowedCategories = member.borrowedItems
        .map((bi) => bi.item.category)
        .toSet();

    // Get authors member has borrowed from
    final borrowedAuthorIds = member.borrowedItems
        .expand((bi) => bi.item.authors.map((a) => a.id))
        .toSet();

    // Score items based on relevance
    final recommendations = allItems.where((item) {
      // Don't recommend already borrowed items
      return !member.borrowedItems.any((bi) => bi.item.id == item.id);
    }).map((item) {
      var score = 0.0;

      // Category match
      if (borrowedCategories.contains(item.category)) {
        score += 3.0;
      }

      // Author match
      final commonAuthors =
          item.authors.where((a) => borrowedAuthorIds.contains(a.id)).length;
      score += commonAuthors * 5.0;

      // Rating boost
      score += item.getAverageRating();

      // Availability boost
      if (item.isAvailable) score += 2.0;

      return {
        'item': item,
        'score': score,
        'reason': _getRecommendationReason(
            item, borrowedCategories, borrowedAuthorIds),
      };
    }).toList()
      ..sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    return recommendations.take(maxRecommendations).toList();
  }

  String _getRecommendationReason(
      dynamic item, Set<String> categories, Set<String> authorIds) {
    final reasons = <String>[];

    if (categories.contains(item.category)) {
      reasons.add('Similar category');
    }

    final commonAuthors =
        item.authors.where((a) => authorIds.contains(a.id)).length;
    if (commonAuthors > 0) {
      reasons.add('Favorite author');
    }

    if (item.getAverageRating() >= 4.0) {
      reasons.add('Highly rated');
    }

    return reasons.isEmpty ? 'Popular item' : reasons.join(', ');
  }

  /// Generates comprehensive monthly report
  Future<Map<String, dynamic>> processMonthlyReport() async {
    final members = await memberRepository.getAllMembers();
    final items = await libraryRepository.getAllItems();

    // Popular items (most borrowed)
    final itemBorrowCounts = <String, int>{};
    for (final member in members) {
      for (final borrowedItem in member.borrowedItems) {
        itemBorrowCounts[borrowedItem.item.id] =
            (itemBorrowCounts[borrowedItem.item.id] ?? 0) + 1;
      }
    }

    final popularItems = itemBorrowCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topItems = popularItems.take(10).map((entry) {
      final item = items.firstWhere((i) => i.id == entry.key);
      return {
        'title': item.title,
        'borrowCount': entry.value,
        'type': item.getItemType(),
      };
    }).toList();

    // Active members
    final memberActivity = members.map((member) {
      return {
        'name': member.name,
        'type': member.getMemberType(),
        'borrowCount': member.borrowedItems.length,
      };
    }).toList()
      ..sort((a, b) =>
          (b['borrowCount'] as int).compareTo(a['borrowCount'] as int));

    final topMembers = memberActivity.take(10).toList();

    // Revenue from fees
    final totalRevenue = members.whereType<Payable>().fold<double>(
        0.0, (sum, member) => sum + member.calculateFees());

    // Collection statistics
    final collectionHealth = items.analyzeCollectionHealth();

    // Trends
    final recentBorrows = members
        .expand((m) => m.borrowedItems)
        .where((bi) => bi.borrowDate
            .isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .length;

    return {
      'reportMonth': DateTime.now(),
      'topItems': topItems,
      'topMembers': topMembers,
      'totalRevenue': totalRevenue,
      'collectionHealth': collectionHealth,
      'recentBorrows': recentBorrows,
      'totalMembers': members.length,
      'totalItems': items.length,
    };
  }

  /// Handles item reservation (queue system)
  Future<void> handleReservation(String memberId, String itemId) async {
    // Validate member exists
    await memberRepository.getMember(memberId);

    // Validate item exists
    final item = await libraryRepository.getItem(itemId);

    // Check if item is available
    if (item.isAvailable) {
      throw Exception(
          'Item "${item.title}" is available. Please borrow it directly.');
    }

    // Add to reservation queue
    _reservations.putIfAbsent(itemId, () => []).add(memberId);
  }

  /// Gets reservation queue for an item
  List<String> getReservationQueue(String itemId) {
    return _reservations[itemId] ?? [];
  }

  /// Processes next reservation when item becomes available
  Future<String?> processNextReservation(String itemId) async {
    final queue = _reservations[itemId];
    if (queue == null || queue.isEmpty) return null;

    final nextMemberId = queue.removeAt(0);
    if (queue.isEmpty) {
      _reservations.remove(itemId);
    }

    return nextMemberId;
  }
}
