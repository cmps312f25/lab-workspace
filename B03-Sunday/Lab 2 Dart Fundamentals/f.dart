void main() {
  dynamic x = [1, 2, 3, 4, -1, -2, 3, -5, 6, 8];

  var max = x.fold([], reducer);
  print(max);


  dynamic neg = x.fold([], (acc, b) => b < 0 ? acc.add(b) : acc);
  print(neg);
}

dynamic reducer(acc, b) {
  if (b % 2 == 0) acc.add(b);
  return acc;
}

int add(int a, int b) {
  return a + b;
}

int add2(int a, int b) => a + b;
var add3 = (int a, int b) => a + b;
var add4 = (a, b) => a + b;

int operation(int a, int b, fn) {
  return a + b;
}

int x(a, b) {
  return a + b;
}
