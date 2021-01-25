import 'package:cleanWise/app_data.dart';
import 'package:flutter/material.dart';

class FinishScreen extends StatefulWidget {
  final Function startGame;
  FinishScreen(this.startGame, {Key key}) : super(key: key);

  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  bool win;

  @override
  void initState() {
    super.initState();

    win = !AppData.gameManager.maxMistakesReached;

    AppData.gameManager.pauseBg();
    if (win)
      AppData.gameManager.playWin();
    else
      AppData.gameManager.playLose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: GestureDetector(
            onTap: () {
              AppData.gameManager.resetGame();
              AppData.gameManager.playBgLoop();
              widget.startGame();
            },
            child: Image(
                image: AssetImage('assets/' + (win ? 'win' : 'lose') + '.png'),
                fit: BoxFit.fill),
          ),
        )));
  }
}
