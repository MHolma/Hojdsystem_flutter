import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() {
  runApp(const MyApp());
  FlutterDisplayMode.setHighRefreshRate();
}

TextEditingController myController = TextEditingController();
final TextEditingController myController2 = TextEditingController();
var tal = "0";
var text1 = "";
var text2 = "";
var dropdownValue;
var hojd = 0.0;
int hojdNN = 0;
int hojdN60 = 0;
int hojdN2000 = 0;
int hojdMV2020 = 0;
var hojd2 = 700.0;
var hojd3 = 330;
var hojd4 = "0";
var hojdNNlabel = "";
var hojdN60label = "";
var hojdN2000label = "";
var hojdMV2020label = "";
bool show = true;
const List<String> list = <String>["NN", "N60", "N2000", "MV2020"];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Höjdsystem 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Höjdsystem'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        final int dialogOpen = prefs.getInt('dialog_open') ?? 0;
        if (dialogOpen == 0) {
          showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Varning!'),
              content: const Text(
                  'Appen bör användas endast av personer med tillräcklig kunskap om höjdsystem.\nAppens utvecklare tar inget ansvar för eventuella fel'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    show = false;
                    Navigator.pop(context);
                  },
                  child: const Text('Godkänn'),
                ),
              ],
            ),
          );
          prefs.setInt("dialog_open", 1);
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.w300)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    SizedBox(
                      width: 170,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              hint: const Text(
                                "Välj Höjdsystem",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                                calc();

                                //myController2.text = "0";
                                /*hojd2 = 440;
                                  hojd4 = 0;
                                  hojdNN = 0;
                                  hojdN60 = 0;
                                  hojdN2000 = 0;
                                  hojdMV2020 = 0;
                                  myController2.text = "0";
                                  hojdNNlabel = "";
                                  hojdN60label = "";
                                  hojdN2000label = "";
                                  hojdMV2020label = "";*/
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    SizedBox(
                      width: 170,
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: myController2,
                        decoration: const InputDecoration(
                            //border: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            labelText: 'Ange höjd i mm',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                color: Colors.black54),
                            floatingLabelStyle:
                                TextStyle(fontWeight: FontWeight.w300),
                            contentPadding: EdgeInsets.all(11)),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                        onChanged: (value) {
                          calc();
                          setState(() {
                            
                            /*hojd2 = 440;
                            hojd4 = 0;
                            hojdNN = 0;
                            hojdN60 = 0;
                            hojdN2000 = 0;
                            hojdMV2020 = 0;*/
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Text(
                      hojdNNlabel,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      hojdN60label,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      hojdN2000label,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      hojdMV2020label,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 542,
                  width: 500,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Bild.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    margin:
                        EdgeInsets.fromLTRB(hojd3.toDouble(), (hojd2), 0, 0),
                    child: const Text(
                      "Angiven höjd:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                CustomPaint(
                  //                       <-- CustomPaint widget
                  size: const Size(400, 100),
                  painter: MyPainter(),
                ),
                const Text(
                  "Developed by Ingenjörsbyrå M Holma",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}

void calc() {
  CustomPaint(
    //                       <-- CustomPaint widget
    size: const Size(400, 100),
    painter: MyPainter(),
  );

  //hojd2 = 440;
  hojd4 = "0";
  hojdNN = 0;
  hojdN60 = 0;
  hojdN2000 = 0;
  hojdMV2020 = 0;
  //myController2.text = "0";
  hojdNNlabel = "";
  hojdN60label = "";
  hojdN2000label = "";
  hojdMV2020label = "";

  if (myController2.text != "") {
    if (dropdownValue == "NN") {
      hojdNN = int.parse(myController2.text);
      hojdN60 = int.parse(myController2.text) + 395;
      hojdN2000 = int.parse(myController2.text) + 835;
      hojdMV2020 = int.parse(myController2.text) + 762;
      hojdNNlabel = "Höjd i NN: $hojdNN mm";
      hojdN60label = "Höjd i N60: $hojdN60 mm";
      hojdN2000label = "Höjd i N2000: $hojdN2000 mm";
      hojdMV2020label = "Höjd i MV2020: $hojdMV2020 mm";
      if (myController2 != "") {
        if (kIsWeb) {
          if (hojdN2000 < 2140) {
            hojd2 = (474 - 0.245 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 400;
          }
        } else {
          if (hojdN2000 < 2140) {
            hojd2 = (442 - 0.207 * hojdN2000);
          } else {
            hojd2 = 1140;
            hojd3 = 330;
          }
        }
      } else {
        hojd2 = 200;
      }
    }
    if (dropdownValue == "N60") {
      hojdNN = int.parse(myController2.text) - 395;
      hojdN60 = int.parse(myController2.text);
      hojdN2000 = int.parse(myController2.text) + 440;
      hojdMV2020 = int.parse(myController2.text) + 367;
      hojdNNlabel = "Höjd i NN: $hojdNN mm";
      hojdN60label = "Höjd i N60: $hojdN60 mm";
      hojdN2000label = "Höjd i N2000: $hojdN2000 mm";
      hojdMV2020label = "Höjd i MV2020: $hojdMV2020 mm";
      if (myController2 != "") {
        if (kIsWeb) {
          if (hojdN2000 < 2140) {
            hojd2 = (475 - 0.245 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 400;
          }
        } else {
          if (hojdN2000 < 2140) {
            hojd2 = (442 - 0.207 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 330;
          }
        }
      } else {
        hojd2 = 200;
      }
    }
    if (dropdownValue == "N2000") {
      hojdNN = int.parse(myController2.text) - 835;
      hojdN60 = int.parse(myController2.text) - 440;
      hojdN2000 = int.parse(myController2.text);
      hojdMV2020 = int.parse(myController2.text) - 73;
      hojdNNlabel = "Höjd i NN: $hojdNN mm";
      hojdN60label = "Höjd i N60: $hojdN60 mm";
      hojdN2000label = "Höjd i N2000: $hojdN2000 mm";
      hojdMV2020label = "Höjd i MV2020: $hojdMV2020 mm";
      if (myController2 != "") {
        if (kIsWeb) {
          if (hojdN2000 < 2140) {
            hojd2 = (475 - 0.245 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 400;
          }
        } else {
          if (hojdN2000 < 2140) {
            hojd2 = (440 - 0.207 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 330;
          }
        }
      } else {
        hojd2 = 0;
        hojd3 = 0;
      }
    }
    if (dropdownValue == "MV2020") {
      hojdNN = int.parse(myController2.text) - 762;
      hojdN60 = int.parse(myController2.text) - 367;
      hojdN2000 = int.parse(myController2.text) + 73;
      hojdMV2020 = int.parse(myController2.text);
      hojdNNlabel = "Höjd i NN: $hojdNN mm";
      hojdN60label = "Höjd i N60: $hojdN60 mm";
      hojdN2000label = "Höjd i N2000: $hojdN2000 mm";
      hojdMV2020label = "Höjd i MV2020: $hojdMV2020 mm";
      if (myController2 != "") {
        if (kIsWeb) {
          if (hojdN2000 < 2140) {
            hojd2 = (475 - 0.245 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 400;
          }
        } else {
          if (hojdN2000 < 2140) {
            hojd2 = (440 - 0.207 * hojdN2000);
          } else {
            hojd2 = 2140;
            hojd3 = 330;
          }
        }
      } else {
        hojd2 = 200;
      }
    }
  }
  if (myController2.text == "") {
    if (dropdownValue == "NN") {
      hojd2 = 269;
      
    }
    if (dropdownValue == "N60") {
      hojd2 = 351;
      
    }
    if (dropdownValue == "N2000") {
      hojd2 = 440;
      
    }
    if (dropdownValue == "MV2020") {
      hojd2 = 425;
      
    }
  }
}

class MyPainter extends CustomPainter {
  @override
  //var hojd4 = hojd3;

  void paint(Canvas canvas, Size size) {
    //if (dropdownValue == "NN") {
    if (dropdownValue == "NN") {
      if (kIsWeb) {
        var hojd4 = (-42 - 0.245 * hojdNN);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      } else {
        var hojd4 = (-254 - 0.2060 * hojdNN);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      }
    }
    if (dropdownValue == "N60") {
      if (kIsWeb) {
        var hojd4 = (-42 - 0.245 * hojdN60);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      } else {
        var hojd4 = (-172 - 0.2060 * hojdN60);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      }
    }
    if (dropdownValue == "N2000") {
      if (kIsWeb) {
        var hojd4 = (-42 - 0.245 * hojdN2000);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      } else {
        var hojd4 = (-83 - 0.2060 * hojdN2000);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      }
    }
    if (dropdownValue == "MV2020") {
      if (kIsWeb) {
        var hojd4 = (-42 - 0.245 * hojdMV2020);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      } else {
        var hojd4 = (-98 - 0.2060 * hojdMV2020);
        final pointMode = ui.PointMode.polygon;
        final points = [
          Offset(5, hojd4),
          Offset(400, hojd4),
          //Offset(400, hojd1 - 10),
          //Offset(380, hojd1 - 10),
          //Offset(270, 100),
        ];
        if (hojdN2000 <= 2139) {
          final paint = Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          canvas.drawPoints(pointMode, points, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
