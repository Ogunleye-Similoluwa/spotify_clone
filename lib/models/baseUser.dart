

import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/models/song.dart';

class BaseUser{

  String? name;

  String? email;

  String? uid;

  bool? isAnonymous;

  Song? lastPlayedSong;

  Song? saveCurrentSong;

  List<Song>? recentSongList;

  List<Song>? favoriteSongList;


  BaseUser({ this.name, this.email, this.uid, this.isAnonymous});
  factory BaseUser.fromUser(UserCredential userCredential){
    return  BaseUser(
      name: userCredential.user?.displayName,
      email: userCredential.user?.email,
      uid:  userCredential.user?.uid,
      isAnonymous: userCredential.user?.isAnonymous
    );
  }

}