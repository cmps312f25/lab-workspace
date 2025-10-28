void main() {
  print(operate(10, 5, add));
  print(operate(10, 5, sub));
  print(operate(10, 5, mul));
  print(operate(10, 5, div));
}

int add(int x, int y) {
  return x + y;
}

int addArrow(int x, int y) => x + y;

int sub(int x, int y) {
  return x - y;
}

int mul(int x, int y) {
  return x * y;
}

int div(int x, int y) {
  return x ~/ y;
}

int operate(int x, int y, Function(int, int) operation) {
  return operation(x, y);
}
