

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:spotify/models/song.dart';

class ApiService{
  var dio = Dio();

  var headers = {
    'X-Rapidapi-Key': 'ca58e585b0msh7ef08cb3c5200b7p123b2ajsn82fc3d91cea4',
    'X-Rapidapi-Host': 'spotify-scraper.p.rapidapi.com',
    'Host': 'spotify-scraper.p.rapidapi.com',
  };
  String accessKey = '4he1nuoxhw8dZFrYWYaqVXlLWT5BSkLvzw36Ma7mkCw';

  Future<Song> downloadTrack(String query) async {
    try {
      var url = 'https://spotify-scraper.p.rapidapi.com/v1/track/download?track=$query';
      var response = await dio.get(
        url,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return Song.fromMap(response.data);
      } else {
        return Song();
      }
    } catch (e) {
      return Song();
    }
  }

  Future<List<dynamic>> fetchRandomImages() async {
    int count = 7;
    String query = 'music';
    String apiUrl = 'https://api.unsplash.com/photos/random?client_id=$accessKey&query=$query&count=$count';

    try {
      var response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<dynamic> urls = data.map((item) => item['urls']['regular']).toList();
        return urls;
      } else {
       return [];
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
    return [];
  }


}
