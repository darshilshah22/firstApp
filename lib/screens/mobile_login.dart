import 'dart:async';

import 'package:firstapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../strings.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  TextEditingController otpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool isOTP = false;
  bool? isEnterOTP;
  final AuthenticationServices _auth = AuthenticationServices();
  bool isLoading = false;
  String? otp;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildLoginButton(),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(isLoading)_buildProgressIndicator(),
              _buildTitle(),
              _buildMobileInput(),
              if(isOTP)_buildOtpInput(),
              _buildRegisterButton()
            ],
          )),
    );
  }

  Widget _buildProgressIndicator(){
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
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

  Widget _buildMobileInput() {
    return Container(
      margin: const EdgeInsets.all(18),
      child: TextFormField(
        controller: mobileController,
        keyboardType: TextInputType.phone,
        onFieldSubmitted: (v) async {
          setState(() {
            isOTP = true;
          });
          await _auth.checkMobile(mobileController.text, otpController.text);
        },
        decoration: InputDecoration(
          hintText: Strings.mobile,
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

  Widget _buildOtpInput(){
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: PinCodeTextField(
        length: 6,
        appContext: context,
        controller: otpController,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 50,
          inactiveFillColor: Colors.white,
          inactiveColor: Colors.black26
        ),
        enableActiveFill: true,
        onChanged: (String value) {  },
        onCompleted: (String value){
          setState(() {
            otp = value;
          });
        },
      ),
    );
  }

  Widget _buildRegisterButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextButton(
              onPressed: (){
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                Strings.register,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/email');
            },
            child: Text(
              Strings.email,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      onTap: () async {
        bool isLogin = await _auth.signInPhoneNumber(mobileController.text, otp!);
        if(isLogin){
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black26,
        ),
        child: Text(
          Strings.login,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
        ),
      ),
    );
  }
}

