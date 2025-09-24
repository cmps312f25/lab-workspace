void main() {
  sayHello("Alice");
  print(subNamed(a: 5, b: 10));
  print(subNamed(b: 10, a: 5));
  print(subNamed(a: 5));

  print(sub(5, 10));
  print(sub(10, 5));
}

void sayHello(String name) {
  print('Hello $name');
}

var display = (n) => print(n);

// named parameters
int subNamed({required int a, int b = 0}) {
  return a - b;
}

int sub(int a, int b, [int c = 0, int d = 0]) {
  return a - b - c - d;
}
