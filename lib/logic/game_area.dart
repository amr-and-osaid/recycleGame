import 'dart:math';

import 'package:recycle_game/logic/game_level.dart';

class GameArea {
  int areaID;
  List<GameLevel> levels;
  List<Point> levelsPositions;
  String bgPath;

  GameArea(this.areaID, this.levels, this.levelsPositions) {
    bgPath = "assets/areas/$areaID.png";
    if (levelsPositions.length < levels.length)
      throw ("Number of positions in the game area is less than number of game area levels.");
  }

  Point getLevelPosition(int levelID) {
    int levelIndex = levels.indexWhere((l) => l.levelID == levelID);
    if (levelIndex < 0)
      throw ("counldn't get level position of $levelID of game area $areaID");
    return levelsPositions[levelIndex];
  }
}
