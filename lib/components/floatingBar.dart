import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:sipaling_upi/screens/prodiPage.dart';
import 'package:sipaling_upi/screens/homePage.dart';
import 'package:sipaling_upi/screens/fakultasPage.dart';
import 'package:sipaling_upi/screens/notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int _index = 0;

class Notifications {
  var data;
  bool hasNotif = false;
  Notifications(List<dynamic> json) {
    for (var x in json) {
      if (x['read'] == false) {
        hasNotif = true;
        break;
      } else {
        hasNotif = false;
      }
    }
  }
  factory Notifications.fromJson(List<dynamic> json) {
    return Notifications(json);
  }
}

class FloatingBar extends StatefulWidget {
  const FloatingBar({Key? key}) : super(key: key);

  @override
  State<FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends State<FloatingBar> {
  Widget page = HomePage();

  late Future<Notifications> futureNotifications;
  Future<Notifications> fetchDataNotifications() async {
    final response = await http
        .get(Uri.parse('https://sipalingupi-api.herokuapp.com/users/1/notifs'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Notifications.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchDataNotifications();
  }

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
              page = ProdiPage();
            }
            break;
          case 3:
            {
              page = NotificationScreen();
            }
            break;
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return page;
        }));
        setState(() {
          if (val != 3) _index = val;
        });
      },
      currentIndex: _index,
      items: [
        FloatingNavbarItem(icon: Icons.home),
        FloatingNavbarItem(icon: Icons.school_rounded),
        FloatingNavbarItem(icon: Icons.business_rounded),
        FloatingNavbarItem(
          icon: Icons.settings,
          customWidget: FutureBuilder<Notifications>(
            future: futureNotifications,
            builder: (context, snapshot) {
              return new Stack(children: <Widget>[
                new Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.red,
                ),
                if (snapshot.data?.hasNotif == true)
                  new Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: new Icon(Icons.brightness_1,
                        size: 8.0, color: Colors.redAccent),
                  )
              ]);
            },
          ),
        ),
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
