extension DIVBY10 on int {
  bool get isDivBy10 => this % 10 == 0;
}

extension DisplayBooks on List<Book> {
  void get display => forEach((book) => print(book));
}
