int add(int a, int b) {
  return a + b;
}

int add2(int a, int b) => a + b;

int mul(int a, int b) {
  return a * b;
}

void display() => print('Hello I am a function');

// named variables

int add3({required int a, required int b}) {
  return a + b;
}

void main() {
  display();

  int result = add(5, 10);
  print('The sum is: $result');

  int result2 = add(5, 10);
  print('The sum2 is: $result2');

  // int result31 = add3(b: 5, a: 10);
  // int result32 = add3(a: 5, b: 10);

  // print('The sum3 is: $result3');
}
