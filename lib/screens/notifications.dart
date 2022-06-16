import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const NotificationScreen());

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Notifications {
  var data;
  bool hasNotif = false;
  Notifications(List<dynamic> json) {
    data = json;
    // print(data.length);
  }
  factory Notifications.fromJson(List<dynamic> json) {
    return Notifications(json);
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

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

  void updateNotif(String idx) async {
    String url = "https://sipalingupi-api.herokuapp.com/notifs/" + idx;
    print(url);
    final response = await http.patch(Uri.parse(url),
        body: jsonEncode({"read": true}),
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);
  }

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchDataNotifications();
  }

// [SliverAppBar]s are typically used in [CustomScrollView.slivers], which in
// turn can be placed in a [Scaffold.body].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.of(context, rootNavigator: true)
                              .pop(context)
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(45, 45),
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    //),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 22.0,
                        ),
                        child: Text(
                          "Notifications",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: "Poppins", // Poppins semi-bold, 25
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: FutureBuilder<Notifications>(
                    future: futureNotifications,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 0),
                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        updateNotif(snapshot
                                            .data!.data[index]['id']
                                            .toString());
                                        snapshot.data?.data[index]['read'] =
                                            true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (snapshot.data?.data[index]
                                                ['read'])
                                            ? Color.fromARGB(255, 255, 255, 255)
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                            // offset: Offset(0,7), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      height: 50,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${snapshot.data?.data[index]["message"]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: (snapshot.data?.data[index]
                                                    ['read'])
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        throw Exception("Gagal Fetch Data");
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  // child: ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: 5,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(top: 15.0),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: Color.fromARGB(255, 255, 255, 255),
                  //               borderRadius: BorderRadius.circular(10),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Colors.grey.withOpacity(0.5),
                  //                   spreadRadius: 0,
                  //                   blurRadius: 3,
                  //                   // offset: Offset(0,7), // changes position of shadow
                  //                 ),
                  //               ],
                  //             ),
                  //             height: 50,
                  //             child: Align(
                  //               alignment: Alignment.center,
                  //               child: Text(
                  //                 "$index",
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
