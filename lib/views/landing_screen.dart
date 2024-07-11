import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:spotify/constants/media_query_constant/constants.dart";



class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState(){
    Future.delayed(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacementNamed("/sign_up");
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:getMediaQuerySize(context: context).width,
          height:getMediaQuerySize(context: context).height,
        decoration:BoxDecoration(
         color:Colors.black
        ) ,
        child:Center(
          child: SvgPicture.asset("icons/spotify.svg",)
        ) ,
      ),
    );
  }
}
