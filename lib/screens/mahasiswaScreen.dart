import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';

class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
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
                                "Data Mahasiswa",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily:
                                      "Poppins", // Poppins semi-bold, 25
                                  fontWeight: FontWeight.w700,
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
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        height: 200,
                        child: Text("chart"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 241, 241, 241),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 241, 241, 241),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 15,
                                        ),
                                        child: Text(
                                          "Lorem Ipsum",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 241, 241, 241),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.8),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            // offset: Offset(0,7), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: 200,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "$index",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                  ]),
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
