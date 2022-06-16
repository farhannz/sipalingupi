import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';
import 'package:sipaling_upi/screens/notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _IndeksPrestasi {
  DateTime tahun;
  double ipk;

  _IndeksPrestasi(this.tahun, this.ipk);
}

class IndeksPrestasi {
  var data;

  IndeksPrestasi(List<dynamic> json) {
    List<_IndeksPrestasi> tmp = [];
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    for (var y in json[0]['ipk']) {
      if (y != null) {
        tmp.add(_IndeksPrestasi(new DateTime(y['tahun']), y['ipk']));
      }
    }
    for (var x in tmp) {
      debugPrint(x.tahun.toString());
      debugPrint(x.ipk.toString());
    }
    data = charts.TimeSeriesChart(
      [
        charts.Series<_IndeksPrestasi, DateTime>(
          id: 'Indeks Prestasi',
          fillColorFn: (_, __) => charts.Color(r: 255, g: 204, b: 0),
          colorFn: (_, __) => charts.Color(r: 189, g: 35, b: 35),
          data: tmp,
          domainFn: (_IndeksPrestasi ip, _) => ip.tahun,
          measureFn: (_IndeksPrestasi ip, _) => ip.ipk,
        )
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        radiusPx: 5,
        strokeWidthPx: 3,
        includePoints: true,
        includeLine: true,
      ),
    );
    // }
  }

  factory IndeksPrestasi.fromJson(List<dynamic> json) {
    return IndeksPrestasi(json);
  }
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();
  String searchText = "";
  bool isDarkMode = false;

  var apiPath = 'https://sipalingupi-api.herokuapp.com/';
  late Future<IndeksPrestasi> futureIndeksPrestasi;
  Future<IndeksPrestasi> fetchData() async {
    final response = await http.get(Uri.parse(apiPath + 'ipks'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return IndeksPrestasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureIndeksPrestasi = fetchData();
  }

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
        backgroundColor: Colors.white,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          controller: ScrollController(),
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'User',
                style: TextStyle(
                  fontFamily: "Poppins", // Poppins semi-bold, 25
                  fontSize: 22.0,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_outlined),
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: "Poppins", // Poppins semi-bold, 25
                  fontSize: 22.0,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bookmark_outline),
              title: Text(
                'Bookmark',
                style: TextStyle(
                  fontFamily: "Poppins", // Poppins semi-bold, 25
                  fontSize: 22.0,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontFamily: "Poppins", // Poppins semi-bold, 25
                    fontSize: 22.0,
                    color: Colors.black,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                )),
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
                              padding: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
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
                            FutureBuilder<IndeksPrestasi>(
                              future: futureIndeksPrestasi,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 15,
                                        ),
                                        child: Text(
                                          "Indeks Prestasi",
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
                                        child: snapshot.data?.data,
                                      ),
                                    ),
                                  ]);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            ListView.builder(
                              controller: ScrollController(),
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
