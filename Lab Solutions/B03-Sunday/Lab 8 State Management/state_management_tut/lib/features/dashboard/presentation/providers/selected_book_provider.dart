import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/features/dashboard/domain/entities/book.dart';

class SelectedBookNotifier extends Notifier<Book?> {
  @override
  build() => null;

  void select(Book? book) => state = book;
  void clear() => state = null;
}

final selectedBookProvider = NotifierProvider<SelectedBookNotifier, Book?>(
  SelectedBookNotifier.new,
);
