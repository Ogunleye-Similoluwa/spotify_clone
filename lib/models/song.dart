

import 'dart:convert';

class Song{
  final String? name;
  final String? artistName;
  final String? musicName;
  final String? image;
    bool? isLiked = false;
   Duration? position;

Song({this.name, this.artistName, this.musicName, this.position, this.image, this.isLiked});

  factory Song.fromJson(String str) => Song.fromMap2(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Song.fromMap(Map<String, dynamic> data){
   return Song(
     name: data["youtubeVideo"]["audio"][0]["url"],
     musicName: data["spotifyTrack"]["name"],
     image: data["spotifyTrack"]["album"]["cover"][0]["url"],
     artistName:_getArtistName(data),
     // position: Duration(),
     isLiked: false
   ) ;
  }

  factory Song.fromMap2(Map<String, dynamic> data){
    return Song(
      name: data["name"],
      musicName: data["musicName"],
      image: data["image"],
      artistName: data["artistName"],
      isLiked: data["isLiked"],
      // position: data["position"]
    );
  }

  Map<String, dynamic> toMap() => {
    "musicName": musicName,
    "artistName": artistName,
    "image": image,
    "isLiked": isLiked,
    "name": name,
    // "position": position
  };

  static String _getArtistName(Map<String, dynamic> data){
    final artistList =  data["spotifyTrack"]["artists"]  as List;
    String artistNames="";
    for(var i =0; i < artistList.length; i++){
      if(artistList.length > 1){
        artistNames = artistList[i]["name"];
      }
      else{
        artistNames = artistList[i]["name"] + " & " + artistNames;
      }

    }
    return artistNames;
  }


  void setIsLiked (bool isLiked){
    this.isLiked = isLiked;
  }

}