import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/songs_provider.dart';
import 'package:spotify/views/widgets/CustomButton.dart';
import 'package:spotify/views/widgets/loading.dart';
import '../constants/media_query_constant/constants.dart';
import '../controllers/api_service/ApiService.dart';
import '../controllers/api_service/auth_service.dart';
import '../controllers/providers/images_provider.dart';
import '../controllers/providers/song_tile_provider.dart';
import '../controllers/providers/users_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isFree = false;
  bool isEmailAndPassword = false;
  bool isGoogle=false;
  ApiService service = ApiService();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: getMediaQuerySize(context: context).width,
        height: getMediaQuerySize(context: context).height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SvgPicture.asset("icons/spotify.svg"),
            Text(
              "Millions of Spotify",
              style: GoogleFonts.aleo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Text(
              "Free on Spotify",
              style: GoogleFonts.aleo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30, top: 30),
              child: CustomButton(
                width: 300,
                color: Colors.green,
                height: 54,
                onPressed: ()async {
                  if(!isGoogle ){
                    setState(() {
                      isFree = true;
                    });

                    await authService.signInAnon().then((baseUser) async {
                      await service.fetchRandomImages().then((value){
                        setState(() {
                          isFree = false;
                        });
                        context.read<UsersProvider>().setUser(baseUser);
                        // context.read<SongTileProvider>().setUser(baseUser);
                        context.read<ImagesProvider>().setImageUrls(value);
                        Navigator.of(context).pushReplacementNamed("/home");
                      });
                    });

                  }
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isFree?  Loading(): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In Anonymously ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30,right: 30.0, left: 30, bottom: 20),
              child: CustomButton(
                width: 300,
                color: Colors.black,
                height: 54,
                child: isGoogle? Loading(color:Colors.white): Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "icons/l_g.png",
                      width: 30,
                      height: 30,
                    ),

                    Text(
                      "Continue with Google",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                onPressed: ()async {
                  if(!isFree){
                    setState(() {
                      isGoogle = true;
                    });
                    await authService.signInWithGoogle().then((baseUser) async {
                      await service.fetchRandomImages().then((value){
                        setState(() {
                          isGoogle = false;
                        });
                        context.read<UsersProvider>().setUser(baseUser!);
                        // context.read<SongTileProvider>().setUser(baseUser);
                        context.read<ImagesProvider>().setImageUrls(value);
                        Navigator.of(context).pushReplacementNamed("/home");
                      });
                    });

                  }
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
