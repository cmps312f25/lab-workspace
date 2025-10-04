import 'package:my_library/domain/entities/book.dart';

extension MyDisplay on List<Book> {
  void get display => this.forEach((ele) => print(ele));
}

// extension MyGT on int {
//   bool gt(int n) => this > n;
// }

// void main() {
//   print(10.gt(10));
// }
