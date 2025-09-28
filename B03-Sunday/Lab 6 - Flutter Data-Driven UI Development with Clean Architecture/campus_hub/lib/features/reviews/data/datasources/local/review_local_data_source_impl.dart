import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/review.dart';

class ReviewLocalDataSource {
  Future<List<Review>> getReviews() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/reviews_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Review.fromJson(json)).toList();
  }

  Future<void> saveReview(Review review) async {
    // Placeholder for saving new reviews
    throw UnimplementedError('Saving to JSON files not implemented');
  }

  Future<void> updateReview(Review review) async {
    // Placeholder for updating reviews
    throw UnimplementedError('Updating JSON files not implemented');
  }

  Future<void> deleteReview(String id) async {
    // Placeholder for deleting reviews
    throw UnimplementedError('Deleting from JSON files not implemented');
  }
}
