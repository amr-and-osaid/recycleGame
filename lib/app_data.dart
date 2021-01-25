import 'package:cleanWise/logic/game_manager.dart';

class AppData {
  static String appVersion;
  static GameManager gameManager = GameManager();
  static bool soundOn = true;
  static bool musicOn = true;

  static Future<void> init() async {
    await gameManager.init();
  }
}
