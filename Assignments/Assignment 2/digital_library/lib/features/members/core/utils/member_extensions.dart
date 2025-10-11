import '../../domain/contracts/payable.dart';
import '../../domain/entities/member.dart';

extension MemberExtensions on List<Member> {
  /// Generic type filtering
  List<T> filterByType<T extends Member>() =>
      whereType<T>().toList();

  /// Filters members with any overdue items
  List<Member> getMembersWithOverdueItems() =>
      where((member) => member.getOverdueItems().isNotEmpty).toList();

  /// Sums outstanding fees across all payable members
  double calculateTotalFees() {
    return whereType<Payable>()
        .fold<double>(0.0, (sum, member) => sum + member.calculateFees());
  }

  /// Analyzes borrowing patterns
  /// Returns insights: most active borrowers, average books per member, popular categories
  Map<String, dynamic> analyzeBorrowingPatterns() {
    if (isEmpty) {
      return {
        'mostActiveBorrowers': <Map<String, dynamic>>[],
        'averageBooksPerMember': 0.0,
        'popularCategoriesByType': <String, Map<String, int>>{},
        'totalBorrowedItems': 0,
      };
    }

    // Most active borrowers
    final memberActivity = map((member) {
      return {
        'member': member,
        'borrowCount': member.borrowedItems.length,
      };
    }).toList()
      ..sort((a, b) =>
          (b['borrowCount'] as int).compareTo(a['borrowCount'] as int));

    final mostActiveBorrowers = memberActivity.take(5).map((item) {
      final member = item['member'] as Member;
      return {
        'name': member.name,
        'type': member.getMemberType(),
        'borrowCount': item['borrowCount'],
      };
    }).toList();

    // Average books per member
    final totalBorrowed =
        fold<int>(0, (sum, member) => sum + member.borrowedItems.length);
    final averageBooksPerMember = totalBorrowed / length;

    // Popular categories by member type
    final categoryByType = <String, Map<String, int>>{};
    for (final member in this) {
      final memberType = member.getMemberType();
      categoryByType.putIfAbsent(memberType, () => <String, int>{});

      for (final borrowedItem in member.borrowedItems) {
        final category = borrowedItem.item.category;
        categoryByType[memberType]![category] =
            (categoryByType[memberType]![category] ?? 0) + 1;
      }
    }

    return {
      'mostActiveBorrowers': mostActiveBorrowers,
      'averageBooksPerMember': averageBooksPerMember,
      'popularCategoriesByType': categoryByType,
      'totalBorrowedItems': totalBorrowed,
      'totalMembers': length,
    };
  }

  /// Returns members who borrowed items since specified date
  List<Member> getMembersByActivity(DateTime since) {
    return where((member) => member.borrowedItems
        .any((borrowedItem) => borrowedItem.borrowDate.isAfter(since))).toList();
  }

  /// Identifies members with items overdue beyond threshold
  List<Map<String, dynamic>> getRiskMembers(int overdueDaysThreshold) {
    return where((member) => member.getOverdueItems().any(
            (item) => item.getDaysOverdue() >= overdueDaysThreshold))
        .map((member) {
      final severeOverdueItems = member.getOverdueItems()
          .where((item) => item.getDaysOverdue() >= overdueDaysThreshold)
          .toList();

      return {
        'member': member,
        'severeOverdueCount': severeOverdueItems.length,
        'maxOverdueDays': severeOverdueItems.isEmpty
            ? 0
            : severeOverdueItems
                .map((item) => item.getDaysOverdue())
                .reduce((a, b) => a > b ? a : b),
      };
    }).toList()
      ..sort((a, b) =>
          (b['maxOverdueDays'] as int).compareTo(a['maxOverdueDays'] as int));
  }

  /// Generates comprehensive membership report
  Map<String, dynamic> generateMembershipReport() {
    if (isEmpty) {
      return {
        'memberTypeDistribution': <String, int>{},
        'activityLevels': <String, int>{},
        'feeStatistics': <String, double>{},
        'totalMembers': 0,
      };
    }

    // Member type distribution
    final typeDistribution = fold<Map<String, int>>({}, (map, member) {
      final type = member.getMemberType();
      map[type] = (map[type] ?? 0) + 1;
      return map;
    });

    // Activity levels
    final activeMembers = where((member) {
      final recentDate = DateTime.now().subtract(const Duration(days: 30));
      return member.borrowedItems
          .any((item) => item.borrowDate.isAfter(recentDate));
    }).length;

    final inactiveMembers = length - activeMembers;

    // Fee statistics
    final payableMembers = whereType<Payable>().toList();
    final totalFees = payableMembers.fold<double>(
        0.0, (sum, member) => sum + member.calculateFees());
    final averageFees =
        payableMembers.isEmpty ? 0.0 : totalFees / payableMembers.length;
    final membersWithFees =
        payableMembers.where((member) => member.calculateFees() > 0).length;

    return {
      'memberTypeDistribution': typeDistribution,
      'activityLevels': {
        'active': activeMembers,
        'inactive': inactiveMembers,
      },
      'feeStatistics': {
        'totalFees': totalFees,
        'averageFees': averageFees,
        'membersWithFees': membersWithFees.toDouble(),
      },
      'totalMembers': length,
      'totalBorrowedItems':
          fold<int>(0, (sum, member) => sum + member.borrowedItems.length),
      'overdueMembers': getMembersWithOverdueItems().length,
    };
  }
}
