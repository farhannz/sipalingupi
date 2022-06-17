import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';
import 'package:sipaling_upi/screens/notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

var _warna = [
  Color.fromARGB(255, 189, 35, 35),
  Color.fromARGB(255, 255, 204, 0),
  Colors.black
];

class ProdiPage extends StatefulWidget {
  const ProdiPage({Key? key}) : super(key: key);

  @override
  State<ProdiPage> createState() => _ProdiPageState();
}

class _IndeksPrestasi {
  DateTime tahun;
  double ipk;

  _IndeksPrestasi(this.tahun, this.ipk);
}

class IndeksPrestasi {
  List<FlSpot>? isi = [];
  int minYear = 99999;
  IndeksPrestasi(List<dynamic> json) {
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    int i = 0;
    for (var y in json[0]['ipk']) {
      if (y != null) {
        minYear = (minYear > y['tahun']) ? y['tahun'] : minYear;
        isi?.add(FlSpot(y['tahun'].toDouble(), y['ipk']));
        i++;
      }
    }
    // }
  }

  factory IndeksPrestasi.fromJson(List<dynamic> json) {
    return IndeksPrestasi(json);
  }
}

class Publikasi {
  List<BarChartGroupData>? publikasi = [];
  int minYear = 99999;

  Publikasi(List<dynamic> json) {
    Map<String, dynamic> tmp = Map<String, dynamic>();
    for (var x in json) {
      for (var y in x['publikasi']) {
        if (y != null) {
          if (tmp[y['tahun'].toString()] != null) {
            tmp[y['tahun'].toString()] = {
              "jumlah": y['jumlah'] + tmp[y['jumlah'].toString()]['jumlah'],
            };
          } else {
            tmp[y['tahun'].toString()] = {"jumlah": y['jumlah']};
          }
        }
      }
    }

    int i = 0;
    for (var key in tmp.keys) {
      publikasi?.add(
        BarChartGroupData(
          x: int.parse(key),
          barRods: [
            BarChartRodData(
              color: _warna[0],
              toY: tmp[key]['jumlah'],
            ),
          ],
        ),
      );
    }
  }

  factory Publikasi.fromJson(List<dynamic> json) {
    return Publikasi(json);
  }
}

class Mahasiswa {
  List<PieChartSectionData>? gender = [];
  List<PieChartSectionData>? jalur = [];
  Mahasiswa(List<dynamic> json) {
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    Map<String, dynamic> tmp = Map<String, dynamic>();
    int i = 1;
    num totalData = 0;
    for (var x in json) {
      for (var y in x['gender']) {
        if (y != null) {
          if (tmp[y['id']] != null) {
            tmp[y['id']] = {"jumlah": y['jumlah'] + tmp[y['id']]['jumlah']};
          } else {
            tmp[y['id']] = {"jumlah": y['jumlah']};
          }
          totalData += y['jumlah'];
        }
      }
    }
    i = 0;

    for (var key in tmp.keys) {
      // print(tmp[key]['jumlah']);
      if (tmp[key] != null) {
        gender?.add(
          PieChartSectionData(
            color: _warna[i % tmp.keys.length],
            value: tmp[key]['jumlah'],
            radius: 40.0,
            title: tmp[key]['jumlah'].toString(),
            titleStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
      i++;
    }

    tmp = {};
    for (var x in json) {
      for (var z in x['jalur']) {
        if (z != null) {
          if (tmp[z['id']] != null) {
            tmp[z['id']] = {"jumlah": z['jumlah'] + tmp[z['id']]['jumlah']};
          } else {
            tmp[z['id']] = {"jumlah": z['jumlah']};
          }
          totalData += z['jumlah'];
        }
      }
    }
    i = 0;

    for (var key in tmp.keys) {
      // print(tmp[key]['jumlah']);
      if (tmp[key] != null) {
        jalur?.add(
          PieChartSectionData(
            color: _warna[i % tmp.keys.length],
            value: tmp[key]['jumlah'],
            radius: 80.0,
            title: tmp[key]['jumlah'].toString(),
            titleStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
      i++;
    }
    // for (var x in json) {
    //   for (var y in x['gender']) {
    //     if (y != null) {
    //       if (tmp[y['id']] != null) {
    //         tmp[y['id']] = {
    //           "jumlah": y['jumlah'] + tmp[y['id']]['jumlah'],
    //           "count": i
    //         };
    //       } else {
    //         tmp[y['id']] = {"jumlah": y[''], "count": i};
    //       }
    //     }
    //   }
    //   i++;
    // }
    // for (var key in tmp.keys) {
    //   tmp[key]['jumlah'] = tmp[key]['jumlah'] / tmp[key]['count'];
    //   isi?.add(FlSpot(double.parse(key),
    //       double.parse(tmp[key]['jumlah'].toStringAsFixed(2))));
    // }
    // print(tmp);
    // }
  }

  factory Mahasiswa.fromJson(List<dynamic> json) {
    return Mahasiswa(json);
  }
}

class Dosen {
  List<PieChartSectionData>? gender = [];
  List<PieChartSectionData>? gelar = [];
  Dosen(List<dynamic> json) {
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    Map<String, dynamic> tmp = Map<String, dynamic>();
    int i = 1;
    num totalData = 0;
    for (var x in json) {
      for (var y in x['gender']) {
        if (y != null) {
          if (tmp[y['id']] != null) {
            tmp[y['id']] = {"jumlah": y['jumlah'] + tmp[y['id']]['jumlah']};
          } else {
            tmp[y['id']] = {"jumlah": y['jumlah']};
          }
          totalData += y['jumlah'];
        }
      }
    }
    i = 0;

    for (var key in tmp.keys) {
      // print(tmp[key]['jumlah']);
      if (tmp[key] != null) {
        gender?.add(
          PieChartSectionData(
            color: _warna[i % tmp.keys.length],
            value: tmp[key]['jumlah'],
            radius: 40.0,
            title: tmp[key]['jumlah'].toString(),
            titleStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
      i++;
    }
    tmp = {};
    for (var x in json) {
      for (var y in x['pendidikan']) {
        if (y != null) {
          if (tmp[y['gelar']] != null) {
            tmp[y['gelar']] = {
              "jumlah": y['jumlah'] + tmp[y['gelar']]['jumlah']
            };
          } else {
            tmp[y['gelar']] = {"jumlah": y['jumlah']};
          }
          totalData += y['jumlah'];
        }
      }
    }
    i = 0;

    for (var key in tmp.keys) {
      // print(tmp[key]['jumlah']);
      if (tmp[key] != null) {
        gelar?.add(
          PieChartSectionData(
            color: _warna[i % tmp.keys.length],
            value: tmp[key]['jumlah'],
            radius: 88.0,
            title: tmp[key]['jumlah'].toString(),
            titleStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
      i++;
    }
  }

  factory Dosen.fromJson(List<dynamic> json) {
    return Dosen(json);
  }
}

class _Keketatan {
  DateTime tahun;
  double keketatan;

  _Keketatan(this.tahun, this.keketatan);
}

// double _selectedIpk = 0.0;

class Keketatan {
  List<FlSpot>? isi = [];
  Keketatan(List<dynamic> json) {
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    Map<String, dynamic> tmp = Map<String, dynamic>();
    int i = 1;
    for (var x in json) {
      for (var y in x['keketatan']) {
        if (y != null) {
          if (tmp[y['tahun'].toString()] != null) {
            tmp[y['tahun'].toString()] = {
              "keketatan":
                  y['keketatan'] + tmp[y['tahun'].toString()]['keketatan'],
              "count": i
            };
          } else {
            tmp[y['tahun'].toString()] = {
              "keketatan": y['keketatan'],
              "count": i
            };
          }
        }
      }
      i++;
    }
    for (var key in tmp.keys) {
      tmp[key]['keketatan'] = tmp[key]['keketatan'] / tmp[key]['count'];
      isi?.add(FlSpot(double.parse(key),
          double.parse(tmp[key]['keketatan'].toStringAsFixed(2))));
    }
    // print(tmp);
    // }
  }

  factory Keketatan.fromJson(List<dynamic> json) {
    return Keketatan(json);
  }
}

class _Prodi {
  String id;
  String fakId;

  _Prodi(this.id, this.fakId);
}

class Prodi {
  var data;

  Prodi(List<dynamic> json) {
    List<_Prodi> tmp = [];
    data = json;
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    for (var y in json) {
      if (y != null) {
        tmp.add(_Prodi(y['id'], y['fakId']));
      }
    }
    // for (var x in tmp) {
    //   debugPrint(x.id.toString());
    //   debugPrint(x.fakId.toString());
    // }
  }

  factory Prodi.fromJson(List<dynamic> json) {
    return Prodi(json);
  }
}

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

class _ProdiPageState extends State<ProdiPage> {
  var textController = TextEditingController();
  String searchText = "";
  bool isDarkMode = false;
  bool hasNotif = false;
  var apiPath = 'https://sipalingupi-api.herokuapp.com/prodis/';

  var prodi = 'Ilmu Komputer';

  void changeProdi(prodi) {
    setState(() {
      this.prodi = prodi;
    });

    futureProdi = fetchDataProdi();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
    futurePublikasi = fetchDataPublikasi();
    futureMahasiswa = fetchDataMahasiswa();
    futureDosen = fetchDataDosen();
    futureNotifications = fetchDataNotifications();
  }

  late Future<Prodi> futureProdi;
  Future<Prodi> fetchDataProdi() async {
    final response = await http.get(Uri.parse(apiPath));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Prodi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<IndeksPrestasi> futureIndeksPrestasi;
  Future<IndeksPrestasi> fetchDataIPK() async {
    final response = await http.get(Uri.parse(apiPath + this.prodi + '/ipks'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return IndeksPrestasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Keketatan> futureKeketatan;
  Future<Keketatan> fetchDataKeketatan() async {
    final response =
        await http.get(Uri.parse(apiPath + this.prodi + '/keketatans'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Keketatan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Publikasi> futurePublikasi;
  Future<Publikasi> fetchDataPublikasi() async {
    final response =
        await http.get(Uri.parse(apiPath + this.prodi + '/publikasis'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Publikasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Dosen> futureDosen;
  Future<Dosen> fetchDataDosen() async {
    final response =
        await http.get(Uri.parse(apiPath + this.prodi + '/dosens'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Dosen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Mahasiswa> futureMahasiswa;
  Future<Mahasiswa> fetchDataMahasiswa() async {
    final response =
        await http.get(Uri.parse(apiPath + this.prodi + '/mahasiswas'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Mahasiswa.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

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
    futureProdi = fetchDataProdi();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
    futurePublikasi = fetchDataPublikasi();
    futureMahasiswa = fetchDataMahasiswa();
    futureDosen = fetchDataDosen();
    futureNotifications = fetchDataNotifications();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      // endDrawer: Drawer(
      //   backgroundColor: Colors.white,
      //   // Add a ListView to the drawer. This ensures the user can scroll
      //   // through the options in the drawer if there isn't enough vertical
      //   // space to fit everything.
      //   child: ListView(
      //     controller: ScrollController(),
      //     // Important: Remove any padding from the ListView.
      //     // padding: EdgeInsets.zero,
      //     children: [
      //       ListTile(
      //         leading: Icon(Icons.person),
      //         title: Text(
      //           'User',
      //           style: TextStyle(
      //             fontFamily: "Poppins", // Poppins semi-bold, 25
      //             fontSize: 22.0,
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       FutureBuilder<Notifications>(
      //         future: futureNotifications,
      //         builder: (context, snapshot) {
      //           return ListTile(
      //             leading: new Stack(children: <Widget>[
      //               new Icon(Icons.notifications_none_outlined),
      //               if (snapshot.data?.hasNotif == true)
      //                 new Positioned(
      //                   // draw a red marble
      //                   top: 0.0,
      //                   right: 0.0,
      //                   child: new Icon(Icons.brightness_1,
      //                       size: 8.0, color: Colors.redAccent),
      //                 )
      //             ]),
      //             title: ElevatedButton(
      //               autofocus: true,
      //               onFocusChange: (val) {
      //                 changeProdi(this.prodi);
      //               },
      //               child: Text(
      //                 'Notifications',
      //                 style: TextStyle(
      //                   fontFamily: "Poppins", // Poppins semi-bold, 25
      //                   fontSize: 22.0,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               onPressed: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => NotificationScreen()),
      //                 );
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 alignment: Alignment.centerLeft,
      //                 padding: EdgeInsets.only(left: 0),
      //                 primary: Colors.transparent,
      //                 shadowColor: Colors.transparent,
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.bookmark_outline),
      //         title: Text(
      //           'Bookmark',
      //           style: TextStyle(
      //             fontFamily: "Poppins", // Poppins semi-bold, 25
      //             fontSize: 22.0,
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //           title: Text(
      //             "Dark Mode",
      //             style: TextStyle(
      //               fontFamily: "Poppins", // Poppins semi-bold, 25
      //               fontSize: 22.0,
      //               color: Colors.black,
      //             ),
      //           ),
      //           trailing: Switch(
      //             value: isDarkMode,
      //             onChanged: (value) {
      //               setState(() {
      //                 isDarkMode = value;
      //               });
      //             },
      //           )),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        width: screenSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FutureBuilder<Prodi>(
                              future: futureProdi,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      child: Container(
                                        width: screenSize - 40,
                                        child: DropdownButton<String>(
                                          value: this.prodi,
                                          icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.red),
                                          elevation: 16,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.red,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              changeProdi(newValue);
                                              print(this.prodi);
                                            });
                                          },
                                          items: snapshot.data?.data
                                              .map<DropdownMenuItem<String>>(
                                                  (var value) {
                                            return DropdownMenuItem<String>(
                                              value: value['id'],
                                              child: Text(value['id']),
                                            );
                                          }).toList(),
                                        ),
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            FutureBuilder<IndeksPrestasi>(
                              future: futureIndeksPrestasi,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(children: [
                                    FutureBuilder<Mahasiswa>(
                                      future: futureMahasiswa,
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
                                                  "Data Mahasiswa",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Jenis Kelamin',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    1.0,
                                                                child: PieChart(
                                                                  PieChartData(
                                                                    sectionsSpace:
                                                                        2.0,
                                                                    sections:
                                                                        snapshot
                                                                            .data
                                                                            ?.gender,
                                                                    centerSpaceRadius:
                                                                        48.0,
                                                                  ),
                                                                  swapAnimationCurve:
                                                                      Curves
                                                                          .linear,
                                                                  swapAnimationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              150),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              0],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Laki - Laki',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              1],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Perempuan',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    241,
                                                                    241),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Jalur Penerimaan',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    1.0,
                                                                child: PieChart(
                                                                  PieChartData(
                                                                    sectionsSpace:
                                                                        2.0,
                                                                    sections:
                                                                        snapshot
                                                                            .data
                                                                            ?.jalur,
                                                                    centerSpaceRadius:
                                                                        0,
                                                                  ),
                                                                  swapAnimationCurve:
                                                                      Curves
                                                                          .linear,
                                                                  swapAnimationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              150),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              1],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'SBMPTN',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              0],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'SNPMTN',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              2],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Mandiri',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    241,
                                                                    241),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    FutureBuilder<Dosen>(
                                      future: futureDosen,
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
                                                  "Data Dosen",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Jenis Kelamin',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    1.0,
                                                                child: PieChart(
                                                                  PieChartData(
                                                                    sectionsSpace:
                                                                        2.0,
                                                                    sections:
                                                                        snapshot
                                                                            .data
                                                                            ?.gender,
                                                                    centerSpaceRadius:
                                                                        48.0,
                                                                  ),
                                                                  swapAnimationCurve:
                                                                      Curves
                                                                          .linear,
                                                                  swapAnimationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              150),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              0],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Laki - Laki',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              1],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Perempuan',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    241,
                                                                    241),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Gelar Pendidikan',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    1.0,
                                                                child: PieChart(
                                                                  PieChartData(
                                                                    sectionsSpace:
                                                                        2.0,
                                                                    sections:
                                                                        snapshot
                                                                            .data
                                                                            ?.gelar,
                                                                    centerSpaceRadius:
                                                                        0,
                                                                  ),
                                                                  swapAnimationCurve:
                                                                      Curves
                                                                          .linear,
                                                                  swapAnimationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              150),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              0],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'S2',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color:
                                                                          _warna[
                                                                              1],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'S3',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: _warna[
                                                                            2]),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    241,
                                                                    241),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
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
                                      height: 250,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 20, right: 20),
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: LineTouchData(
                                                  touchTooltipData:
                                                      LineTouchTooltipData(
                                                    tooltipBgColor:
                                                        Colors.white,
                                                  ),
                                                  getTouchedSpotIndicator:
                                                      (_, indicators) {
                                                    return indicators.map(
                                                      (int index) {
                                                        return TouchedSpotIndicatorData(
                                                          FlLine(
                                                              strokeWidth: 0),
                                                          FlDotData(show: true),
                                                        );
                                                      },
                                                    ).toList();
                                                  },
                                                ),
                                                borderData: FlBorderData(
                                                    border: const Border(
                                                        bottom: BorderSide(),
                                                        left: BorderSide())),
                                                gridData:
                                                    FlGridData(show: false),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    color: Color.fromARGB(
                                                      255,
                                                      189,
                                                      35,
                                                      35,
                                                    ),
                                                    spots: snapshot.data?.isi,
                                                  ),
                                                ],
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      interval: 1.0,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return SideTitleWidget(
                                                          axisSide:
                                                              meta.axisSide,
                                                          space: 2.5,
                                                          child: Text(
                                                              value.toString()),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  topTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  rightTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            FutureBuilder<Publikasi>(
                              future: futurePublikasi,
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
                                          "Jumlah Publikasi",
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
                                      height: 250,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20, right: 20),
                                          child: BarChart(
                                            BarChartData(
                                              barTouchData: BarTouchData(
                                                touchTooltipData:
                                                    BarTouchTooltipData(
                                                        tooltipBgColor:
                                                            Colors.white),
                                              ),
                                              barGroups:
                                                  snapshot.data?.publikasi,
                                              titlesData: FlTitlesData(
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 1.0,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return SideTitleWidget(
                                                        axisSide: meta.axisSide,
                                                        space: 2.5,
                                                        child: Text(
                                                            value.toString()),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            FutureBuilder<Keketatan>(
                              future: futureKeketatan,
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
                                          "Keketatan - Universitas",
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
                                      height: 250,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: (Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          child: LineChart(
                                            LineChartData(
                                              lineTouchData: LineTouchData(
                                                touchTooltipData:
                                                    LineTouchTooltipData(
                                                  tooltipBgColor: Colors.white,
                                                ),
                                                getTouchedSpotIndicator:
                                                    (_, indicators) {
                                                  return indicators.map(
                                                    (int index) {
                                                      return TouchedSpotIndicatorData(
                                                        FlLine(strokeWidth: 0),
                                                        FlDotData(show: true),
                                                      );
                                                    },
                                                  ).toList();
                                                },
                                              ),
                                              borderData: FlBorderData(
                                                  border: const Border(
                                                      bottom: BorderSide(),
                                                      left: BorderSide())),
                                              gridData: FlGridData(show: false),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  color: Color.fromARGB(
                                                    255,
                                                    189,
                                                    35,
                                                    35,
                                                  ),
                                                  spots: snapshot.data?.isi,
                                                ),
                                              ],
                                              titlesData: FlTitlesData(
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 1.0,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return SideTitleWidget(
                                                        axisSide: meta.axisSide,
                                                        space: 2.5,
                                                        child: Text(
                                                            value.toString()),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            swapAnimationCurve: Curves.linear,
                                            swapAnimationDuration:
                                                Duration(milliseconds: 150),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ]);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    )
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
