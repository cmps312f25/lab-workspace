void main() {
  int age = 4;

  if (age >= 18 && age <= 65) {
    print("You are an adult.");
  } else if (age >= 13) {
    print("You are a teenager.");
  } else {
    print("You are a child.");
  }
  print("Program ends.");

  String day = "Monday";

  String whatToPrint = switch (age) {
    >= 18 && <= 65 => "You are an adult.",
    >= 13 => "You are a teenager.",
    _ => "You are a child.",
  };
  print(whatToPrint);

  switch (day) {
    case "Monday":
      print("It is the second day of the week.");
      break;
    case "Tuesday":
      print("It is the third day of the week.");
      break;
    default:
      print("It is not a day of the week.");
  }
}
