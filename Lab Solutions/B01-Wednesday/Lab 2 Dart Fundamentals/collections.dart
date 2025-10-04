void main() {
  List<int> myNumbers = [1, 21, 13, 41, 15, 61];

  // for (var num in myNumbers) {
  //   print(num);
  // }

  // myNumbers.forEach(display);
  myNumbers.forEach((n) => print(n));
  myNumbers.forEach((n) => print(n * 10));
  var newList = myNumbers.map((n) => n * n).where((n) => n % 2 == 0);

  int sum = myNumbers.reduce((acc, curr) => acc + curr);
  int max = myNumbers.reduce((acc, curr) => acc > curr ? acc : curr);
  int allMultiplied = myNumbers.fold(1, (acc, curr) => acc * curr);

  /*
    acc : 1 , curr : 21
    acc : 22 , curr : 13
    acc : 35 , curr : 41
    acc : 76 , curr : 15
    acc : 91 , curr : 61
    91
  */

  print(newList);
}

void display(int num) {
  print(num);
}
