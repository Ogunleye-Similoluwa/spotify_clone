import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/providers/song_tile_provider.dart';
import '../../controllers/providers/songs_provider.dart';
import '../../models/song.dart';


class SongTile extends StatefulWidget {
  final Song song;
  SongTile({Key? key, required this.song}) : super(key: key);

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SongTileProvider>(context, listen: false).setCurrentSong(context,widget.song);
        Provider.of<SongTileProvider>(context, listen: false).playAudio(context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(widget.song.musicName ?? "Unknown Title", style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black)),
          subtitle: Text(widget.song.artistName ?? "Unknown Artist",style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black)),
          leading: Image.network(widget.song.image ?? "images/spotify.png",),
          trailing: IconButton(
            icon: Icon(
              isLiked ? Icons.play_arrow : Icons.play_circle_outline,
              color: isLiked ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
                Provider.of<SongTileProvider>(context, listen: false).setCurrentSong(context,widget.song);
                Provider.of<SongTileProvider>(context, listen: false).playAudio(context);
              });

              if (isLiked) {
                setState(() {
                  widget.song.setIsLiked(isLiked);
                });

                context.read<SongTileProvider>().addFavoriteSong(context,widget.song);
              } else {
                setState(() {
                  widget.song.setIsLiked(isLiked);
                });
                context.read<SongTileProvider>().removeFavoriteSong(context,widget.song);
              }
            },
          ),
        ),
      ),
    );
  }
}
