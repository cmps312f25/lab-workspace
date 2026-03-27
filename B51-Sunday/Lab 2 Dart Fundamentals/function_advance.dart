int add(int a, int b) {

  return a + b;
}

int sub(int a, int b) {

  return a - b;
}

double div(int a, int b) {

  return a / b;
}

int operation(int a, int b, Function(int, int) myFunction) {
  print(" $a and $b");
  return myFunction(a, b);
}

int main() {
  print('Addition: ${operation(5, 3, add)}');
  print('Subtraction: ${operation(5, 3, sub)}');
  print('Division: ${operation(5, 3, div)}');
  return 0;
}
