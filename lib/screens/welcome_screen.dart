import 'dart:async';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final Function startGame;
  WelcomeScreen(this.startGame, {Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _imageID = 1;
  Timer _timer;
  bool _showStart = true;
  int _girlID = 1;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        _imageID++;
        if (_imageID == 14) {
          _timer.cancel();
          Timer(Duration(seconds: 1), () {
            setState(() {
              _showStart = false;
            });
            _timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
              setState(() {
                _girlID = _girlID == 1 ? 2 : 1;
              });
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: _showStart
                ? Image(
                    gaplessPlayback: true,
                    image: AssetImage('assets/startup/$_imageID.png'),
                    fit: BoxFit.contain)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(flex: 1, fit: FlexFit.tight, child: Center()),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                              image: AssetImage('assets/welcome/play.png'),
                              fit: BoxFit.contain),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => widget.startGame(),
                            child: Image(
                                image:
                                    AssetImage('assets/welcome/quick_game.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                              image: AssetImage('assets/welcome/register.png'),
                              fit: BoxFit.contain),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image(
                              gaplessPlayback: true,
                              image:
                                  AssetImage('assets/welcome/girl$_girlID.png'),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
