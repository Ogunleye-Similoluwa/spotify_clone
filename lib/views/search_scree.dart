import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/song_tile_provider.dart';
import 'package:spotify/views/widgets/loading.dart';
import 'package:spotify/views/widgets/song_tile.dart';

import '../controllers/api_service/ApiService.dart';
import '../controllers/providers/songs_provider.dart';
import '../models/song.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiService service = ApiService();
  List<Song> songs = [];
  String songQuery = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: TextEditingController(),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for songs, artists, albums...',
            hintStyle: GoogleFonts.inriaSerif(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            songQuery = value;
          },
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              setState(() {
                isLoading = true;
              });
              _searchSong(context);
            }
          },
        ),
      ),
      body: isLoading ? Center(child: Loading(color: Colors.white,)): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(child: _buildSongList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return SongTile(song: songs[index]);
      },
    );
  }

  void _searchSong(BuildContext context) async {
    if (songQuery.isEmpty) return;

    try {
      Song song = await service.downloadTrack(songQuery);
          setState(() {
            isLoading = false;
            songs = [song];
          });
      context.read<SongTileProvider>().addRecentSong(context,song);
    } catch (e) {
      print("Error fetching song: $e");
    }
  }
}

