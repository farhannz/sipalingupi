import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';
import 'package:sipaling_upi/screens/notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Dashboard',
              style: TextStyle(
                fontFamily: "Poppins", // Poppins semi-bold, 25
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
                color: Colors.black,
              ),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text: 'SIPALING UPI',
              style: TextStyle(
                fontFamily: "Poppins", // Poppins Light, 15
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
                color: Colors.black,
              ),
            )
          ]),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 0,
      ),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Icon(Icons.person),
                Text(
                  'User',
                  style: TextStyle(
                    fontFamily: "Poppins", // Poppins semi-bold, 25
                    fontSize: 22.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.notifications_none_outlined),
                Text('Notifications'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.bookmark_outline),
                Text('Bookmark'),
              ],
            ),
            Column(
              children: [
                Text("Dark Mode"),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // SliverAppBar(
                //   automaticallyImplyLeading: false,
                //   expandedHeight: 60,
                //   pinned: true,
                //   backgroundColor: Colors.white,
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Align(
                //             alignment: Alignment.topLeft,
                //             child: Padding(
                //               padding: EdgeInsets.only(
                //                 top: 20.0,
                //               ),
                //               child: Text(
                //                 "Dashboard",
                //                 textAlign: TextAlign.left,
                //                 style: TextStyle(
                //                   fontFamily:
                //                       "Poppins", // Poppins semi-bold, 25
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 22.0,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Align(
                //             alignment: Alignment.bottomLeft,
                //             child: Padding(
                //               padding: EdgeInsets.only(
                //                 bottom: 15.0,
                //               ),
                //               child: Text(
                //                 "SIPALING-UPI",
                //                 textAlign: TextAlign.left,
                //                 style: TextStyle(
                //                   fontFamily: "Poppins", // Poppins Light, 15
                //                   fontWeight: FontWeight.w300,
                //                   fontSize: 12.0,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       // Menu hamburger sebelah kanan
                //       // Align(
                //       //   alignment: Alignment.topRight,
                //       //   child: ElevatedButton(
                //       //     onPressed: () => {},
                //       //     style: ElevatedButton.styleFrom(
                //       //       primary: Colors.white,
                //       //       minimumSize: Size(35, 35),
                //       //       shape: RoundedRectangleBorder(
                //       //           //to set border radius to button
                //       //           borderRadius: BorderRadius.circular(10)),
                //       //     ),
                //       //     child: Icon(
                //       //       Icons.menu,
                //       //       size: 40,
                //       //       color: Colors.red,
                //       //     ),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        width: screenSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  label: Text('Search Data'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => {},
                                    child: Text("Peringkat"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => {},
                                    child: Text("Akreditasi"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => {},
                                    child: Text("Prestasi"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => {},
                                    child: Text("Penelitian"),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
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
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
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
                    ),
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
