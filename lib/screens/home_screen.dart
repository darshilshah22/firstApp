import 'package:firstapp/core/model/user_data.dart';
import 'package:firstapp/core/preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;

  Future<void> getUserData() async {
    userData = await PreferenceHelper.getUser();
  }

  @override
  void initState() {
    userData = UserData();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FirstName: " + userData!.firstname!,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Text(
              "lastName: " + userData!.lastname!,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Text(
              "Phone: " + userData!.phone!,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Text(
              "Email: " + userData!.email!,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Text(
              "isLinked: " + userData!.isLinked.toString(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                  onPressed: () async {
                    await PreferenceHelper.clearPreferences();
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text(
                    Strings.logout,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 26)),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
