import 'package:cleanWise/app_data.dart';
import 'package:cleanWise/screens/widgets/trash_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final Function finishGame;
  final Function exitGame;
  MainScreen(this.finishGame, this.exitGame, {Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> _trackWidgets;
  bool _showFlash = false;
  bool _showCloseConfirm = false;

  @override
  void initState() {
    super.initState();
    _trackWidgets = AppData.gameManager.getContainerList(_checkResults);
  }

  void nextTrash() {
    _showFlash = false;
    AppData.gameManager.nextTrash();
    _trackWidgets =
        _trackWidgets = AppData.gameManager.getContainerList(_checkResults);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkResults(bool correct) {
    if (correct)
      AppData.gameManager.incrementProgress();
    else
      AppData.gameManager.incrementMistakes();

    if (AppData.gameManager.maxMistakesReached ||
        AppData.gameManager.levelEndReached)
      widget.finishGame();
    else
      nextTrash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                    flex: 20,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Image(
                              gaplessPlayback: true,
                              image: AssetImage('assets/progress/' +
                                  AppData.gameManager.currentProgress
                                      .toString() +
                                  '.png'),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Center()),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        AppData.musicOn = !AppData.musicOn;
                                        if (AppData.musicOn)
                                          AppData.gameManager.playBgLoop();
                                        else
                                          AppData.gameManager.pauseBg();
                                        setState(() {});
                                      },
                                      child: Image(
                                        gaplessPlayback: true,
                                        image: AssetImage(
                                            'assets/controls/music' +
                                                (AppData.musicOn
                                                    ? ''
                                                    : '_mute') +
                                                '.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        AppData.soundOn = !AppData.soundOn;
                                        setState(() {});
                                      },
                                      child: Image(
                                        gaplessPlayback: true,
                                        image: AssetImage(
                                            'assets/controls/sound' +
                                                (AppData.soundOn
                                                    ? ''
                                                    : '_mute') +
                                                '.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showCloseConfirm = true;
                                        });
                                      },
                                      child: Image(
                                        gaplessPlayback: true,
                                        image: AssetImage(
                                            'assets/controls/close.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                // Flexible(
                                //     flex: 1,
                                //     fit: FlexFit.tight,
                                //     child: Center()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Flexible(
                    flex: 30,
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _trackWidgets
                          .map((e) =>
                              Flexible(flex: 30, fit: FlexFit.tight, child: e))
                          .toList(),
                    )),
                Flexible(
                    flex: 50,
                    fit: FlexFit.tight,
                    child: Center(
                      child: Row(
                        children: [
                          Flexible(
                              flex: 15, fit: FlexFit.tight, child: Center()),
                          Flexible(
                              flex: 70,
                              fit: FlexFit.tight,
                              child: Center(
                                  child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 120,
                                      backgroundColor: Color(0xff644CA2)),
                                  _showFlash
                                      ? Center()
                                      : TrashWidget(
                                          imageID: AppData
                                              .gameManager.currentTrashID)
                                ],
                              ))),
                          Flexible(
                              flex: 15, fit: FlexFit.tight, child: Center())
                        ],
                      ),
                    )),
              ],
            ),
            _showCloseConfirm
                ? Opacity(opacity: 0.6, child: Container(color: Colors.black))
                : Center(),
            _showCloseConfirm
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        widget.exitGame();
                      },
                      child: Image(
                        gaplessPlayback: true,
                        image: AssetImage('assets/controls/close_confirm.png'),
                      ),
                    ),
                  )
                : Center()
          ],
        )));
  }
}
