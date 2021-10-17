import 'package:firstapp/auth/auth_service.dart';
import 'package:firstapp/core/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../strings.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  final TextEditingController data1Controller = TextEditingController();
  final TextEditingController data2Controller = TextEditingController();
  final TextEditingController data3Controller = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final AuthenticationServices _auth = AuthenticationServices();


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
            _buildCameraView(),
            _buildHeading(Strings.data1),
            _buildDataInput(Strings.data1, data1Controller),
            _buildHeading(Strings.data2),
            _buildDataInput(Strings.data2, data2Controller),
            _buildRegisterButton(),
            _buildRegister()
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

  Widget _buildCameraView(){
    return InkWell(
      onTap: (){
        _showPicker(context);
      },
      child: Container(
        width: 30,
        margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  Widget _buildDataInput(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 14),
      child: TextFormField(
        controller: controller,
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    print(_image!.name);
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    print("sadjsad: " + _image!.path);
  }

  Widget _buildRegisterButton() {
    return InkWell(
      onTap: () async {
        _auth.checkDataValidation(data1Controller.text, data2Controller.text, true);
        Navigator.pushNamed(context, '/screenTwo');
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
              PreferenceHelper.clearPreferences();
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
              PreferenceHelper.clearPreferences();
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
