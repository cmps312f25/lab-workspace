import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_notifier.dart';

class BookingsListPage extends ConsumerStatefulWidget {
  final String? studentId;

  const BookingsListPage({super.key, this.studentId});

  @override
  ConsumerState<BookingsListPage> createState() => _BookingsListPageState();
}

class _BookingsListPageState extends ConsumerState<BookingsListPage> {
  @override
  void initState() {
    super.initState();
    // TODO 18: Load bookings when page initializes
    // Call the appropriate load method using ref.read()
    // If widget.studentId is not null, load bookings by student
    // Otherwise, load all bookings
  }

  @override
  Widget build(BuildContext context) {
    // TODO 19: Watch the booking AsyncValue state to get bookings list
    // The state is now wrapped in AsyncValue because we're using AsyncNotifier
    // Watch the bookingNotifierProvider and access the bookings from AsyncValue

    return const Center(child: Text('Complete the TODO to load data'));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
