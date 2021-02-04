import 'package:cleanWise/logic/audio_manager.dart';
import 'package:cleanWise/logic/game_manager.dart';
import 'package:cleanWise/logic/trash_container_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  // global vars
  static String appVersion;
  static AudioManager audioManager = AudioManager();
  static GameManager gameManager = GameManager();

  static bool _soundOn;
  static bool _musicOn;

  static get soundOn => _soundOn;
  static set soundOn(bool on) {
    _soundOn = on;
    _pref.setBool('soundOn', on);
  }

  static get musicOn => _musicOn;
  static set musicOn(bool on) {
    _musicOn = on;
    _pref.setBool('musicOn', on);
  }

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    _soundOn = _pref.getBool('soundOn') ?? true;
    _musicOn = _pref.getBool('musicOn') ?? true;
    await audioManager.init();
    TrashContainerMap.init();
    gameManager.init();
  }

  //private
  static SharedPreferences _pref;
}
