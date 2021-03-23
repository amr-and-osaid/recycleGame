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

  void nextLevel(int curLevelID) {
    if (curLevelID == _currentLevelID) {
      _currentLevelID++;
      if (_currentLevelID >= _levels.length) _currentLevelID = 0;
      currentLevel = _levels[_currentLevelID];
      _pref.setInt('currentLevelID', _currentLevelID);
    }
  }

  void newGame() {
    _currentLevelID = 0;
    currentLevel = _levels[_currentLevelID];
  }

  void resetCurrentLevel() => currentLevel.resetGame();

  bool get isLastLevel => _currentLevelID == _levels.length - 1;

  int get currentLevelID => _currentLevelID;

  GameLevel getLevel(int levelID) => _levels[levelID];

  List<GameLevel> _levels = [
    GameLevel.moving(2, 8, 2, 6000),
    GameLevel.moving(2, 8, 4, 5000),
    GameLevel.moving(2, 8, 5, 4000),
    //
    GameLevel.basic(2, 8, 2),
    GameLevel.basic(2, 8, 4),
    //
    GameLevel.moving(2, 8, 5, 4000),
    GameLevel.moving(2, 8, 6, 3000),
    //
    GameLevel.timed(2, 4, 30),
    GameLevel.timed(2, 6, 30),
    //
    GameLevel.moving(2, 8, 6, 3000),
    //
    GameLevel.timed(2, 8, 30),
    GameLevel.timed(2, 10, 30),
    //
    GameLevel.basic(2, 8, 6),
    GameLevel.basic(3, 8, 6),
    GameLevel.basic(4, 8, 6),
    //
    GameLevel.timed(2, 12, 30),
    GameLevel.moving(3, 8, 6, 2000),
    GameLevel.moving(4, 8, 6, 1000),
  ];
}
