void main() {
  int x = 1;
  int y = 2;

  myOperator(x, y, add);
  myOperator(1, 2, add2);
  myOperator(1, 2, (r, a) => r + a);
}

void myOperator(a, b, theFunction) {
  print("a = $a , b = $b = ${theFunction(a, b)}");
}

int add(int a, int b) {
  return a + b;
}

var add2 = (int a, int b) => a + b;

// int add(int a, int b) {
//   return a + b;
// }

// int add2(a, b) {
//   return a + b;
// }

// int add3(a, b) => a + b;
// dynamic add4(a, b) => a + b;
// var add5 = (a, b) => a + b;

// String isEven(int num) {
//   if (num % 2 == 0)
//     return "It is even";
//   else
//     return "It is Odd";
// }

// var isEven2 = (int num) => (num % 2 == 0) ? "It is even" : "It is Odd";
