import 'package:cleanWise/logic/audio_manager.dart';
import 'package:cleanWise/screens/widgets/container_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GameManager {
  int _currentTrashID = 1;
  int _currentProgress = 0;
  int _currentMistakes = 0;
  AudioManager _audioManager = AudioManager();
  Map<int, int> _trashToContainter;

  // Game State
  int get currentTrashID => _currentTrashID;
  int get currentProgress => _currentProgress;
  int get currentMistakes => _currentMistakes;

  // Game Controls
  void nextTrash() => _currentTrashID = Random().nextInt(18) + 1;
  void incrementProgress() => _currentProgress += 2;
  void incrementMistakes() => _currentMistakes++;
  bool isCorrectContainer(int trashID, int containerID) =>
      _trashToContainter[trashID] == containerID ? true : false;

  List<Widget> getContainerList(Function resultCheckFunc) {
    List<Widget> widgets = [];
    int correctContainer = _trashToContainter[_currentTrashID];

    int rand = Random().nextInt(6) + 1;
    if (rand == correctContainer) rand = rand == 6 ? 1 : rand + 1;

    widgets = [
      ContainerWidget(correctContainer, resultCheckFunc),
      ContainerWidget(rand, resultCheckFunc),
    ];
    widgets.shuffle();

    return widgets;
  }

  void resetGame() {
    _currentTrashID = 1;
    _currentProgress = 0;
    _currentMistakes = 0;
  }

  bool get maxMistakesReached => _currentMistakes == 10;
  bool get levelEndReached => _currentProgress >= 33;

  // Game Audios
  void playBgLoop() => _audioManager.playBgLoop();
  void pauseBg() => _audioManager.pauseBg();
  void playDrag() => _audioManager.playDrag();
  void playWrong() => _audioManager.playWrong();
  void playWin() => _audioManager.playWin();
  void playLose() => _audioManager.playLose();
  void playTrash(int id) => _audioManager.playTrash(id);

  // Game Init
  Future<void> init() async {
    _audioManager.init();
    //1 elec
    //2 glass
    //3 metal
    //4 organic
    //5 paper
    //6 plastic
    _trashToContainter = Map<int, int>();
    _trashToContainter.putIfAbsent(1, () => 2);
    _trashToContainter.putIfAbsent(2, () => 4);
    _trashToContainter.putIfAbsent(3, () => 5);
    _trashToContainter.putIfAbsent(4, () => 5);
    _trashToContainter.putIfAbsent(5, () => 4);
    _trashToContainter.putIfAbsent(6, () => 4);
    _trashToContainter.putIfAbsent(7, () => 6);
    _trashToContainter.putIfAbsent(8, () => 5);
    _trashToContainter.putIfAbsent(9, () => 6);
    _trashToContainter.putIfAbsent(10, () => 6);
    _trashToContainter.putIfAbsent(11, () => 2);
    _trashToContainter.putIfAbsent(12, () => 2);
    _trashToContainter.putIfAbsent(13, () => 3);
    _trashToContainter.putIfAbsent(14, () => 1);
    _trashToContainter.putIfAbsent(15, () => 3);
    _trashToContainter.putIfAbsent(16, () => 3);
    _trashToContainter.putIfAbsent(17, () => 1);
    _trashToContainter.putIfAbsent(18, () => 1);
  }
}
