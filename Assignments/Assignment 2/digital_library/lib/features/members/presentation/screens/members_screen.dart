import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/member.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _dataService = DataService();
  List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _members = _dataService.getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build members screen with search bar, statistics, and list
    // Use DataService().searchMembers(query) for search
    // Navigate to member details on tap

    final totalMembers = _members.length;
    final students = _members.where((m) => m.getMemberType() == 'Student').length;
    final faculty = _members.where((m) => m.getMemberType() == 'Faculty').length;

    return Scaffold(
      body: Column(
        children: [
          const Text('[Search Bar]'),
          Row(
            children: [
              Text('Total: $totalMembers'),
              Text('Students: $students'),
              Text('Faculty: $faculty'),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                final borrowed = member.borrowedItems.where((i) => !i.isReturned).length;
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text('${member.email} - ${member.getMemberType()}'),
                  trailing: Text('$borrowed/${member.maxBorrowLimit}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
