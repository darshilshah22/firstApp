import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/screens/home_screen.dart';
import 'package:firstapp/screens/login_screen.dart';
import 'package:firstapp/screens/mobile_login.dart';
import 'package:firstapp/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MobileLogin(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/email': (context) => const EmailLogin(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
