import 'package:flutter/material.dart';
import 'package:sipaling_upi/components/floatingBar.dart';
import 'package:sipaling_upi/screens/notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sipaling_upi/screens/details/akreditasiScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

var _warna = [
  Color.fromARGB(255, 189, 35, 35),
  Color.fromARGB(255, 255, 204, 0),
  Colors.black
];

class FakultasPage extends StatefulWidget {
  const FakultasPage({Key? key}) : super(key: key);

  @override
  State<FakultasPage> createState() => _FakultasPageState();
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
    // print(json);
    Map<String, dynamic> tmp = Map<String, dynamic>();
    int i = 1;
    num totalData = 0;
    for (var x in json) {
      for (var y in x['publikasi']) {
        if (y != null) {
          if (tmp[y['tahun'].toString()] != null) {
            tmp[y['tahun'].toString()] = {
              "jumlah": y['jumlah'] + tmp[y['tahun'].toString()]['jumlah']
            };
          } else {
            tmp[y['tahun'].toString()] = {"jumlah": y['jumlah']};
          }
          totalData += y['jumlah'];
        }
      }
    }

    // print(tmp);
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

class _Fakultas {
  String id;
  String nama;

  _Fakultas(this.id, this.nama);
}

class Fakultas {
  var data;
  String akreditasi = "";
  var totalData = {};
  Fakultas(List<dynamic> json, String current) {
    List<_Fakultas> tmp = [];
    data = json;
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    for (var y in json) {
      if (y != null) {
        // tmp.add(_Prodi(y['id'], y['fakId'], y['akreditasi']));
        if (y['id'] == current) {
          akreditasi = y['akreditasi'];
          break;
        }
      }
    }

    for (var y in json) {
      var total = {'A': 0, 'B': 0, 'C': 0, "total": 0};
      if (y != null) {
        // tmp.add(_Prodi(y['id'], y['fakId'], y['akreditasi']));
        for (var z in y['prodis']) {
          // print(z['akreditasi']);
          total[z['akreditasi']] = total[z['akreditasi']]! + 1;
        }
        total['total'] = total['A']! + total['B']! + total['C']!;
        totalData[y['id']] = total;
        // print(totalData);
      }
    }
    // for (var x in tmp) {
    //   debugPrint(x.id.toString());
    //   debugPrint(x.fakId.toString());
    // }
  }

  factory Fakultas.fromJson(List<dynamic> json, String current) {
    return Fakultas(json, current);
  }
}

class _FakultasPageState extends State<FakultasPage> {
  var textController = TextEditingController();
  String searchText = "";
  bool isDarkMode = false;

  var apiPath = 'https://sipalingupi-api.herokuapp.com/faks/';

  var fakultas = 'FPMIPA';

  void changeFakultas(fakultas) {
    setState(() {
      this.fakultas = fakultas;
    });

    futureFakultas = fetchDataFakultas();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
    futureMahasiswa = fetchDataMahasiswa();
    futurePublikasi = fetchDataPublikasi();
    futureDosen = fetchDataDosen();
  }

  late Future<Fakultas> futureFakultas;
  Future<Fakultas> fetchDataFakultas() async {
    final response = await http.get(
        Uri.parse(apiPath.substring(0, apiPath.length - 1) + '?_embed=prodis'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Fakultas.fromJson(jsonDecode(response.body), this.fakultas);
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<IndeksPrestasi> futureIndeksPrestasi;
  Future<IndeksPrestasi> fetchDataIPK() async {
    final response =
        await http.get(Uri.parse(apiPath + this.fakultas + '/ipks'));
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
        await http.get(Uri.parse(apiPath + this.fakultas + '/keketatans'));
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
        await http.get(Uri.parse(apiPath + this.fakultas + '/publikasis'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Publikasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Mahasiswa> futureMahasiswa;
  Future<Mahasiswa> fetchDataMahasiswa() async {
    final response =
        await http.get(Uri.parse(apiPath + this.fakultas + '/mahasiswas'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Mahasiswa.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  late Future<Dosen> futureDosen;
  Future<Dosen> fetchDataDosen() async {
    final response =
        await http.get(Uri.parse(apiPath + this.fakultas + '/dosens'));
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      return Dosen.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureFakultas = fetchDataFakultas();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
    futureMahasiswa = fetchDataMahasiswa();
    futurePublikasi = fetchDataPublikasi();
    futureDosen = fetchDataDosen();
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
        // elevation: 0,
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
      //       ListTile(
      //         leading: Icon(Icons.notifications_none_outlined),
      //         title: Text(
      //           'Notifications',
      //           style: TextStyle(
      //             fontFamily: "Poppins", // Poppins semi-bold, 25
      //             fontSize: 22.0,
      //             color: Colors.black,
      //           ),
      //         ),
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
                            FutureBuilder<Fakultas>(
                              future: futureFakultas,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red),
                                          ),
                                          width: screenSize - 40,
                                          child: DropdownButtonHideUnderline(
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: DropdownButton<String>(
                                                  value: this.fakultas,
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
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      changeFakultas(newValue);
                                                    });
                                                  },
                                                  items: snapshot.data?.data
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (var value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value['id'],
                                                      child: Text(value['id']),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 0,
                                            left: 15,
                                          ),
                                          child: Text(
                                            "Akreditasi",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            left: 15,
                                          ),
                                          child: Text(
                                            snapshot.data!.akreditasi,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 56,
                                                color: Color.fromARGB(
                                                    255, 189, 35, 35)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      primary: Color.fromARGB(
                                                          255, 189, 35, 35),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AkreditasiScreen()),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .totalData[
                                                                  this.fakultas]
                                                                  ['total']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 28,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      primary: Color.fromARGB(
                                                          255, 189, 35, 35),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AkreditasiScreen()),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'A',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .totalData[
                                                                  this.fakultas]
                                                                  ['A']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 28,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      primary: Color.fromARGB(
                                                          255, 189, 35, 35),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NotificationScreen()),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'B',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .totalData[
                                                                  this.fakultas]
                                                                  ['B']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 28,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      minimumSize:
                                                          const Size.fromHeight(
                                                              50),
                                                      primary: Color.fromARGB(
                                                          255, 189, 35, 35),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NotificationScreen()),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'C',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .totalData[
                                                                  this.fakultas]
                                                                  ['C']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 28,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
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
                                                  top: 15,
                                                  bottom: 15,
                                                  left: 15,
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Text(
                                                                  'Jenis Kelamin',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                                                                  SizedBox(
                                                                      height:
                                                                          10),
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
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      320),
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Text(
                                                                  'Jalur Penerimaan',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      320),
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
                                                  top: 30,
                                                  bottom: 15,
                                                  left: 15,
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Text(
                                                                  'Jenis Kelamin',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                                                                  SizedBox(
                                                                      height:
                                                                          10),
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
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      320),
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
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Text(
                                                                  'Gelar Pendidikan',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                                                                  SizedBox(
                                                                      height:
                                                                          10),
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
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      320),
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
                                          top: 30,
                                          left: 15,
                                        ),
                                        child: Text(
                                          "Indeks Prestasi",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
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
                                        height: 250,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  bottom: 20,
                                                  right: 20),
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
                                                            FlDotData(
                                                                show: true),
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
                                                            child: Text(value
                                                                .toString()),
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
                                          top: 15,
                                          left: 15,
                                        ),
                                        child: Text(
                                          "Jumlah Publikasi",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
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
                                          top: 15,
                                          left: 15,
                                        ),
                                        child: Text(
                                          "Keketatan - Universitas",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
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
                                              swapAnimationCurve: Curves.linear,
                                              swapAnimationDuration:
                                                  Duration(milliseconds: 150),
                                            ),
                                          )),
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
