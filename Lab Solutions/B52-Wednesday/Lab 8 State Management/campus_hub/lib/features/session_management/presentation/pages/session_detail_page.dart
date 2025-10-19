import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_notifier.dart';

class SessionDetailPage extends ConsumerStatefulWidget {
  final String sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  ConsumerState<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends ConsumerState<SessionDetailPage> {
  @override
  void initState() {
    super.initState();
    // TODO 16: Load session by ID when page initializes
    // Call the loadSessionById() method using ref.read()
    Future.microtask(() {
      ref.read(sessionNotifierProvider.notifier).loadSessionById(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO 17: Watch the session AsyncValue state to get selected session
    // The state is now wrapped in AsyncValue because we're using AsyncNotifier
    // Watch the sessionNotifierProvider and access the selectedSession from AsyncValue
    final sessionDataAsync = ref.watch(sessionNotifierProvider);

    return sessionDataAsync.when(
      data: (sessionData) {
        final session = sessionData.selectedSession;

        if (session == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No session data'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: session.isOpen
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: session.isOpen ? Colors.green : Colors.grey,
                  ),
                ),
                child: Text(
                  session.status.value.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: session.isOpen ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Course Info
              _buildInfoCard(
                'Course Information',
                Icons.book,
                Colors.blue,
                [
                  _buildInfoRow('Course', session.courseId),
                  _buildInfoRow('Location', session.location),
                ],
              ),
              const SizedBox(height: 16),

              // Schedule Info
              _buildInfoCard(
                'Schedule',
                Icons.schedule,
                Colors.orange,
                [
                  _buildInfoRow('Date', _formatDate(session.start)),
                  _buildInfoRow('Start Time', _formatTime(session.start)),
                  _buildInfoRow('End Time', _formatTime(session.end)),
                  _buildInfoRow(
                    'Duration',
                    '${session.end.difference(session.start).inHours} hours',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Capacity Info
              _buildInfoCard(
                'Capacity',
                Icons.people,
                Colors.purple,
                [
                  _buildInfoRow(
                    'Available Spots',
                    '${session.capacity}',
                  ),
                  _buildInfoRow('Status', session.isOpen ? 'Open' : 'Closed'),
                ],
              ),
              const SizedBox(height: 24),

              // Book Session Button
              if (session.isOpen)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showBookingDialog(context);
                    },
                    icon: const Icon(Icons.book_online),
                    label: const Text(
                      'Book This Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Session'),
        content: const Text('Would you like to book this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session booked successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
