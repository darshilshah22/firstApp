import 'package:fluttertoast/fluttertoast.dart';

import '../../strings.dart';

class Utils{
  bool validateEmail(String value) {
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      Fluttertoast.showToast(msg: Strings.emailValid);
      return false;
    } else {
      return true;
    }
  }
}