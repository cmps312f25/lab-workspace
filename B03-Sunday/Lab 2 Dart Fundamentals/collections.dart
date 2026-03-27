void main() {
  var numbers = [11, 12, 3, 4, 5, 6];
  // for (var number in numbers) {
  //   print(number);
  // }

  numbers.forEach((n) => print(n));

  int total = numbers.reduce((acc, curr) => acc + curr);
  print(total);

  int multAll = numbers.fold(1, (acc, curr) => acc * curr);
  print(multAll);

  var mapped = numbers.map((n) => n * n);
  print(mapped);
}

void display(n) => print(n);

int add(int a, int b) {
  return a + b;
}
