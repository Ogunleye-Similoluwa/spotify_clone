import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/router/routeGenerator.dart';
import 'package:spotify/storage/shared_prefrences.dart';

import 'controllers/providers/images_provider.dart';
import 'controllers/providers/song_tile_provider.dart';
import 'controllers/providers/songs_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongTileProvider()),
        ChangeNotifierProvider(create: (_) => SongsProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify',
      theme: ThemeData(
        primaryColor: Color(0xFF1DB954),
        hintColor: Color(0xFF1DB954),
        fontFamily: 'Gotham',
      ),
      onGenerateRoute:RouteGenerator.generateRoute,
    );
  }
}

