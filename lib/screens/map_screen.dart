import 'package:cleanWise/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:cleanWise/app_data.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class LevelMark {
  bool open = false;
  bool passed = false;
  bool current = false;
  double x;
  double y;
  int levelID;

  LevelMark(this.levelID, this.x, this.y) {
    if (levelID <= AppData.gameManager.currentLevelID) open = true;
    if (levelID < AppData.gameManager.currentLevelID) passed = true;
    if (levelID == AppData.gameManager.currentLevelID) current = true;
  }
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (open) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => GameScreen(levelID)),
              (Route<dynamic> route) => false);
        }
      },
      child: Stack(
        children: [
          Align(
              alignment: Alignment(x, y),
              child: Container(
                width: 60,
                height: 50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.circle,
                              size: 30,
                              color: open ? Colors.purple : Colors.black),
                          Text((levelID + 1).toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: passed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/recycle/5.png'),
                                          width: 20,
                                          height: 20)),
                                  Image(
                                      image: AssetImage('assets/recycle/5.png'),
                                      width: 20,
                                      height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Image(
                                        image:
                                            AssetImage('assets/recycle/5.png'),
                                        width: 20,
                                        height: 20),
                                  ),
                                ],
                              )
                            : current
                                ? Icon(Icons.face_sharp)
                                : SizedBox(width: 0))
                  ],
                ),
              )),
          // Align(
          //     alignment: Alignment(x, y),
          //     child: passed
          //         ? Icon(Icons.star, size: 25, color: Colors.yellow)
          //         : SizedBox(width: 0))
        ],
      ),
    );
  }
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
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
    AppData.audioManager.playBgLoop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            reverse: true,
            children: [
              Container(
                height: 700,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/maps/1.png'))),
                child: Stack(
                  children: [
                    LevelMark(0, -0.3, 0.79).getWidget(context),
                    LevelMark(1, 0.3, 0.5).getWidget(context),
                    LevelMark(2, 0.5, 0.25).getWidget(context),
                    LevelMark(3, -0.05, 0.15).getWidget(context),
                    LevelMark(4, 0.2, -0.0).getWidget(context),
                    LevelMark(5, -0.2, -0.17).getWidget(context),
                    LevelMark(6, -0.38, -0.3).getWidget(context),
                    LevelMark(7, -0.5, -0.57).getWidget(context),
                    LevelMark(8, -0.3, -0.9).getWidget(context),
                    LevelMark(9, 0.9, -0.91).getWidget(context),
                    // LevelMark(10, -0.5, -0.5).getWidget(context)
                  ],
                ),
              ),
              Container(
                height: 700,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/maps/1.png'))),
                child: Stack(
                  children: [
                    LevelMark(10, -0.3, 0.79).getWidget(context),
                    LevelMark(11, 0.3, 0.5).getWidget(context),
                    LevelMark(12, 0.5, 0.25).getWidget(context),
                    LevelMark(13, -0.05, 0.15).getWidget(context),
                    LevelMark(14, 0.2, -0.0).getWidget(context),
                    LevelMark(15, -0.2, -0.17).getWidget(context),
                    LevelMark(16, -0.38, -0.3).getWidget(context),
                    LevelMark(17, -0.5, -0.57).getWidget(context),
                    LevelMark(18, -0.3, -0.9).getWidget(context),
                    LevelMark(19, 0.9, -0.91).getWidget(context),
                    // LevelMark(10, -0.5, -0.5).getWidget(context)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

// color: Colors.pink[100],
// child: Column(
//   children: [
//     Flexible(
//       flex: 1,
//       fit: FlexFit.tight,
//       child: Row(children: [
//         Flexible(
//             flex: 2,
//             fit: FlexFit.tight,
//             child: Opacity(
//                 opacity: 0.3,
//                 child:
//                     Image(image: AssetImage('assets/maps/4.png')))),
//         Flexible(flex: 1, fit: FlexFit.tight, child: Center())
//       ]),
//     ),
//     Flexible(
//       flex: 1,
//       fit: FlexFit.tight,
//       child: Row(children: [
//         Flexible(flex: 1, fit: FlexFit.tight, child: Center()),
//         Flexible(
//             flex: 2,
//             fit: FlexFit.tight,
//             child: Opacity(
//                 opacity: 0.3,
//                 child:
//                     Image(image: AssetImage('assets/maps/3.png')))),
//       ]),
//     ),
//     Flexible(
//       flex: 1,
//       fit: FlexFit.tight,
//       child: Row(children: [
//         Flexible(
//             flex: 2,
//             fit: FlexFit.tight,
//             child: Opacity(
//                 opacity: 0.3,
//                 child:
//                     Image(image: AssetImage('assets/maps/2.png')))),
//         Flexible(flex: 1, fit: FlexFit.tight, child: Center())
//       ]),
//     ),
//     Flexible(
//       flex: 1,
//       fit: FlexFit.tight,
//       child: Row(children: [
//         Flexible(flex: 1, fit: FlexFit.tight, child: Center()),
//         Flexible(
//             flex: 2,
//             fit: FlexFit.tight,
//             child: Image(image: AssetImage('assets/maps/1.png'))),
//       ]),
//     ),
//   ],
// ),
// ),
