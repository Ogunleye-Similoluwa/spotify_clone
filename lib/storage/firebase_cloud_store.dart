import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/users_provider.dart';
import 'package:spotify/models/baseUser.dart';
import '../../models/song.dart';

class DataService {

  UsersProvider provider = UsersProvider();
  String? uid;

  DataService() {
    uid = provider.user.uid;
  }
  CollectionReference songsCollection = FirebaseFirestore.instance.collection('songs');

  Future<void> saveSongsList(String key,List<Song> songs) async {
    final List<String> songListMap =
    songs.map((song) => song.toJson()).toList();
    await songsCollection.doc().set({
      key: jsonEncode(songListMap),
    });
  }

  Future<List<Song>> getSongsList(String key) async {
    var docSnapshot = await songsCollection.doc(uid).get();
    if (docSnapshot.exists) {
      final List<dynamic> songListMap = jsonDecode(docSnapshot[key]);
      return songListMap.map((json) => Song.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveFavoriteSongs(List<Song> songs,) async {
    await saveSongsList('favoriteSongs',songs);
  }

  Future<List<Song>> getFavoriteSongs() async {
    return await getSongsList('favoriteSongs');
  }

  Future<void> saveRecentSongs(List<Song> songs, ) async {
    await saveSongsList('recentSongs', songs);
  }

  Future<List<Song>> getRecentSongs() async {
    return await getSongsList('recentSongs', );
  }

  Future<void> saveCurrentSong(Song song) async {
    try {
      print("About to update song with ID: $uid");
      await songsCollection.doc(uid).update(song.toMap());
      print("Song updated successfully");
    } catch (e) {
      print("Failed to update song: $e");
    }
  }

  Future<Song?> getLastSong() async {
    var docSnapshot = await songsCollection.doc().get();
    if (docSnapshot.exists) {
      final songJson = docSnapshot['lastSong'];
      return Song.fromJson(songJson);
    }
    return null;
  }
}
