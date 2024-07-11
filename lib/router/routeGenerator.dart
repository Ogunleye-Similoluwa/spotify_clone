
import 'package:flutter/material.dart';
import 'package:spotify/views/home.dart';
import 'package:spotify/views/sign_up.dart';
import 'package:spotify/views/widgets/player_widget.dart';

import '../views/landing_screen.dart';
import '../views/sign_in.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => LandingScreen());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => SignUp()) ;
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignIn()) ;
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage()) ;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(
          child: Text("ERROR"),
        ),
      );
    });
  }

}