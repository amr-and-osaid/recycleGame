import 'dart:math';

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

  GameLevel getGameLevel(int areaID, int levelID) {
    GameArea gameArea =
        gameAreas.firstWhere((ga) => ga.areaID == areaID, orElse: () => null);
    if (gameArea == null) throw ("Couldn't find game area $areaID");

    GameLevel gameLevel = gameArea.levels
        .firstWhere((g) => g.levelID == levelID, orElse: () => null);
    if (gameLevel == null)
      throw ("Couldn't find game level $levelID in game area $areaID");

    return gameLevel;
  }

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
    GameArea(0, [
      GameLevel(0, LevelType.BASIC, 2, 1, 5, 60, null),
      GameLevel(1, LevelType.BASIC, 3, 1, 5, 60, 4000),
      GameLevel(2, LevelType.BELT, 2, 1, 5, 60, 4000),
      GameLevel(3, LevelType.BELT, 2, 2, 5, 60, 4000),
      GameLevel(4, LevelType.BELT, 2, 3, 5, 60, 4000),
      GameLevel(5, LevelType.WATERFALL, 2, 1, 5, 60, 4000),
      GameLevel(6, LevelType.WATERFALL, 2, 2, 5, 60, 4000),
      GameLevel(7, LevelType.WATERFALL, 2, 3, 5, 60, 4000),
      GameLevel(8, LevelType.COLLECTION, 2, 24, 10, 60, 4000),
      GameLevel(9, LevelType.COLLECTION, 2, 30, 15, 60, 4000),
      GameLevel(10, LevelType.COLLECTION, 2, 30, 20, 60, 4000),
    ], [
      Point(0.41, 0.89),
      Point(0.52, 0.75),
      Point(0.62, 0.7),
      Point(0.55, 0.57),
      Point(0.48, 0.52),
      Point(0.65, 0.46),
      Point(0.4, 0.4),
      Point(0.1, 0.4),
      Point(0.4, 0.32),
      Point(0.58, 0.16),
      Point(0.5, 0.01),
    ]),
    GameArea(1, [
      GameLevel(0, LevelType.BASIC, 2, 1, 5, 60, null),
      GameLevel(1, LevelType.BASIC, 3, 1, 5, 60, 4000),
      GameLevel(2, LevelType.BELT, 2, 1, 5, 60, 4000),
      GameLevel(3, LevelType.BELT, 2, 2, 5, 60, 4000),
      GameLevel(4, LevelType.BELT, 2, 3, 5, 60, 4000),
      GameLevel(5, LevelType.WATERFALL, 2, 1, 5, 60, 4000),
      GameLevel(6, LevelType.WATERFALL, 2, 2, 5, 60, 4000),
      GameLevel(7, LevelType.WATERFALL, 2, 3, 5, 60, 4000),
      GameLevel(8, LevelType.COLLECTION, 2, 24, 10, 60, 4000),
      GameLevel(9, LevelType.COLLECTION, 2, 30, 15, 60, 4000),
      GameLevel(10, LevelType.COLLECTION, 2, 30, 20, 60, 4000),
    ], [
      Point(0.41, 0.89),
      Point(0.52, 0.75),
      Point(0.62, 0.7),
      Point(0.55, 0.57),
      Point(0.48, 0.52),
      Point(0.65, 0.46),
      Point(0.4, 0.4),
      Point(0.1, 0.4),
      Point(0.4, 0.32),
      Point(0.58, 0.16),
      Point(0.5, 0.01),
    ]),
  ];
}
