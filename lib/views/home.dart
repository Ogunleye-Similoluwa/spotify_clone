// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/songs_provider.dart';
import 'package:spotify/views/search_scree.dart';
import 'package:spotify/views/widgets/global_song_player.dart';
import 'package:spotify/views/widgets/square_tile.dart';
import '../../models/song.dart';
import '../controllers/providers/images_provider.dart';
import 'library.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  int _selectedIndex = 0;


  List<Widget>  _widgetOptions = [
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


class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key });



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child:
            context.watch<SongsProvider>().recentSongs.isEmpty ?
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'New Here ?',
                    style: GoogleFonts.inriaSerif(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' Click the Search button ',
                    style: GoogleFonts.inriaSerif(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    ' Search for your songs',
                    style: GoogleFonts.inriaSerif(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),


                  SizedBox(height: 30,),

                  Container(width:800, height:300, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),child: ImageSlider(imgList: context.watch<ImagesProvider>().imgUrls),)


                ],
              ),
            )
                :
                 Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: GoogleFonts.inriaSerif(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                 context.watch<SongsProvider>().recentSongs.isEmpty?SizedBox.shrink(): Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

               context.watch<SongsProvider>().favoriteSongs.isEmpty?SizedBox.shrink(): Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
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

class ImageSlider extends StatelessWidget {
  final List<dynamic> imgList;
  const ImageSlider({super.key,  required this.imgList});
  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        autoPlayCurve: Curves.easeInBack,
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,),
      items: imgList
          .map((item) => Image.network(item, fit: BoxFit.cover,))
          .toList(),
    );
  }
}
