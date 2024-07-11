import 'package:flutter/material.dart';
import '../../controllers/api_service/ApiService.dart';
import '../../models/song.dart';
import 'song_tile.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  ApiService service = ApiService();
  List<Song> songs = [];
  String songQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Player')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildSongList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Song Name',
            ),
            onChanged: (value) {
              songQuery = value;
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchSong,
          child: const Text('Search'),
        ),
      ],
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

  void _searchSong() async {
    if (songQuery.isEmpty) return;

    try {
      Song song = await service.downloadTrack(songQuery);
      setState(() {
        songs = [song];
      });
    } catch (e) {
      print("Error fetching song: $e");
    }
  }
}
