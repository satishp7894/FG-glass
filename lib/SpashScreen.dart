import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/MPIN.dart';

import 'package:flutter_fg_glass_app/login.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    final docDir = await getApplicationDocumentsDirectory();
    Hive.init(docDir.path);
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mpinState =  prefs.getBool('MPIN') ?? false;

    setState(() {
      if(mpinState == false){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
      }
      if(mpinState== true){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => MPIN()));
      }

    });

  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 3));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          // Adding bg.png as a background image to this Container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Splash.png"),
                fit: BoxFit.cover,
              ),
            )));
  }
}
