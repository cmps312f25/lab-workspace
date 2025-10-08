// Control Flows

// if else
// switch

void main() {
  int age = 20;

  if (age < 18) {
    print('You are a minor');
  } else if (age >= 18 && age < 65) {
    print('You are an adult');
  } else {
    print('You are a senior citizen');
  }

  // rewriting the above using switch statement

  print(switch (age) {
    > 0 && <= 18 => 'You are a minor',
    > 18 && <= 21 => 'You are a young adult',
    _ => 'You are an adult',
  });

  String days = 'T';

  switch (days) {
    case 'M':
      print("Monday");
      break;
    case 'T':
      print("Tuesday");
      break;
    case 'W':
      print("Wednesday");
      break;
  }
}
