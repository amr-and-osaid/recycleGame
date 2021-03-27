import 'package:recycle_game/logic/game_level.dart';

class GameArea {
  int areaID;
  List<GameLevel> levels;
  String bgPath;

  GameArea(this.areaID, this.levels) {
    bgPath = "assets/areas/$areaID.png";
  }
}
