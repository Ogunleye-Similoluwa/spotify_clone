import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify/controllers/providers/songs_provider.dart';
import 'package:spotify/views/widgets/CustomButton.dart';
import 'package:spotify/views/widgets/loading.dart';
import '../constants/media_query_constant/constants.dart';
import '../controllers/api_service/ApiService.dart';
import '../controllers/providers/images_provider.dart';

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
                child: isFree?  Loading(): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign for Free",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                onPressed: ()async {
                  if(!isGoogle&& !isEmailAndPassword ){
                    setState(() {
                      isFree = true;
                    });
                    await service.fetchRandomImages().then((value){
                      setState(() {
                        isFree = false;
                      });
                      context.read<ImagesProvider>().setImageUrls(value);
                      Navigator.of(context).pushReplacementNamed("/home");
                    });

                  }
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CustomButton(
                width: 300,
                color: Colors.black,
                height: 54,
                onPressed: () {
                  if(!isFree&& !isGoogle ){
                    setState(() {
                      isEmailAndPassword = true;
                    });

                    Future.delayed(Duration(seconds: 4),(){
                      setState(() {
                        isEmailAndPassword = false;
                      });
                      Navigator.of(context).pushReplacementNamed("/home");
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isEmailAndPassword?Loading(color: Colors.white,) :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "icons/e_p.png",
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Sign up with Email and Password",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30, bottom: 20),
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
                onPressed: () {
                  if(!isFree&& !isEmailAndPassword ){
                    setState(() {
                      isGoogle = true;
                    });
                    Future.delayed(Duration(seconds: 4),(){
                      setState(() {
                        isGoogle = false;
                      });
                      Navigator.of(context).pushReplacementNamed("/home");
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).pushReplacementNamed("/sign_in");
              },
              child: Text(
                "Login",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
