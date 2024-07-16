// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/song.dart';
//
// class SharedPrefs {
//   static SharedPreferences? _preferences;
//
//   static const _keyLastSong = 'lastSong';
//
//   static const String _favoriteSongsKey = 'favoriteSongs';
//   static const String _recentSongsKey = 'recentSongs';
//
//   static Future init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }
//
//   static Future<void> saveSongsList(String key, List<Song> songs) async {
//     final songList = songs.map((song) => song.toJson()).toList();
//     _preferences?.setString(key, jsonEncode(songList));
//   }
//
//   static Future<List<Song>> getSongsList(String key) async {
//     final songListJson = _preferences?.getString(key);
//     if (songListJson != null) {
//       final List<dynamic> songListMap = jsonDecode(songListJson);
//       return songListMap.map((json) => Song.fromJson(json)).toList();
//     }
//     return [];
//   }
//
//   static Future<void> saveFavoriteSongs(List<Song> songs) async {
//     await saveSongsList(_favoriteSongsKey, songs);
//   }
//
//   static Future<List<Song>> getFavoriteSongs() async {
//     return await getSongsList(_favoriteSongsKey);
//   }
//
//   static Future<void> saveRecentSongs(List<Song> songs) async {
//     await saveSongsList(_recentSongsKey, songs);
//   }
//
//   static Future<List<Song>> getRecentSongs() async {
//     return await getSongsList(_recentSongsKey);
//   }
//
//
//
//   static Future saveCurrentSong(Song song) async {
//     await _preferences?.setString(_keyLastSong, song.toJson());
//
//   }
//
//   static Song? getLastSong() {
//     final songJson = _preferences?.getString(_keyLastSong);
//
//     if (songJson != null) {
//       return Song.fromJson(songJson);
//     }
//     return null;
//   }
//
//   // static Duration getLastPosition() {
//   //   final positionMs = _preferences?.getInt(_keyLastPosition);
//   //   if (positionMs != null) {
//   //     return Duration(milliseconds: positionMs);
//   //   }
//   //   return Duration.zero;
//   // }
// }
