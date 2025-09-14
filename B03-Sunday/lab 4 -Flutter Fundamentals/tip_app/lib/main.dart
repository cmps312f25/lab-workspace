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
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle, size: 50),
                  title: Text("Abdulahi Hassen"),
                  subtitle: Text("Student"),
                  trailing: Icon(Icons.edit),
                ),
                Image.asset("images/happy_cat.jpg"),
                Text(
                  "Hello",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    backgroundColor: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 40, child: Container(color: Colors.red)),
                Card(
                  color: Colors.amber,
                  elevation: 10,
                  child: Text(
                    "I am Abdulahi Hassen",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
