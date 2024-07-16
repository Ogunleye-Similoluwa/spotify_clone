import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/song.dart';
import '../../models/baseUser.dart';
import '../../singleton/AudioPlayerSingleton.dart';
import '../../storage/hive.dart';

class SongTileProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayerSingleton().audioPlayer;
  Duration positionDuration = const Duration();
  Song? _currentSong;
  List<Song> favoriteSongs = [];
  List<Song> recentSongs = [];
  late final BaseUser user;

  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;

  SongTileProvider(BuildContext context) {
    loadFavoriteSongs(context);
    loadRecentSongs(context);
  }

  Future<void> setCurrentSong(BuildContext context, Song song) async {
    _currentSong = song;
    notifyListeners();
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.name!)));
    _audioPlayer.seek(song.position);
    _saveCurrentState(context);
    notifyListeners();
  }

  Future<void> playAudio(BuildContext context) async {
    _audioPlayer.play();
    _saveCurrentState(context);
  }

  Future<void> replayAudio(BuildContext context) async {
    _audioPlayer.seek(Duration.zero);
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(_currentSong!.name!)));
    _saveCurrentState(context);
  }

  Future<void> pauseAudio(BuildContext context) async {
    _audioPlayer.pause();
    _saveCurrentState(context);
  }

  Future<void> _saveCurrentState(BuildContext context) async {
    if (_currentSong != null) {
      await HiveDataService.saveCurrentSong(context, _currentSong!);
    }
  }

  Future<void> loadFavoriteSongs(BuildContext context) async {
    favoriteSongs = await HiveDataService.getFavoriteSongs(context);
    notifyListeners();
  }

  Future<void> loadRecentSongs(BuildContext context) async {
    recentSongs = await HiveDataService.getRecentSongs(context);
    notifyListeners();
  }

  void setFavoriteSongs(List<Song> songs) {
    favoriteSongs = songs;
    notifyListeners();
  }

  void setRecentSongs(List<Song> songs) {
    recentSongs = songs;
    notifyListeners();
  }

  void addFavoriteSong(BuildContext context, Song newSong) {
    favoriteSongs.removeWhere((song) => song.musicName == newSong.musicName);
    favoriteSongs.add(newSong);
    favoriteSongs = favoriteSongs.toSet().toList();
    _saveFavoriteSongs(context);
    notifyListeners();
  }

  void addRecentSong(BuildContext context, Song newSong) {
    recentSongs.removeWhere((song) => song.musicName == newSong.musicName);
    recentSongs.add(newSong);
    recentSongs = recentSongs.toSet().toList();
    _saveRecentSongs(context);
    notifyListeners();
  }

  void removeFavoriteSong(BuildContext context, Song song) {
    favoriteSongs.removeWhere((s) => s.musicName == song.musicName);
    _saveFavoriteSongs(context);
    notifyListeners();
  }

  Future<void> _saveFavoriteSongs(BuildContext context) async {
    await HiveDataService.saveFavoriteSongs(context, favoriteSongs);
  }

  Future<void> _saveRecentSongs(BuildContext context) async {
    await HiveDataService.saveRecentSongs(context, recentSongs);
  }

  void disposePlayer() {
    _audioPlayer.dispose();
    _currentSong = null;
    notifyListeners();
  }
}
