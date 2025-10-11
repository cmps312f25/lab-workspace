import 'package:flutter/material.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/contracts/payable.dart';
import '../../domain/entities/faculty_member.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/student_member.dart';

class MemberDetailsScreen extends StatelessWidget {
  final String memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    // TODO: Build member details screen showing all member information
    final member = DataService().getMember(memberId);

    if (member == null) {
      return const Scaffold(
        body: Center(child: Text('Member not found')),
      );
    }

    final currentBorrowed = member.borrowedItems.where((i) => !i.isReturned).length;
    final totalBorrowed = member.borrowedItems.length;
    final overdue = member.getOverdueItems().length;

    return Scaffold(
      appBar: AppBar(title: const Text('Member Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Name: ${member.name}'),
          Text('Email: ${member.email}'),
          Text('Type: ${member.getMemberType()}'),
          Text('Member ID: ${member.memberId}'),
          Text('Join Date: ${member.joinDate}'),
          Text('Max Borrow: ${member.maxBorrowLimit}'),
          Text('Borrow Period: ${member.borrowPeriod} days'),
          if (member is StudentMember) Text('Student ID: ${member.studentId}'),
          if (member is FacultyMember) Text('Department: ${member.department}'),
          const SizedBox(height: 20),
          Text('Current: $currentBorrowed | Total: $totalBorrowed | Overdue: $overdue'),
          const SizedBox(height: 10),
          ...member.borrowedItems.map((borrowedItem) => Text(
            '${borrowedItem.item.title} - ${borrowedItem.isReturned ? "Returned" : "Due: ${borrowedItem.dueDate}"}',
          )),
          if (member is Payable) ...[
            const SizedBox(height: 20),
            Text('Fees: QR ${(member as Payable).calculateFees()}'),
          ],
        ],
      ),
    );
  }
}
