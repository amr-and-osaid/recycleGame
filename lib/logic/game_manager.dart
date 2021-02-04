import 'package:cleanWise/logic/game_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameManager {
  int _currentLevelID = 0;
  GameLevel currentLevel;
  static SharedPreferences _pref;

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    _currentLevelID = _pref.getInt('currentLevelID') ?? 0;
    currentLevel = _levels[_currentLevelID];
  }

  void nextLevel() {
    _currentLevelID++;
    if (_currentLevelID >= _levels.length) _currentLevelID = 0;
    currentLevel = _levels[_currentLevelID];
    _pref.setInt('currentLevelID', _currentLevelID);
  }

  void resetCurrentLevel() => currentLevel.resetGame();

  bool get isLastLevel => _currentLevelID == _levels.length - 1;

  List<GameLevel> _levels = [
    GameLevel.basic(2, 8, 1, 6),
    GameLevel.basic(2, 8, 1, 4),
    GameLevel.basic(2, 8, 1, 2),
    GameLevel.basic(3, 8, 1, 2),
    GameLevel.basic(4, 8, 1, 2),
    GameLevel.timed(2, 1, 4, 30),
    GameLevel.timed(2, 1, 6, 25),
    GameLevel.timed(2, 1, 8, 20),
    GameLevel.timed(2, 1, 10, 15),
    GameLevel.timed(2, 1, 10, 10),
    GameLevel.moving(2, 8, 1, 6, 15),
    GameLevel.moving(2, 8, 1, 4, 10),
    GameLevel.moving(2, 8, 1, 3, 5),
    GameLevel.moving(2, 8, 1, 2, 2),
    GameLevel.moving(2, 8, 1, 2, 1),
  ];
}
