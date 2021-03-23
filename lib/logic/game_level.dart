import 'dart:math';
import 'package:cleanWise/logic/trash_container_map.dart';
import 'package:cleanWise/model/waste.dart';
import 'package:cleanWise/model/waste_bin.dart';

enum LevelType { BASIC, TIMED, MOVING }

class GameLevel {
  //Game Parameters
  LevelType type = LevelType.BASIC;
  int nContainers = 2;
  int nTrashAtOnce = 1;
  int nTotalTrash = 1;
  int maxMistakesAllowed = 1;
  int targetScore = 0;
  int durationinSec = 0;
  int movingDuration;
  int conseqtiveMistakes = 0;
  int conseqtiveCorrects = 0;
  bool lastWasCorrect;

  GameLevel.basic(this.nContainers, this.nTotalTrash, this.targetScore) {
    type = LevelType.BASIC;
    maxMistakesAllowed = nTotalTrash - targetScore;
    _refreshTrashList();
  }

  GameLevel.moving(this.nContainers, this.nTotalTrash, this.targetScore,
      this.movingDuration) {
    type = LevelType.MOVING;
    maxMistakesAllowed = nTotalTrash - targetScore;
    _refreshTrashList();
  }

  GameLevel.timed(this.nContainers, this.targetScore, this.durationinSec) {
    type = LevelType.TIMED;
    _refreshTrashList();
  }

  //local members
  List<Waste> _wastes = [];
  List<WasteBin> _wasteBins = [];
  int _scoreCounter = 0;
  int _mistakesCounter = 0;

  // Game State

  String get scoreImage {
    return "assets/progress/LS" +
        ((_scoreCounter.toDouble() /
                    (type == LevelType.BASIC || type == LevelType.MOVING
                        ? (nTotalTrash - maxMistakesAllowed)
                        : targetScore)) *
                33)
            .floor()
            .clamp(0, 33)
            .toString() +
        ".png";
  }

  double get maxMiskatesAllowedAlignValue {
    return ((1 - (maxMistakesAllowed / nTotalTrash)) * 2) - 1;
  }

  String timerImage(int curSec) {
    return "assets/timer/" +
        (((curSec.toDouble() / durationinSec) * 23).floor()).toString() +
        ".png";
  }

  String get mistakesImage {
    return "assets/progress/LS" +
        (((_mistakesCounter).toDouble() / maxMistakesAllowed) * 33)
            .floor()
            .toString() +
        ".png";
  }

  List<Waste> get wastes => _wastes;
  List<WasteBin> get wasteBins => _wasteBins;
  int get mistakesCounter => _mistakesCounter;
  int get scoreCounter => _scoreCounter;
  bool get winLevelReached {
    return _scoreCounter >=
        (type == LevelType.BASIC || type == LevelType.MOVING
            ? (nTotalTrash - maxMistakesAllowed)
            : targetScore);
  }

  bool get isWin {
    return (type == LevelType.BASIC || type == LevelType.MOVING
            ? (_mistakesCounter >= maxMistakesAllowed)
            : _scoreCounter < targetScore)
        ? false
        : true;
  }

  bool get isEndOfGame => (type == LevelType.BASIC || type == LevelType.MOVING
          ? (_mistakesCounter >= maxMistakesAllowed ||
              _scoreCounter >= (nTotalTrash - maxMistakesAllowed))
          : _scoreCounter >= targetScore)
      ? true
      : false;

  // Game Controls
  void setProgressAndGoNext(bool correct) {
    // Update progress
    if (correct) {
      _scoreCounter++;
      if ((type == LevelType.BASIC || type == LevelType.MOVING) &&
          _scoreCounter + _mistakesCounter > nTotalTrash)
        _scoreCounter = nTotalTrash - _mistakesCounter;
    } else {
      _mistakesCounter++;
      if ((type == LevelType.BASIC || type == LevelType.MOVING) &&
          _scoreCounter + _mistakesCounter > nTotalTrash)
        _mistakesCounter = nTotalTrash - _scoreCounter;
    }

    if (lastWasCorrect != null) {
      if (lastWasCorrect && !correct) conseqtiveCorrects = 0;
      if (!lastWasCorrect && correct) conseqtiveMistakes = 0;
    }
    lastWasCorrect = correct;

    if (correct)
      conseqtiveCorrects++;
    else
      conseqtiveMistakes++;

    _refreshTrashList();
  }

  void resetGame() {
    _scoreCounter = 0;
    _mistakesCounter = 0;
    conseqtiveCorrects = 0;
    conseqtiveMistakes = 0;
    lastWasCorrect = null;
    _refreshTrashList();
  }

  void _refreshTrashList() {
    _wastes.clear();
    _wasteBins.clear();

    if (isEndOfGame) return;

    Map<int, int> containers = Map<int, int>();
    Map<int, int> trashs = Map<int, int>();

    for (int i = 0; i < nTrashAtOnce; i++) {
      int rand = Random().nextInt(TrashContainerMap.map.keys.length) + 1;
      while (trashs.keys.contains(rand))
        rand = Random().nextInt(TrashContainerMap.map.keys.length) + 1;
      trashs.putIfAbsent(rand, () => null);
      containers.putIfAbsent(TrashContainerMap.map[rand], () => null);
    }

    _wastes = trashs.keys
        .map((e) => Waste.wastes.firstWhere((element) => element.wasteID == e))
        .toList();

    int remaining = nContainers - containers.keys.length;
    for (int i = 0; i < remaining; i++) {
      int rand = Random().nextInt(6) + 1;
      while (containers.keys.contains(rand)) rand = Random().nextInt(6) + 1;
      containers.putIfAbsent(rand, () => null);
    }

    _wasteBins = containers.keys
        .map((e) =>
            WasteBin.wasteBins.firstWhere((element) => element.wasteBinID == e))
        .toList();
    _wasteBins.shuffle();
  }
}
