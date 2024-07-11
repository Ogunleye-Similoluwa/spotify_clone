import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/controllers/api_service/ApiService.dart';

import '../models/song.dart';

enum AudioSourceOption { network, asset }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _player = AudioPlayer();
  ApiService service = ApiService();
  String songName= "";
  String songQuery= "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // _setupAudioPlayer(AudioSourceOption.network);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Audio Player",
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 240,
                  height: 50,
                  child: TextField(

                    onSubmitted: (submit) async{
                      if (songName != "") await setupAudioPlayer(submit);
                    },
                    onChanged: (value) async{
                      setState(() {
                        songName= value;
                      });
                      if (songName != "") await setupAudioPlayer(value);
                    },
                  ),
                ),
                TextButton(onPressed: () async{
                  setState(() {
                    songQuery =songName;
                  });
                  if (songName != "") await setupAudioPlayer(songQuery);

                }, child: Text("Submit")),

                _progessBar(),
                Row(
                  children: [
                    _controlButtons(),
                    _playbackControlButton(),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  Future<void> setupAudioPlayer( String query) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
          print("A stream error occurred: $e");
        });
    try {

    Song song = await service.downloadTrack(query);
      // if (option == AudioSourceOption.network) {
        await _player.setAudioSource(AudioSource.uri(
            Uri.parse(song.name!)
        ));
      // }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }



  Widget _progessBar() {
    return StreamBuilder<Duration?>(
      // initialData: ,
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
    );
  }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 64,
              height: 64,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 64,
              onPressed: _player.play,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 64,
              onPressed: _player.pause,
            );
          } else {
            return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64,
                onPressed: () {
                  _player.seek(Duration.zero);
                  _player.play;
                } );
          }
        });
  }

  Widget _controlButtons() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      StreamBuilder(
          stream: _player.speedStream,
          builder: (context, snapshot) {
            return Row(children: [
              const Icon(
                Icons.speed,
              ),
              Slider(
                  min: 1,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 3,
                  onChanged: (value) async {
                    await _player.setSpeed(value);
                  })
            ]);
          }),
      StreamBuilder(
          stream: _player.volumeStream,
          builder: (context, snapshot) {
            return Row(children: [
              const Icon(
                Icons.volume_up,
              ),
              Slider(
                  min: 0,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 4,
                  onChanged: (value) async {
                    await _player.setVolume(value);
                  })
            ]);
          }),
    ]);
  }
}
