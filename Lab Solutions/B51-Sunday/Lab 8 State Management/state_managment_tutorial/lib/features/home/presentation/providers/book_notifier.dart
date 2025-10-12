// flutter pub add flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_managment_tutorial/features/home/domain/entities/book.dart';

class BookNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    return [];
  }
}

final bookNotifierProvider = NotifierProvider<BookNotifier, List<Book>>(
  () => BookNotifier(),
);
