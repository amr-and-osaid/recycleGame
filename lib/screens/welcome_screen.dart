import 'dart:async';

import 'package:recycle_game/screens/game_areas_screen.dart';
import 'package:flutter/material.dart';
import 'package:recycle_game/app_data.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  int _imageID = 1;
  Timer _timer;
  bool _showStart = true;
  int _girlID = 1;
  bool _starRepeat = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      AppData.cycleState(state);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppData.audioManager.playBgLoop();

    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if (!_starRepeat) _imageID++;
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
      if (_imageID >= 11 && _imageID <= 13) {
        _starRepeat = !_starRepeat;
        if (_starRepeat) AppData.audioManager.playStar();
      } else
        _starRepeat = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                          child: GestureDetector(
                            onTap: () {
                              AppData.gameManager.newGame();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => GameAreasScreen()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Image(
                                image:
                                    AssetImage('assets/welcome/new_game.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GameAreasScreen()),
                                    (Route<dynamic> route) => false),
                            child: Image(
                                image:
                                    AssetImage('assets/welcome/continue.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                      // Flexible(
                      //   flex: 1,
                      //   fit: FlexFit.tight,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Image(
                      //         image: AssetImage('assets/welcome/register.png'),
                      //         fit: BoxFit.contain),
                      //   ),
                      // ),
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
