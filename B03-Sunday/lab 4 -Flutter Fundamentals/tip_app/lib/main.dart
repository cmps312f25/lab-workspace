import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.blue,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Icon(Icons.menu),
            title: Text("Tip App"),
            centerTitle: true,
            actions: [
              Icon(Icons.notification_add, color: Colors.blue),
              Icon(Icons.shopping_cart, color: Colors.red),
            ],
          ),
          body: Center(child: Text("Hello")),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            child: Icon(
              Icons.add,
              color: const Color.fromARGB(255, 218, 193, 193),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: "Bookings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
