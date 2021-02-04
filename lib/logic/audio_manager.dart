import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cleanWise/app_data.dart';

class AudioManager {
  static AudioCache _audioCache;
  static AudioPlayer _audioPlayer;
  static AudioCache _bgAudioCache;
  static AudioPlayer _bgAudioPlayer;

  Future<void> init() async {
    _audioPlayer = AudioPlayer();
    _bgAudioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
    _bgAudioCache = AudioCache(fixedPlayer: _bgAudioPlayer);
    await _audioCache.loadAll([
      'audio/drag.mp3',
      'audio/win.mp3',
      'audio/lose.mp3',
      'audio/wrong.mp3',
      'audio/trash_1.mp3',
      'audio/trash_2.mp3',
      'audio/trash_3.mp3',
      'audio/trash_4.mp3',
      'audio/trash_5.mp3',
      'audio/trash_6.mp3'
    ]);
    _bgAudioCache.load('audio/bg.mp3');
  }

  void playBgLoop() {
    if (AppData.musicOn) _bgAudioCache.loop('audio/bg.mp3');
  }

  void pauseBg() {
    if (_bgAudioPlayer != null) if (_bgAudioPlayer.state ==
        AudioPlayerState.PLAYING) _bgAudioPlayer.pause();
  }

  void pause() {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) _audioPlayer.stop();
  }

  void pauseAll() {
    pauseBg();
    pause();
  }

  void playDrag() => _play('audio/drag.mp3');
  void playWrong() => _play('audio/wrong.mp3');
  void playWin() => _play('audio/win.mp3');
  void playLose() => _play('audio/lose.mp3');
  void playStar() => _play('audio/star.mp3');
  void playTrash(int id) => _play('audio/trash_$id.mp3');

  void _play(String file) {
    pause();
    if (AppData.soundOn) _audioCache.play(file);
  }
}
