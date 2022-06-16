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
    // print(tmp);
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

    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);

    // int i = 0;
    // for (var y in json[0]['ipk']) {
    //   if (y != null) {
    //     minYear = (minYear > y['tahun']) ? y['tahun'] : minYear;
    //     isi?.add(FlSpot(y['tahun'].toDouble(), y['ipk']));
    //     i++;
    //   }
    // }
    // }
  }

  factory Publikasi.fromJson(List<dynamic> json) {
    return Publikasi(json);
  }
}

class _Keketatan {
  DateTime tahun;
  double keketatan;

  _Keketatan(this.tahun, this.keketatan);
}

class Keketatan {
  var data;

  Keketatan(List<dynamic> json) {
    List<_Keketatan> tmp = [];
    // int minYear = 9999999;
    // for (var x in json) {
    //   debugPrint(x['fakId']);
    for (var y in json[0]['keketatan']) {
      if (y != null) {
        tmp.add(_Keketatan(new DateTime(y['tahun']), y['keketatan']));
      }
    }
    // for (var x in tmp) {
    //   debugPrint(x.tahun.toString());
    //   debugPrint(x.keketatan.toString());
    // }
    data = charts.TimeSeriesChart(
      [
        charts.Series<_Keketatan, DateTime>(
          id: 'Keketatan',
          fillColorFn: (_, __) => charts.Color(r: 255, g: 204, b: 0),
          colorFn: (_, __) => charts.Color(r: 189, g: 35, b: 35),
          data: tmp,
          domainFn: (_Keketatan keketatan, _) => keketatan.tahun,
          measureFn: (_Keketatan keketatan, _) => keketatan.keketatan,
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

class _ProdiPageState extends State<ProdiPage> {
  var textController = TextEditingController();
  String searchText = "";
  bool isDarkMode = false;

  var apiPath = 'https://sipalingupi-api.herokuapp.com/prodis/';

  var prodi = 'Ilmu Komputer';

  void changeProdi(prodi) {
    setState(() {
      this.prodi = prodi;
    });

    futureProdi = fetchDataProdi();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
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

  @override
  void initState() {
    super.initState();
    futureProdi = fetchDataProdi();
    futureIndeksPrestasi = fetchDataIPK();
    futureKeketatan = fetchDataKeketatan();
    futurePublikasi = fetchDataPublikasi();
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
                            FutureBuilder<Prodi>(
                              future: futureProdi,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      child: DropdownButton<String>(
                                        value: this.prodi,
                                        icon: const Icon(Icons.arrow_drop_down,
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
                                          "Keketatan",
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
