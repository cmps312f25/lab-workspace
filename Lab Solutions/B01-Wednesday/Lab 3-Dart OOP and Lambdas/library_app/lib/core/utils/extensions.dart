import 'package:library_app/domain/entities/book.dart';

extension MYL on List<Book> {
  void get display => forEach((b) => print(b));
}

extension EQ on int {
  bool isEven(int x) => this % 2 == 0;
}
