import 'package:flutter/material.dart';
import 'package:stocks/screens/home_screen.dart';
import 'package:stocks/screens/potfolio_screen.dart';

import 'market_screen.dart';
import 'news_screen.dart';

class MainBottomBar extends StatefulWidget {
  const MainBottomBar({super.key});

  @override
  State<MainBottomBar> createState() => _MainBottomBarState();
}

class _MainBottomBarState extends State<MainBottomBar> {
  final List _pages = [
    HomeScreen(),
    MarketScreen(),
    PotfolioScreen(),
    const NewsScreen(),
  ];

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DoubleStock')),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office), label: 'Market'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_2), label: 'Potfolio'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'News'),
        ],
        currentIndex: _selectedPage,
        onTap: (value) {
          setState(() {
            _selectedPage = value;
          });
        },
      ),
      body: _pages[_selectedPage],
    );
  }
}
