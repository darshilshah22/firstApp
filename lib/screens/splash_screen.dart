import 'dart:async';

import 'package:firstapp/core/model/user_data.dart';
import 'package:firstapp/core/preferences.dart';
import 'package:firstapp/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserData? userData;

  @override
  void initState() {
    userData = UserData();
    Timer(const Duration(seconds: 2), (){
      getUserData();
    });
    super.initState();
  }

  void getUserData() async {
    userData = await PreferenceHelper.getUser();
    if(userData!=null){
      Navigator.pushNamed(context, '/home');
    }else{
      Navigator.pushNamed(context, '/register');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Strings.welcome,
          style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
