import 'dart:convert';

import 'package:firstapp/core/constants/constants.dart';
import 'package:firstapp/core/model/store_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user_data.dart';

class PreferenceHelper{
  static String user = 'user';
  static String data = 'data';

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

  static Future<UserData?> setData(StoreData? storeData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(data, json.encode(storeData));
  }

  static Future<StoreData?> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    StoreData? response;
    String? data1 = prefs.getString(data);
    if(data1!=null){
      Map<String, dynamic> datas = jsonDecode(data1);
      response = StoreData.fromJson(datas);
    }
    return response;
  }

  static addBoolToSF(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(REGISTER, value);
  }

  static getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(key);
  }

  static Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(user);
    prefs.remove(data);
  }

}