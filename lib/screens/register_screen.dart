import 'package:firstapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailRController = TextEditingController();
  final TextEditingController passwordRController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthenticationServices _auth = AuthenticationServices();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildNameInput(),
            _buildPhoneInput(),
            _buildEmailInput(),
            _buildPasswordInput(),
            _buildConfirmPasswordInput(),
            _buildRegisterButton(),
            _buildRegister(),
          ],
        ),
            if(isLoading)_buildProgressIndicator(),
      ])),
    );
  }

  Widget _buildProgressIndicator() {
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
        Strings.register,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNameInput() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 18, right: 6, top: 18),
            child: TextFormField(
              controller: firstNameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: Strings.firstName,
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
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 6, right: 18, top: 18),
            child: TextFormField(
              controller: lastNameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: Strings.lastName,
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
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
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

  Widget _buildEmailInput() {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: TextFormField(
        controller: emailRController,
        textInputAction: TextInputAction.next,
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
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: TextFormField(
        controller: passwordRController,
        textInputAction: TextInputAction.next,
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

  Widget _buildConfirmPasswordInput() {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: TextFormField(
        controller: confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: Strings.confirmPassword,
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

  Widget _buildRegisterButton() {
    return InkWell(
      onTap: () async {
        _auth.checkValidations(context,
            firstNameController.text,
            lastNameController.text,
            phoneController.text,
            emailRController.text,
            passwordRController.text,
            confirmPasswordController.text);
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
            Strings.register,
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

  Widget _buildRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () {
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
}
