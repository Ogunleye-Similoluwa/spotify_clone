import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Images from Unsplash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomImagesPage(),
    );
  }
}

class RandomImagesPage extends StatefulWidget {
  @override
  _RandomImagesPageState createState() => _RandomImagesPageState();
}

class _RandomImagesPageState extends State<RandomImagesPage> {
  List<dynamic> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchRandomImages();
  }

  Future<void> fetchRandomImages() async {
    String accessKey = '4he1nuoxhw8dZFrYWYaqVXlLWT5BSkLvzw36Ma7mkCw';
    int count = 7;
    String query = 'music';
    String apiUrl = 'https://api.unsplash.com/photos/random?client_id=$accessKey&query=$query&count=$count';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<dynamic> urls = data.map((item) => item['urls']['regular']).toList();
        setState(() {
          imageUrls = urls;
        });
      } else {
        print('Failed to fetch images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Images from Unsplash'),
      ),
      body: Center(
        child: imageUrls.isEmpty
            ? CircularProgressIndicator()
            : GridView.count(
          crossAxisCount: 2,
          children: imageUrls.map((url) {
            return Image.network(url, fit: BoxFit.cover);
          }).toList(),
        ),
      ),
    );
  }
}
