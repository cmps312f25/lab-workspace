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
    // TODO 13: Load available sessions when page initializes
    // Call the loadAvailableSessions() method using ref.read()
  }

  void _toggleFilter() {
    setState(() {
      showAvailableOnly = !showAvailableOnly;
    });
    // TODO 15: Call the appropriate load method based on filter selection
    // Call either loadAvailableSessions() or loadAllSessions() using ref.read()
    // depending on the showAvailableOnly value
  }

  @override
  Widget build(BuildContext context) {
    // TODO 14: Watch the session AsyncValue state to get sessions list
    // The state is now wrapped in AsyncValue because we're using AsyncNotifier
    // Watch the sessionNotifierProvider and access the sessions from AsyncValue

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
        const Expanded(
          child: Center(child: Text('Complete the TODO to load data')),
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
