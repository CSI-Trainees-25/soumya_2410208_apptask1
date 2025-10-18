import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.calendar_month,
    Icons.person,
    Icons.settings,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: Text(
          "INDEX",
          style: TextStyle(
            color: const Color.fromARGB(255, 252, 252, 252),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Checklist-rafiki 1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  "Tap + to add your tasks",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.white,

                    fontSize: 20,
                    letterSpacing: 0.75,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.grey[900],
        activeColor: Colors.deepPurpleAccent,
        inactiveColor: Colors.grey,
        iconSize: 28,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
