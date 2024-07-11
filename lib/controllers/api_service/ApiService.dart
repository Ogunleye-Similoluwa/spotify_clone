

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:spotify/models/song.dart';

class ApiService{
  var dio = Dio();

  var headers = {
    'X-Rapidapi-Key': 'df4a417812msh60d266e51c6e210p15a31ajsna7546d489d2d',
    'X-Rapidapi-Host': 'spotify-scraper.p.rapidapi.com',
    'Host': 'spotify-scraper.p.rapidapi.com',
  };

  Future<Song> downloadTrack(String query) async {
    try {
      var url = 'https://spotify-scraper.p.rapidapi.com/v1/track/download?track=$query';
      var response = await dio.get(
        url,
        options: Options(headers: headers),
      );
      // print(response.data);
      if (response.statusCode == 200) {
       var result = response.data;

        return Song.fromMap(response.data);
      } else {
        return Song();
      }
    } catch (e) {
      return Song();
    }
  }
}
