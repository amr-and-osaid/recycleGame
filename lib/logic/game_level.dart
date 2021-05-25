import 'dart:async';
import 'dart:math';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/logic/waste_bin.dart';

enum LevelType { BASIC, BELT, WATERFALL, RAIN, COLLECTION }

class GameLevel {
  //Level Params
  int levelID;
  LevelType type;
  int numBins;
  int numWastes;
  int numTargetWastes;
  int levelDuration;
  int movingDuration;
  String bgPath;

  //Level State
  int levelScore;
  bool levelSucceeded;
  bool levelEndReached;
  int remDuration;
  List<WasteBin> bins = [];
  int consecutiveMistakesCounter = 0;
  int consecutiveCorrectsCounter = 0;

  //locals
  Timer _levelTimer;
  bool _lastCorrectState;

  GameLevel(this.levelID, this.type, this.numBins, this.numWastes,
      this.numTargetWastes, this.levelDuration, this.movingDuration) {
    prepareLevel();
    bgPath = 'assets/levels/0.png';
  }

  void prepareLevel() {
    levelScore = 0;
    levelSucceeded = false;
    levelEndReached = false;
    remDuration = levelDuration;
    consecutiveCorrectsCounter = 0;
    consecutiveMistakesCounter = 0;
    _lastCorrectState = null;
    bins.clear();
    for (int i = 0; i < numBins; i++) {
      WasteBin randomBin =
          WasteBin.bins[Random().nextInt(WasteBin.bins.length)];
      while (bins.contains(randomBin))
        randomBin = WasteBin.bins[Random().nextInt(WasteBin.bins.length)];

      bins.add(randomBin);
    }
  }

  void startLevel() {
    _levelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      remDuration--;
      if (remDuration <= 0) {
        levelEndReached = true;
        _levelTimer.cancel();
      }
    });
  }

  void setScore(bool isCorrect) {
    if (isCorrect)
      levelScore++;
    else {
      remDuration -= 5;
      if (remDuration < 0) remDuration = 0;
    }

    if (levelScore >= numTargetWastes) levelSucceeded = true;
    if (levelScore >= numTargetWastes) levelEndReached = true;

    if (_lastCorrectState != null) {
      if (_lastCorrectState && !isCorrect) consecutiveCorrectsCounter = 0;
      if (!_lastCorrectState && isCorrect) consecutiveMistakesCounter = 0;
    }
    _lastCorrectState = isCorrect;

    if (isCorrect)
      consecutiveCorrectsCounter++;
    else
      consecutiveMistakesCounter++;
  }

  Waste nextWaste() {
    if (numWastes <= 0 || numBins <= 0 || bins.length <= 0) return null;

    WasteBin randomBin = bins[Random().nextInt(bins.length)];
    List<Waste> randomWastes = Waste.wastes
        .where((e) => e.wasteBin.wasteBinID == randomBin.wasteBinID)
        .toList();

    if (randomWastes.length <= 0) return null;
    return randomWastes[Random().nextInt(randomWastes.length)];
  }
}
