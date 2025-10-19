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
    // Call the appropriate load method using ref.read()
    // If widget.studentId is not null, load bookings by student
    // Otherwise, load all bookings
    Future.microtask(() {
      if (widget.studentId != null) {
        ref.read(bookingNotifierProvider.notifier).loadBookingsByStudent(widget.studentId!);
      } else {
        ref.read(bookingNotifierProvider.notifier).loadAllBookings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The state is now wrapped in AsyncValue because we're using AsyncNotifier
    // Watch the bookingNotifierProvider and access the bookings from AsyncValue
    final bookingDataAsync = ref.watch(bookingNotifierProvider);

    return bookingDataAsync.when(
      data: (bookingData) {
        final bookings = bookingData.bookings;

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

            switch (booking.status) {
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
                              booking.status.toUpperCase(),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.studentId != null) {
                  ref.read(bookingNotifierProvider.notifier).loadBookingsByStudent(widget.studentId!);
                } else {
                  ref.read(bookingNotifierProvider.notifier).loadAllBookings();
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
