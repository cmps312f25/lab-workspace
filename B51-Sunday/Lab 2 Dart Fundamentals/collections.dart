void display(n) {
  print(n);
}

void display2(n) => print(n);

void main() {
  var numbers = [1, 2, 3, 4, 5];
  print(numbers);

  // for (var number in numbers) {
  //   print(number);
  // }

  print("All numbers printed.");
  numbers.forEach((n) => print(n));

  // display specif number
  print(numbers.contains(83));

  // find it
  var found = numbers.indexOf(3);
  print(found);

  int sum = numbers.reduce((acc, curr) => acc + curr);
  print(sum);
}
