import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:sipaling_upi/screens/dosenScreen.dart';
import 'package:sipaling_upi/screens/homePage.dart';
import 'package:sipaling_upi/screens/fakultasPage.dart';
import 'package:sipaling_upi/screens/prodiScreen.dart';

int _index = 0;

class FloatingBar extends StatefulWidget {
  const FloatingBar({Key? key}) : super(key: key);

  @override
  State<FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends State<FloatingBar> {
  Widget page = HomePage();
  @override
  Widget build(BuildContext context) {
    return FloatingNavbar(
      onTap: (int val) {
        //returns tab id which is user tapped
        switch (val) {
          case 0:
            {
              page = HomePage();
            }
            break;
          case 1:
            {
              page = FakultasPage();
            }
            break;
          case 2:
            {
              page = DosenScreen();
            }
            break;
          case 3:
            {
              page = ProdiScreen();
            }
            break;
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return page;
        }));
        setState(() => _index = val);
      },
      currentIndex: _index,
      items: [
        FloatingNavbarItem(icon: Icons.home),
        FloatingNavbarItem(icon: Icons.explore),
        FloatingNavbarItem(icon: Icons.chat_bubble_outline),
        FloatingNavbarItem(icon: Icons.settings),
      ],
      backgroundColor: Colors.white,
      borderRadius: 50,
      elevation: 100,
      itemBorderRadius: 50,
      selectedBackgroundColor: Colors.red,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.red,
      width: MediaQuery.of(context).size.width * 0.8,
    );
  }
}
