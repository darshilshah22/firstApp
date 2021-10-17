import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../strings.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final TextEditingController data1Controller = TextEditingController();
  final TextEditingController data2Controller = TextEditingController();
  final TextEditingController data3Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeading(Strings.uploadImage),
            _buildDataInput(Strings.uploadImage, data3Controller),
            _buildHeading(Strings.data1),
            _buildDataInput(Strings.data1, data1Controller),
            _buildHeading(Strings.data2),
            _buildDataInput(Strings.data2, data2Controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String heading){
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Text(
        heading,
        style: GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }

  Widget _buildDataInput(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
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
}
