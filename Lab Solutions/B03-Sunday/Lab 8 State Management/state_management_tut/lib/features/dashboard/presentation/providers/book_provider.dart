import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class BookNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    return [];
  }
}
