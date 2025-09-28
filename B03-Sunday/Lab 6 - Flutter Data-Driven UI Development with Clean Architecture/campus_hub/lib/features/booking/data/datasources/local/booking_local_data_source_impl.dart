import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/entities/booking.dart';

class BookingLocalDataSource {
  Future<List<Booking>> getBookings() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/bookings_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Booking.fromJson(json)).toList();
  }

  Future<void> saveBooking(Booking booking) async {
    // Placeholder for saving new bookings
    throw UnimplementedError('Saving to JSON files not implemented');
  }

  Future<void> updateBooking(Booking booking) async {
    // Placeholder for updating bookings
    throw UnimplementedError('Updating JSON files not implemented');
  }

  Future<void> deleteBooking(String id) async {
    // Placeholder for deleting bookings
    throw UnimplementedError('Deleting from JSON files not implemented');
  }
}
