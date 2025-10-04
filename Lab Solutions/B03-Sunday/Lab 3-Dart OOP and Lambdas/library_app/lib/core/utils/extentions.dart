import 'package:library_app/domain/entities/book.dart';

extension MYGT on int {
  bool gt(int v) => this > v;
}

extension BookDisplay on List<Book> {
  void display() => this.forEach((book) => print(book));
}

void main() {
  int x = 10;
  int y = 20;
  print(50.gt(30));
}
