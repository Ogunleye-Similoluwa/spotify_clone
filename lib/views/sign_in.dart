import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify/views/widgets/CustomButton.dart';
import 'package:spotify/views/widgets/loading.dart';
import '../constants/media_query_constant/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isEmailAndPassword = false;
  bool isGoogle=false;
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
              "Welcome Back ",
              style: GoogleFonts.aleo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Text(
              "Endless Possibility of Musics Ahead",
              style: GoogleFonts.aleo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CustomButton(
                width: 300,
                color: Colors.black,
                height: 54,
                onPressed: () {
                  if(!isGoogle ){
                    setState(() {
                      isEmailAndPassword = true;
                    });
                    Future.delayed(Duration(seconds: 4),(){
                      setState(() {
                        isEmailAndPassword = false;
                      });
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
                      "Login with Email and Password",
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
                  if(!isEmailAndPassword ){
                    setState(() {
                      isGoogle = true;
                    });
                    Future.delayed(Duration(seconds: 4),(){
                      setState(() {
                        isGoogle = false;
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/sign_up");
              },
              child: Text(
                "Sign up",
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
