import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/song.dart';
import '../../singleton/AudioPlayerSingleton.dart';
import '../../storage/shared_prefrences.dart';

class SongTileProvider extends ChangeNotifier {

  final AudioPlayer _audioPlayer = AudioPlayerSingleton().audioPlayer;
  var positionDuration =const Duration();
  Song? _currentSong;
  // Duration _currentPosition = Duration.zero;

  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;

  SongTileProvider() {

    _loadLastPlayedSong();

  }



  void setCurrentSongPosition(Song song){
   this._currentSong?.position = song.position;
   print(currentSong?.position);

  }
  Future<void> setCurrentSong(Song song) async {
    _currentSong = song;
    notifyListeners();
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.name!)));
    _audioPlayer.seek(song.position);
    notifyListeners();
  }

  Future<void> playAudio() async {
    print("${currentSong?.position }  here");
    _audioPlayer.play();
    _saveCurrentState();
  }

  Future<void> pauseAudio() async {
    _audioPlayer.pause();
    _saveCurrentState();
  }



  Future<void> _saveCurrentState() async {
    if (_currentSong != null) {
      print("${_currentSong?.position} _currentSong is Saved");
      SharedPrefs.saveCurrentSong(_currentSong!);
    }
  }

  Future<void> _loadLastPlayedSong() async {
    _currentSong = SharedPrefs.getLastSong();

      print(_currentSong?.position);
    if (_currentSong != null) {
      print(_currentSong!.toJson());
      await setCurrentSong(_currentSong!);
      notifyListeners();
    }
  }



  void disposePlayer() {
    _audioPlayer.dispose();
    _currentSong = null;
    notifyListeners();
  }
}
