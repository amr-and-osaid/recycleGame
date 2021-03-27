import 'dart:ui';

import 'package:recycle_game/logic/audio_manager.dart';
import 'package:recycle_game/logic/game_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  // global vars
  static String appVersion;
  static SharedPreferences sharedPref;
  static AudioManager audioManager = AudioManager();
  static GameManager gameManager = GameManager();

  static bool _soundOn;
  static bool _musicOn;

  static get soundOn => _soundOn;
  static set soundOn(bool on) {
    _soundOn = on;
    sharedPref.setBool('soundOn', on);
  }

  static get musicOn => _musicOn;
  static set musicOn(bool on) {
    _musicOn = on;
    sharedPref.setBool('musicOn', on);
  }

  static Future<void> init() async {
    sharedPref = await SharedPreferences.getInstance();
    _soundOn = sharedPref.getBool('soundOn') ?? true;
    _musicOn = sharedPref.getBool('musicOn') ?? true;
    await audioManager.init();
    gameManager.init();
  }

  static void cycleState(AppLifecycleState state) {
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
}
