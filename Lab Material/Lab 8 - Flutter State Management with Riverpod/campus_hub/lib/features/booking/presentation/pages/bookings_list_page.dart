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
    // Requirements: Load bookings based on whether a studentId is provided
    // - If widget.studentId is not null, call loadBookingsByStudent()
    // - Otherwise, call loadAllBookings()
    // Hint: Use ref.read() for one-time actions in initState
    // Hint: You'll need an if-else statement to check widget.studentId
    // Hint: Access notifier methods using .notifier on the provider
  }

  @override
  Widget build(BuildContext context) {
    // TODO 19: Watch the booking state to get bookings list
    // Requirements: Watch the booking provider to get reactive updates
    // - Use ref.watch() to listen for state changes
    // - Get the bookings list from the state
    // Hint: Use ref.watch() in build() for reactive UI
    // Hint: The state object has a .bookings property
    // Hint: Replace the empty list below with the bookings from state

    // For now, using empty list until students implement TODOs
    final bookings = []; // Replace this with the bookings from state

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_online,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete the TODO to load bookings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
                        Color statusColor;
                        IconData statusIcon;

                        switch (booking.status.value) {
                          case 'confirmed':
                            statusColor = Colors.green;
                            statusIcon = Icons.check_circle;
                            break;
                          case 'pending':
                            statusColor = Colors.orange;
                            statusIcon = Icons.pending;
                            break;
                          case 'attended':
                            statusColor = Colors.blue;
                            statusIcon = Icons.done_all;
                            break;
                          case 'cancelled':
                            statusColor = Colors.red;
                            statusIcon = Icons.cancel;
                            break;
                          default:
                            statusColor = Colors.grey;
                            statusIcon = Icons.help;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              context.push('/booking/${booking.id}');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 24),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Session ${booking.sessionId}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: statusColor),
                                      ),
                                      child: Text(
                                        booking.status.value.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Booked: ${_formatDate(booking.bookedAt)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ),
                          ),
                        );
                      },
                    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
