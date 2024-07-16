import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:spotify/router/routeGenerator.dart';
import 'package:spotify/storage/shared_prefrences.dart';

import 'controllers/api_service/auth_service.dart';
import 'controllers/providers/images_provider.dart';
import 'controllers/providers/song_tile_provider.dart';
import 'controllers/providers/songs_provider.dart';
import 'controllers/providers/users_provider.dart';
import 'firebase_options.dart';
import 'models/baseUser.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SharedPrefs.init();
  await Hive.initFlutter();
  var box = Hive.openBox("Songs");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<BaseUser?>.value(
          value: AuthService().baseUser,
          initialData: BaseUser(uid: ''),
          // lazy: true,
        ),
        ChangeNotifierProvider(create: (context) => SongTileProvider(context)),
        ChangeNotifierProvider(create: (_) => SongsProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),


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
    // )
    );
  }
}

