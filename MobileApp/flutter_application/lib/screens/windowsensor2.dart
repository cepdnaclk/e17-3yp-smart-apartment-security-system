import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/sensor.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class windowsensor2 extends StatefulWidget {
  late String value;
  windowsensor2({required this.value});
  @override
  _windowsensor2State createState() => _windowsensor2State(value);
}

class _windowsensor2State extends State<windowsensor2> {
  String value;
  _windowsensor2State(this.value);
  final double _borderRadius = 24;

  Future<List<sensor>> GetJson() async {
    final data = await http.get(Uri.parse(
        'https://10.0.2.2:3000/user/getwindowsensordetails/' + value));
    var JsonData = jsonDecode(data.body);
    List<sensor> items = [];
    for (var m in JsonData) {
      sensor n = sensor(m['uniqueid'], m['status'], m['type']);
      items.add(n);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Window Sensor Details'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (_) => sensors(value: value));
                Navigator.pushReplacement(context, route);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: GetJson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: const Center(
                  child: Text("Loading...."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(_borderRadius),
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Color(0xff73A1F9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff73A1F9),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: CustomPaint(
                              size: Size(100, 150),
                              painter: CustomCardShapePainter(_borderRadius,
                                  Color(0xff6DC8F3), Color(0xff73A1F9)),
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Icon(
                                    Icons.window_rounded,
                                    size: 50,
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].uniqueid,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontFamily: 'Avenir',
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        snapshot.data[index].status,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        snapshot.data[index].type,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                        ),
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
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class sensor {
  String type;
  String status;
  String uniqueid;
  sensor(this.type, this.status, this.uniqueid);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
