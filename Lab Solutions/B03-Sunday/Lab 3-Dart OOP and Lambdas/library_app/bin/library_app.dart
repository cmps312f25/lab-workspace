import 'package:library_app/core/utils/extentions.dart';
import 'package:library_app/data/repositories/json_book_repo.dart';

void main(List<String> args) {
  JsonBookRepo repo = JsonBookRepo();
  var books = repo.getBooks();

  books.display();
}

// class Animal {}


// class Cat extends Animal {}

// class Eagle extends Animal with Flyable {}

// class Pigeon extends Animal with Flyable {}

// class Penguin extends Animal with Flyable {}


// mixin Flyable {
//   void canFly() {
//     print("I can fly");
//   }
// }
