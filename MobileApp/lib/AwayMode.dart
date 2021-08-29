import 'package:flutter/material.dart';

class AwayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //Colors.blue[900],
          //Colors.blue[800],
          //Colors.blue[400]
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Away Mode",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "All features are now Active",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: ElevatedButton(
                                  child: Text('Away <=> Home'),
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[900],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 20),
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Sensors'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[400],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Notifications'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[400],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Door Lock'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[400],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Text('Layout'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[400],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
