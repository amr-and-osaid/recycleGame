import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/logic/game_area.dart';

class GameManager {
  int _currentAreaID = 0;
  int _currentLevelID = 0;

  Future<void> init() async {
    _currentAreaID = AppData.sharedPref.getInt('currentAreaID') ?? 0;
    _currentLevelID = AppData.sharedPref.getInt('currentLevelID') ?? 0;

    if (_currentAreaID >= gameAreas.length)
      _currentAreaID = gameAreas.length - 1;
    if (_currentLevelID >= gameAreas[_currentAreaID].levels.length)
      _currentLevelID = gameAreas[_currentAreaID].levels.length - 1;
  }

  void nextLevel(int curAreaID, int curLevelID) {
    if (curAreaID == _currentAreaID && curLevelID == _currentLevelID) {
      _currentLevelID++;
      if (_currentLevelID >= gameAreas[_currentAreaID].levels.length) {
        _currentAreaID++;
        _currentLevelID = 0;
      }
    }
  }

  void newGame() {
    _currentLevelID = 0;
    _currentAreaID = 0;
  }

  GameLevel getGameLevel(int areaID, int levelID) =>
      gameAreas[areaID].levels[levelID];

  bool get isLastLevelReached =>
      _currentAreaID == gameAreas.length - 1 &&
      _currentLevelID == gameAreas[_currentAreaID].levels.length - 1;

  int get currentAreaID => _currentAreaID;
  set currentAreaID(int curAreaID) {
    _currentAreaID = curAreaID;
    AppData.sharedPref.setInt('currentAreaID', _currentAreaID);
  }

  int get currentLevelID => _currentLevelID;
  set currentLevelID(int curLevelID) {
    _currentLevelID = curLevelID;
    AppData.sharedPref.setInt('currentLevelID', _currentLevelID);
  }

  List<GameArea> gameAreas = [
    GameArea(1, [
      GameLevel(LevelType.BASIC, 2, 1, 5, 60, null, -0.3, 0.79),
      GameLevel(LevelType.BELT, 2, 1, 5, 60, 4000, 0.3, 0.5),
      GameLevel(LevelType.BELT, 2, 2, 5, 60, 4000, 0.5, 0.25),
      GameLevel(LevelType.BELT, 2, 3, 5, 60, 4000, -0.05, 0.15),
      GameLevel(LevelType.BELT, 2, 4, 5, 60, 4000, 0.2, -0.0),
      GameLevel(LevelType.BELT, 2, 5, 5, 60, 4000, -0.2, -0.17),
      GameLevel(LevelType.WATERFALL, 2, 1, 5, 60, 4000, -0.38, -0.3),
      GameLevel(LevelType.WATERFALL, 2, 2, 5, 60, 4000, -0.5, -0.57),
      GameLevel(LevelType.WATERFALL, 2, 3, 5, 60, 4000, -0.3, -0.9),
      GameLevel(LevelType.WATERFALL, 2, 4, 5, 60, 4000, 0.1, -0.93),
      GameLevel(LevelType.WATERFALL, 2, 5, 5, 60, 4000, 0.9, -0.91)
    ]),
    GameArea(2, [
      GameLevel(LevelType.BASIC, 2, 1, 5, 60, null, -0.3, 0.79),
      GameLevel(LevelType.BELT, 2, 1, 5, 60, 4000, 0.3, 0.5),
      GameLevel(LevelType.BELT, 2, 2, 5, 60, 4000, 0.5, 0.25),
      GameLevel(LevelType.BELT, 2, 3, 5, 60, 4000, -0.05, 0.15),
      GameLevel(LevelType.BELT, 2, 4, 5, 60, 4000, 0.2, -0.0),
      GameLevel(LevelType.BELT, 2, 5, 5, 60, 4000, -0.2, -0.17),
      GameLevel(LevelType.WATERFALL, 2, 1, 5, 60, 4000, -0.38, -0.3),
      GameLevel(LevelType.WATERFALL, 2, 2, 5, 60, 4000, -0.5, -0.57),
      GameLevel(LevelType.WATERFALL, 2, 3, 5, 60, 4000, -0.3, -0.9),
      GameLevel(LevelType.WATERFALL, 2, 4, 5, 60, 4000, 0.1, -0.93),
      GameLevel(LevelType.WATERFALL, 2, 5, 5, 60, 4000, 0.9, -0.91)
    ]),
  ];
}
