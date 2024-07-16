import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import 'package:flutter/material.dart';
import '../models/baseUser.dart';

class HiveDataService {
  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  static Future<void> saveSongsList(BuildContext context, String key, List<Song> songs) async {
    final user = Provider.of<BaseUser?>(context, listen: false);
    if (user!.isAnonymous!) {
      return;
    }
    else{
      final box = await openBox('songsBox_${user.uid}');
      final songListMap = songs.map((song) => song.toJson()).toList();
      await box.put(key, songListMap);
      // getSongsList(context, key);
    }


  }

  static Future getSongsList(BuildContext context, String key) async {
    final user = Provider.of<BaseUser?>(context, listen: false);
    print("Gotten user ${user!.isAnonymous!}");
    if (user.isAnonymous!){
      return [];
    }
    else{
      final box = await openBox('songsBox_${user.uid}');
      final songListJson = box.get(key);
      if (songListJson != null && !user.isAnonymous! ) {
        List<dynamic> songListMap = List<dynamic>.from(songListJson);

        songListMap = songListMap.map((json) => Song.fromJson(json)).toList();
        print(songListMap);
        return songListMap ;
      }
    }
    return [];
  }

  static Future<void> saveFavoriteSongs(BuildContext context, List<Song> songs) async {
    await saveSongsList(context, 'favoriteSongs', songs);
  }

  static Future<List<Song>> getFavoriteSongs(BuildContext context) async {
     List<Song> songsList = await getSongsList(context, 'favoriteSongs');
    return songsList;
  }

  static Future<void> saveRecentSongs(BuildContext context, List<Song> songs) async {
    await saveSongsList(context, 'recentSongs', songs);
  }

  static Future<List<Song>> getRecentSongs(BuildContext context) async {
    return await getSongsList(context, 'recentSongs');
  }

  static Future<void> saveCurrentSong(BuildContext context, Song song) async {
    final user = Provider.of<BaseUser?>(context, listen: false);
    if (user!.isAnonymous!){
      return;
    }
  else{
      final box = await openBox('currentSongBox_${user.uid}');
      await box.put('lastSong', song.toJson());
    }

  }

  static Future<Song?> getLastSong(BuildContext context) async {
    final user = Provider.of<BaseUser?>(context, listen: false);
    if (user!.isAnonymous!) {
      return null;
    }
    else{
      final box = await openBox('currentSongBox_${user.uid}');
      final songJson = box.get('lastSong');
      if (songJson != null) {
        return Song.fromJson(songJson);
      }
      return null;
    }


  }


}
