import 'package:firstapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../strings.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationServices _auth = AuthenticationServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildEmailText(),
          _buildPasswordInput(),
          _buildForgotPassword(),
          _buildLoginButton()
        ],
      )),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Text(
        Strings.login,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmailText() {
    return Container(
      margin: const EdgeInsets.all(18),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: Strings.email,
          hintStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: Strings.password,
          hintStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(right: 18, top: 12),
      child: Text(
        Strings.forgotPassword,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      onTap: () async {
        bool isLogin = await _auth.emailLogin(emailController.text, passwordController.text);
        if(isLogin){
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 18, right: 18, top: 25),
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black26,
        ),
        child: Center(
          child: Text(
            Strings.login,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
