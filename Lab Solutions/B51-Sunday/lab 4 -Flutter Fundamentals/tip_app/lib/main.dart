import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tip Calculator",
      home: Container(
        color: const Color.fromARGB(255, 205, 215, 222),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Tip App "),
            centerTitle: true,
            leading: Icon(Icons.menu),
            actions: [
              Icon(Icons.notification_add),
              SizedBox(width: 10),
              Icon(Icons.production_quantity_limits),
            ],
          ),
          body: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 48.0, 8.0, 8.0),
                  child: Text(
                    "World!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      decoration: TextDecoration.none,
                      fontFamily: "arial",
                      fontWeight: FontWeight.w700,
                      backgroundColor: Colors.yellow,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Image.asset(
                  "images/dog.jpeg",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),

                Card(
                  shadowColor: Colors.red,
                  elevation: 20,
                  color: Colors.blue,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Image.asset(
                        "images/dog.jpeg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: "Business",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: "School",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
