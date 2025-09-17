import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: Icon(Icons.menu, color: Colors.white),
          centerTitle: true,
          title: Text(
            "Tip App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Arial",
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Icon(Icons.settings, color: Colors.white),
            ),
            Icon(Icons.notification_add, color: Colors.white),
            SizedBox(width: 15),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.yellow,
                child: Text(
                  "Hello, World!",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Radio(value: 10),
              ElevatedButton(onPressed: () {}, child: Text("Click Me")),
              SizedBox(height: 20),
              Image.asset("images/elephant.png", width: 200, height: 200),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://c8.alamy.com/comp/EM8323/happy-elephant-cartoon-EM8323.jpg",
                ),
              ),

              Image.network(
                width: 200,
                height: 200,
                "https://c8.alamy.com/comp/EM8323/happy-elephant-cartoon-EM8323.jpg",
              ),
              Card(
                elevation: 20,
                shadowColor: Colors.blue,
                child: Text(
                  "Abdulahi, Hassen!",
                  style: TextStyle(
                    fontSize: 22,

                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 25,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
