enum Order { PENDING, IN_PROGRESS, COMPLETED }

void main() {
  int x = 10;
  if (x > 5) {
    print("x is greater than 5");
  } else if (x == 5) {
    print("x is equal to 5");
  } else {
    print("x is less than or equal to 5");
  }

  switch (x) {
    case 5:
      print("x is 5");
      break;
    case 10:
      print("x is 10");
      break;
    default:
      print("x is neither 5 nor 10");
  }

  x = 40;

  String result = switch (x) {
    > 20 && < 40 => "x is between 20 and 40",
    _ => "x is not greater than 40",
  };

  print(result);

  var order = Order.PENDING;

  var r = switch (order) {
    Order.PENDING => "Order is pending",
    Order.IN_PROGRESS => "Order is in progress",
    Order.COMPLETED => "Order is completed",
  };

  print("The result is: $r");
}

/*

We use switch like this in flutter like this


String result = switch (x) {
    > 20 && < 40 => "x is between 20 and 40",
    _ => "x is not greater than 40",
  };
  
  for example in a real world example of flutter app
  show them where in flutter app is used switch statemen that return 

  suggest an example different from the one you provided.
  example of flutter app
  show them where in flutter app is used switch statemen that return


  */
