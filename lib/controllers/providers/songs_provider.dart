import 'package:flutter/cupertino.dart';
import '../../models/song.dart';
import '../../storage/shared_prefrences.dart';

class SongsProvider extends ChangeNotifier {
  List<Song> favoriteSongs = [];
  List<Song> recentSongs = [];

  SongsProvider() {
    _loadFavoriteSongs();
    _loadRecentSongs();
  }

  void addRecentSong(Song song) {
    recentSongs.add(song);
    _saveRecentSongs();
    notifyListeners();
  }

  void addFavoriteSong(Song song) {
    favoriteSongs.add(song);
    _saveFavoriteSongs();
    notifyListeners();
  }

  void removeFavoriteSong(Song song) {
    favoriteSongs.removeWhere((s) => s.musicName == song.musicName);
    _saveFavoriteSongs();
    notifyListeners();
  }

  Future<void> _loadFavoriteSongs() async {
    favoriteSongs = await SharedPrefs.getFavoriteSongs();
    notifyListeners();
  }

  Future<void> _loadRecentSongs() async {
    recentSongs = await SharedPrefs.getRecentSongs();
    notifyListeners();
  }

  Future<void> _saveFavoriteSongs() async {
    await SharedPrefs.saveFavoriteSongs(favoriteSongs);
  }

  Future<void> _saveRecentSongs() async {
    await SharedPrefs.saveRecentSongs(recentSongs);
  }
}
