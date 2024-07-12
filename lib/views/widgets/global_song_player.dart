import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:spotify/models/song.dart';

import '../../controllers/providers/song_tile_provider.dart';
import '../../controllers/providers/songs_provider.dart';

class GlobalSongPlayer extends StatefulWidget {
  const GlobalSongPlayer({super.key});

  @override
  State<GlobalSongPlayer> createState() => _GlobalSongPlayerState();
}

class _GlobalSongPlayerState extends State<GlobalSongPlayer> {
  bool isMinimized = false;
  Offset position = const Offset(20, 20);
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongTileProvider>(context);
    final song = songProvider.currentSong;


    if (song == null) {
      return SizedBox.shrink();
    }

    return

      Stack(
        children: [
          isMinimized ?
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: buildMinimizedPlayer(context, song),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  position = details.offset;
                });
              },
              child: buildMinimizedPlayer(context, song),
            ),
          )
              : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(song.musicName ?? "Unknown Title", style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                    subtitle: Text(song.artistName ?? "Unknown Artist",style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white)),
                    leading: Image.network(song.image ?? "images/spotify.png"),
                    trailing: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          IconButton(
                            icon: Icon(
                              song.isLiked! ? Icons.favorite : Icons.favorite_border,
                              color:  song.isLiked! ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                               song.setIsLiked(!song.isLiked!);
                              });
                              if (song.isLiked!) {
                                song.setIsLiked(song.isLiked!);
                                context.read<SongsProvider>().addFavoriteSong(song);
                              } else {
                                song.setIsLiked(song.isLiked!);
                                context.read<SongsProvider>().removeFavoriteSong(song);
                              }


                            },
                          ),

                          IconButton(onPressed: () {
                            setState(() {
                              isMinimized = !isMinimized;
                            });

                          }, icon: Icon(Icons.minimize, size: 40,),

                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildPlayerControls(songProvider),
                  _buildProgressBar(songProvider),
                ],
              ),
            ),
          )
        ],
      );
  }


  Widget buildMinimizedPlayer(BuildContext context, Song song) {
    return Material(
      child: Container(
        width: 300,
        color: Colors.black,
        child: ListTile(
          title: Text(
            song.musicName ?? "Unknown Title",
            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Image.network(song.image ?? "images/spotify.png"),
          trailing: IconButton(
            icon: Icon(Icons.expand, size: 30, color: Colors.white),
            onPressed: () {
              setState(() {
                isMinimized = !isMinimized;
              });
            },
          ),
        ),
      ),
    );
  }
  Widget _buildPlayerControls(SongTileProvider songProvider) {
    return StreamBuilder<PlayerState>(
      stream: songProvider.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final processingState = playerState?.processingState;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        } else if (!isPlaying) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 48,
            onPressed: songProvider.playAudio
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 48,
            onPressed: songProvider.pauseAudio,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 48,
            onPressed: () {
              // songProvider.audioPlayer.seek(Duration.zero);
              songProvider.replayAudio();
            },
          );
        }
      },
    );
  }

    Widget _buildProgressBar(SongTileProvider songProvider) {
      return StreamBuilder<Duration?>(

        stream: songProvider.audioPlayer.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final duration = songProvider.audioPlayer.duration ?? Duration.zero;
         Song newSong = Song(position: position);
         context.read<SongTileProvider>().setCurrentSongPosition(newSong);
          return ProgressBar(

            progressBarColor: Colors.green,
            bufferedBarColor: Colors.white,
            baseBarColor: Colors.white,
            progress: position,
            total: duration,
            thumbColor: Colors.green,
            timeLabelTextStyle: GoogleFonts.aleo(fontWeight: FontWeight.bold ,fontSize: 17,color: Colors.white),
            onSeek: (duration) {
              print("$duration    +  seconds");
              print("${Duration.zero}    +  seconds");
              songProvider.audioPlayer.seek(duration);
            },
          );
        },
      );
    }
}
