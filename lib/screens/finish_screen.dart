import 'package:cleanWise/app_data.dart';
import 'package:cleanWise/screens/game_screen.dart';
import 'package:cleanWise/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class FinishScreen extends StatefulWidget {
  final bool win;
  FinishScreen(this.win, {Key key}) : super(key: key);

  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen>
    with WidgetsBindingObserver {
  bool finishAllLevels;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppData.audioManager.playBgLoop();
        break;
      case AppLifecycleState.inactive:
        AppData.audioManager.pauseAll();
        break;
      case AppLifecycleState.paused:
        AppData.audioManager.pauseAll();
        break;
      case AppLifecycleState.detached:
        AppData.audioManager.pauseAll();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    finishAllLevels = widget.win && AppData.gameManager.isLastLevel;

    AppData.audioManager.pauseBg();
    if (widget.win)
      AppData.audioManager.playWin();
    else
      AppData.audioManager.playLose();

    if (widget.win) AppData.gameManager.nextLevel();
  }

  @override
  void dispose() {
    AppData.audioManager.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image(
                      image: AssetImage('assets/finish_screen/top_' +
                          (widget.win ? 'win' : 'lose') +
                          '.png'),
                      fit: BoxFit.fill),
                ),
              ),
              Flexible(
                child: Image(
                    image: AssetImage('assets/finish_screen/girl_' +
                        (widget.win ? 'win' : 'lose') +
                        '.png'),
                    fit: BoxFit.fill),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    AppData.audioManager.playBgLoop();

                    if (finishAllLevels)
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false);
                    else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => GameScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Image(
                      image: AssetImage('assets/finish_screen/button_' +
                          (finishAllLevels
                              ? 'home'
                              : widget.win
                                  ? 'win'
                                  : 'lose') +
                          '.png'),
                      fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        )));
  }
}
