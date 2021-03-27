import 'dart:async';
import 'dart:math';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/logic/waste_bin.dart';

enum LevelType { BASIC, BELT, WATERFALL, RAIN, COLLECTION }

class GameLevel {
  //Level Params
  LevelType type;
  int numBins;
  int numWastes;
  int numTargetWastes;
  int levelDuration;
  int movingDuration;
  double xLocInMap;
  double yLocInMap;
  String bgPath;

  //Level State
  int levelScore;
  bool levelSucceeded;
  int remDuration;
  List<WasteBin> bins = [];
  int consecutiveMistakesCounter = 0;
  int consecutiveCorrectsCounter = 0;

  //locals
  Timer _levelTimer;
  bool _lastCorrectState;

  GameLevel(this.type, this.numBins, this.numWastes, this.numTargetWastes,
      this.levelDuration, this.movingDuration, this.xLocInMap, this.yLocInMap) {
    prepareLevel();
    bgPath = 'assets/areas/11.png';
  }

  void prepareLevel() {
    levelScore = 0;
    levelSucceeded = false;
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
        levelSucceeded = levelScore >= numTargetWastes;
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

  // Game State

  // String get scoreImage {
  //   return "assets/progress/LS" +
  //       ((_scoreCounter.toDouble() /
  //                   (type == LevelType.BASIC || type == LevelType.MOVING
  //                       ? (numRounds - maxMistakesAllowed)
  //                       : numTargetWastes)) *
  //               33)
  //           .floor()
  //           .clamp(0, 33)
  //           .toString() +
  //       ".png";
  // }

  // double get maxMiskatesAllowedAlignValue {
  //   return ((1 - (maxMistakesAllowed / numRounds)) * 2) - 1;
  // }

  // String timerImage(int curSec) {
  //   return "assets/timer/" +
  //       (((curSec.toDouble() / levelDuration) * 23).floor()).toString() +
  //       ".png";
  // }

  // String get mistakesImage {
  //   return "assets/progress/LS" +
  //       (((_mistakesCounter).toDouble() / maxMistakesAllowed) * 33)
  //           .floor()
  //           .toString() +
  //       ".png";
  // }

  // bool get winLevelReached {
  //   return levelScore >=
  //       (type == LevelType.BASIC || type == LevelType.MOVING
  //           ? (numRounds - maxMistakesAllowed)
  //           : numTargetWastes);
  // }

  // bool get isWin {
  //   return (type == LevelType.BASIC || type == LevelType.MOVING
  //           ? (_mistakesCounter >= maxMistakesAllowed)
  //           : levelScore < numTargetWastes)
  //       ? false
  //       : true;
  // }

  // bool get isEndOfGame => (type == LevelType.BASIC || type == LevelType.MOVING
  //         ? (_mistakesCounter >= maxMistakesAllowed ||
  //             levelScore >= (numRounds - maxMistakesAllowed))
  //         : levelScore >= numTargetWastes)
  //     ? true
  //     : false;
}
