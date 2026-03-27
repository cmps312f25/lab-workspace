// Basics of dart programming language
// 1. Variables
// 2. Data Types
// 3. Control Flow
// 4. Functions

void main() {
  print('Hello welcome to CMPS312 Mobile app development');

  String name = "John Doe";
  print('My name is $name');

  // int
  int age = 44;
  print('My age is $age');

  // double
  double height = 5.9;
  print('My height is $height');

  bool isMarried = true;
  print('Am I married? $isMarried');

  String veryLongString = """
      This is a very long string that spans multiple lines.
      It can be used to represent 
      \n large blocks of text. 
    """;

  print(veryLongString);

  dynamic d = "hello";
  print(d);

  d = 10;
  print(d);

  const double PI = 3.14;
  // final double time = Date.now().hour.toDouble();

  var x = 10;
}
