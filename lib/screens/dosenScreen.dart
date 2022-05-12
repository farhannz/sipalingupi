import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';

class DosenScreen extends StatelessWidget {
  const DosenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 60,
                  pinned: true,
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Text(
                                "Dashboard",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily:
                                      "Poppins", // Poppins semi-bold, 25
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 15.0,
                              ),
                              child: Text(
                                "SIPALING-UPI",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "Poppins", // Poppins Light, 15
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Menu hamburger sebelah kanan
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size(35, 35),
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Icon(
                            Icons.menu,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingBar(),
            ),
          ],
        ),
      ),
    );
  }
}
