import '../../domain/entities/audiobook.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/library_item.dart';

extension LibraryItemExtensions on List<LibraryItem> {
  /// Filter by author name (case-insensitive partial match)
  List<LibraryItem> filterByAuthor(String authorName) {
    final lowerQuery = authorName.toLowerCase();
    return where((item) => item.authors
        .any((author) => author.name.toLowerCase().contains(lowerQuery))).toList();
  }

  /// Filter by category (exact match, case-insensitive)
  List<LibraryItem> filterByCategory(String category) {
    final lowerCategory = category.toLowerCase();
    return where((item) => item.category.toLowerCase() == lowerCategory)
        .toList();
  }

  /// Sort by average rating descending, then by review count descending for ties
  List<LibraryItem> sortByRating() {
    final sorted = List<LibraryItem>.from(this);
    sorted.sort((a, b) {
      final ratingComparison =
          b.getAverageRating().compareTo(a.getAverageRating());
      if (ratingComparison != 0) return ratingComparison;
      return b.getReviewCount().compareTo(a.getReviewCount());
    });
    return sorted;
  }

  /// Group items by category
  Map<String, List<LibraryItem>> groupByCategory() {
    return fold<Map<String, List<LibraryItem>>>({}, (map, item) {
      map.putIfAbsent(item.category, () => []).add(item);
      return map;
    });
  }

  /// Calculate popularity score based on review count and average rating
  /// Formula: (averageRating * 2) + (reviewCount * 0.5)
  List<Map<String, dynamic>> getPopularityScore() {
    return map((item) {
      final avgRating = item.getAverageRating();
      final reviewCount = item.getReviewCount();
      final score = (avgRating * 2) + (reviewCount * 0.5);
      return {
        'item': item,
        'score': score,
        'avgRating': avgRating,
        'reviewCount': reviewCount,
      };
    }).toList()
      ..sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
  }

  /// Find similar items based on matching authors or categories
  /// Excludes the input item
  List<LibraryItem> findSimilarItems(LibraryItem item, int maxResults) {
    final similarItems = where((otherItem) {
      if (otherItem.id == item.id) return false;

      // Check if shares any author
      final hasCommonAuthor = item.authors
          .any((author) => otherItem.authors.any((a) => a.id == author.id));

      // Check if same category
      final hasSameCategory = otherItem.category == item.category;

      return hasCommonAuthor || hasSameCategory;
    }).toList();

    // Sort by relevance (prioritize items with common authors and same category)
    similarItems.sort((a, b) {
      final aScore = _calculateSimilarityScore(item, a);
      final bScore = _calculateSimilarityScore(item, b);
      return bScore.compareTo(aScore);
    });

    return similarItems.take(maxResults).toList();
  }

  /// Helper method to calculate similarity score
  int _calculateSimilarityScore(LibraryItem item1, LibraryItem item2) {
    var score = 0;
    if (item1.category == item2.category) score += 2;
    final commonAuthors = item1.authors
        .where((a) => item2.authors.any((b) => b.id == a.id))
        .length;
    score += commonAuthors * 3;
    return score;
  }

  /// Estimate reading/listening time
  /// Books: 250 words/page, 200 words/minute
  /// AudioBooks: use duration directly
  List<Map<String, dynamic>> getReadingTimeEstimate() {
    return map((item) {
      double timeInHours;
      String type;

      if (item is Book) {
        final totalWords = item.pageCount * 250;
        final minutes = totalWords / 200;
        timeInHours = minutes / 60;
        type = 'reading';
      } else if (item is AudioBook) {
        timeInHours = item.duration;
        type = 'listening';
      } else {
        timeInHours = 0;
        type = 'unknown';
      }

      return {
        'item': item,
        'timeInHours': timeInHours,
        'type': type,
        'formatted':
            '${timeInHours.toStringAsFixed(1)}h ${type == 'reading' ? 'reading' : 'listening'} time',
      };
    }).toList();
  }

  /// Analyze collection health and statistics
  Map<String, dynamic> analyzeCollectionHealth() {
    if (isEmpty) {
      return {
        'totalItems': 0,
        'availabilityPercentage': 0.0,
        'averageRating': 0.0,
        'categoriesDistribution': <String, int>{},
        'totalReviews': 0,
        'itemsByType': <String, int>{},
      };
    }

    final totalItems = length;
    final availableItems = where((item) => item.isAvailable).length;
    final availabilityPercentage = (availableItems / totalItems) * 100;

    final ratingsWithReviews =
        where((item) => item.getReviewCount() > 0).toList();
    final averageRating = ratingsWithReviews.isEmpty
        ? 0.0
        : ratingsWithReviews.fold<double>(
                0.0, (sum, item) => sum + item.getAverageRating()) /
            ratingsWithReviews.length;

    final categoriesDistribution = groupByCategory()
        .map((category, items) => MapEntry(category, items.length));

    final totalReviews = fold<int>(0, (sum, item) => sum + item.getReviewCount());

    final itemsByType = fold<Map<String, int>>({}, (map, item) {
      final type = item.getItemType();
      map[type] = (map[type] ?? 0) + 1;
      return map;
    });

    return {
      'totalItems': totalItems,
      'availableItems': availableItems,
      'availabilityPercentage': availabilityPercentage,
      'averageRating': averageRating,
      'categoriesDistribution': categoriesDistribution,
      'totalReviews': totalReviews,
      'itemsByType': itemsByType,
      'itemsWithReviews': ratingsWithReviews.length,
    };
  }
}
