import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/songs_provider.dart';
import 'package:spotify/views/widgets/global_song_player.dart';
import 'package:spotify/views/widgets/song_tile.dart';
import 'package:spotify/views/widgets/square_tile.dart';
import '../../controllers/api_service/ApiService.dart';
import '../../models/song.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            GlobalSongPlayer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF1DB954),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                context.read<SongsProvider>().recentSongs.isEmpty?SizedBox.shrink(): Column(
                  children: [
                    Text(
                      'Recent Songs',
                      style: GoogleFonts.aleo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildRecentSongsList(context),
                    SizedBox(height: 20),
                  ],
                ),
        
               context.read<SongsProvider>().favoriteSongs.isEmpty?SizedBox.shrink(): Column(
                  children: [
                    Text(
                      'Liked Songs',
                      style: GoogleFonts.aleo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildLikedSongsList(context),
                  ],
                ),
                SizedBox(height: 10),
        
                // Add more sections as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSongsList(BuildContext context) {
    List<Song> recentSongs = context.watch<SongsProvider>().recentSongs;
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentSongs.length,
        itemBuilder: (context, index) {
          return SongSquareTile(song: recentSongs[index]);
        },
      ),
    );
  }

  Widget _buildLikedSongsList(BuildContext context) {

    List<Song> likedSongs =  context.watch<SongsProvider>().favoriteSongs;
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: likedSongs.length,
        itemBuilder: (context, index) {
          return SongSquareTile(song: likedSongs[index]);
        },
      ),
    );
  }
}







class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiService service = ApiService();
  List<Song> songs = [];
  String songQuery = "";

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
              _searchSong(context);
            }
          },
        ),
      ),
      body: Padding(
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
        songs = [song];
      });
      context.read<SongsProvider>().addRecentSong(song);
    } catch (e) {
      print("Error fetching song: $e");
    }
  }
}



class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Library Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}