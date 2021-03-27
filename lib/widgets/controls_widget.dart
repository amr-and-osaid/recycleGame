import 'package:recycle_game/app_data.dart';
import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final Function updateParent;
  final Function exit;

  ControlsWidget(this.updateParent, this.exit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 70,
            child: Row(
              children: [
                Flexible(flex: 2, fit: FlexFit.tight, child: Center()),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(flex: 1, fit: FlexFit.tight, child: Center()),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: () {
                                AppData.musicOn = !AppData.musicOn;
                                if (AppData.musicOn)
                                  AppData.audioManager.playBgLoop();
                                else
                                  AppData.audioManager.pauseBg();
                                updateParent();
                              },
                              child: Image(
                                gaplessPlayback: true,
                                image: AssetImage('assets/controls/music' +
                                    (AppData.musicOn ? '' : '_mute') +
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
                                updateParent();
                              },
                              child: Image(
                                gaplessPlayback: true,
                                image: AssetImage('assets/controls/sound' +
                                    (AppData.soundOn ? '' : '_mute') +
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
                                exit();
                              },
                              child: Image(
                                gaplessPlayback: true,
                                image: AssetImage('assets/controls/close.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
        Expanded(child: Center())
      ],
    );
  }
}
