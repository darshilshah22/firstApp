import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/user_data.dart';

class PreferenceHelper{

  static String user = 'user';

  static Future<UserData?> setUser(UserData? userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(user, json.encode(userData));
  }

  static Future<UserData?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    UserData? response;
    String? data = prefs.getString(user);
    if(data!=null){
      Map<String, dynamic> users = jsonDecode(data);
      response = UserData.fromJson(users);
    }
    return response;
  }

  static Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(user);
  }

}