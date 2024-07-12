import 'package:flutter/cupertino.dart';
import '../../models/song.dart';
import '../../storage/shared_prefrences.dart';

class SongsProvider extends ChangeNotifier {
  List<Song> favoriteSongs = [];
  List<Song> recentSongs = [];

  SongsProvider() {
    loadFavoriteSongs();
    loadRecentSongs();
  }

  void setRecentSongs(List<Song> song){
    recentSongs = song;
    notifyListeners();
  }

  void setFavoriteSongs(List<Song> song){
    favoriteSongs = song;
    notifyListeners();
  }

  void addRecentSong(Song newSong) {
    if(recentSongs.isNotEmpty){
      for (var song in recentSongs) {
        if( song.musicName != newSong.musicName ){
          recentSongs.add(newSong);
        }
        else if(song.musicName == newSong.musicName){
          recentSongs.remove(song);
          recentSongs.add(newSong);
        }
      }
    }
    else if(recentSongs.isEmpty){
      recentSongs.add(newSong);
    }
    recentSongs = recentSongs.toSet().toList();
    _saveRecentSongs();
    notifyListeners();
  }

  void addFavoriteSong(Song newSong) {
    if(favoriteSongs.isNotEmpty) {
      for (var song in favoriteSongs) {
        if (song.musicName != newSong.musicName) {
          favoriteSongs.add(newSong);
        }
        else if (song.musicName == newSong.musicName){
          favoriteSongs.remove(song);
          favoriteSongs.add(newSong);
        }
      }
    }
    else if(favoriteSongs.isEmpty){
      favoriteSongs.add(newSong);
    }
    favoriteSongs = favoriteSongs.toSet().toList();
    _saveFavoriteSongs();
    notifyListeners();
  }

  void removeFavoriteSong(Song song) {
    favoriteSongs.removeWhere((s) => s.musicName == song.musicName);
    _saveFavoriteSongs();
    notifyListeners();
  }

  Future<void> loadFavoriteSongs() async {
    favoriteSongs = await SharedPrefs.getFavoriteSongs();
    notifyListeners();
  }

  Future<void> loadRecentSongs() async {
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
