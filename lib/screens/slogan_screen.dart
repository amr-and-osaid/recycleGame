import 'dart:async';
import 'dart:ui';

import 'package:cleanWise/app_data.dart';
import 'package:cleanWise/screens/root_screen.dart';
import 'package:flutter/material.dart';

class SloganScreen extends StatefulWidget {
  SloganScreen({Key key}) : super(key: key);

  @override
  _SloganScreenState createState() => _SloganScreenState();
}

class _SloganScreenState extends State<SloganScreen> {
  Timer timer;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();

    AppData.init();

    Timer.run(() {
      setState(() {
        _width = 200;
        _height = 200;
      });
    });

    Timer(Duration(seconds: 4), () {
      setState(() {
        _width = 0;
        _height = 0;
      });

      Timer(Duration(seconds: 1, milliseconds: 300), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RootScreen()),
            (Route<dynamic> route) => false);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: SafeArea(child: getSlogan()));
  }

  Widget getSlogan() {
    return Stack(
      children: [
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _width,
              height: _height,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: Image(
                image: AssetImage('assets/icon.png'),
                fit: BoxFit.contain,
                width: 200,
                height: 200,
              ),
            ),
            Text(
              'لعبة التدوير',
              style: TextStyle(
                fontSize: 30,
                color: Colors.green,
                fontFamily: 'tajawal',
              ),
            ),
            Text(
              'تعلم وأمرح',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'tajawal',
              ),
            )
          ],
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text("v" + AppData.appVersion,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'tajawal',
                )),
          ),
        )
      ],
    );
  }
}
