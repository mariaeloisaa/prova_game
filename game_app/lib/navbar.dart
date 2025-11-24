import 'package:flutter/material.dart';
import 'home.dart';
import 'players_list.dart';
import 'ranking.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;

  void changeIndex(int newIndex) {
    setState(() => index = newIndex);
  }

  List<Widget> screens = [
    Home(),
    JogadoresListPage(),
    RankingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: screens.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Jogadores",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.leaderboard),
          //   label: "Ranking",
          // ),
        ],
      ),
    );
  }
}
