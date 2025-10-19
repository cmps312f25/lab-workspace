import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_notifier.dart';

class SessionsListPage extends ConsumerStatefulWidget {
  const SessionsListPage({super.key});

  @override
  ConsumerState<SessionsListPage> createState() => _SessionsListPageState();
}

class _SessionsListPageState extends ConsumerState<SessionsListPage> {
  bool showAvailableOnly = true;

  @override
  void initState() {
    super.initState();
    // Call the loadAvailableSessions() method using ref.read()
    Future.microtask(() {
      ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
    });
  }

  void _toggleFilter() {
    setState(() {
      showAvailableOnly = !showAvailableOnly;
    });
    // Call either loadAvailableSessions() or loadAllSessions() using ref.read()
    // depending on the showAvailableOnly value
    if (showAvailableOnly) {
      ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
    } else {
      ref.read(sessionNotifierProvider.notifier).loadAllSessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    // The state is now wrapped in AsyncValue because we're using AsyncNotifier
    // Watch the sessionNotifierProvider and access the sessions from AsyncValue
    final sessionDataAsync = ref.watch(sessionNotifierProvider);

    return Column(
      children: [
        // Filter Toggle
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.filter_alt, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Filter:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Available Only'),
                      icon: Icon(Icons.check_circle, size: 16),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('All Sessions'),
                      icon: Icon(Icons.list, size: 16),
                    ),
                  ],
                  selected: {showAvailableOnly},
                  onSelectionChanged: (Set<bool> selected) {
                    _toggleFilter();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: sessionDataAsync.when(
            data: (sessionData) {
              final sessions = sessionData.sessions;

              return sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            showAvailableOnly
                                ? 'No available sessions'
                                : 'No sessions found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final statusColor = session.isOpen ? Colors.green : Colors.grey;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              context.push('/session/${session.id}');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          session.courseId,
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
                                          session.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        session.location,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(session.start),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_formatTime(session.start)} - ${_formatTime(session.end)}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${session.capacity} spots available',
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
                      if (showAvailableOnly) {
                        ref.read(sessionNotifierProvider.notifier).loadAvailableSessions();
                      } else {
                        ref.read(sessionNotifierProvider.notifier).loadAllSessions();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
