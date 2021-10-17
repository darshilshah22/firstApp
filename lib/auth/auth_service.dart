import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firstapp/core/model/store_data.dart';
import 'package:firstapp/core/model/user_data.dart';
import 'package:firstapp/core/preferences.dart';
import 'package:firstapp/core/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../strings.dart';

class AuthenticationServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;

  void checkValidations(BuildContext context, String firstname, String lastname, String phone,
      String email, String password, String cPassword) async{
    bool isCheckEmail = Utils().validateEmail(email);

    if (firstname.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterFirstName);
    } else if (lastname.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterLastName);
    } else if (phone.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterPhone);
    } else if (email.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterEmail);
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterPassword);
    } else if (cPassword.isEmpty) {
      Fluttertoast.showToast(msg: Strings.enterCPassword);
    } else if (cPassword != password) {
      Fluttertoast.showToast(msg: Strings.cPassword);
    } else {
      if (isCheckEmail) {
        UserData userData = UserData(
            firstname: firstname,
            lastname: lastname,
            phone: "+91" + phone,
            email: email,
            isLinked: false);
        registerUser(email, password, userData, context);
        PreferenceHelper.addBoolToSF(true);
      }
    }
  }

  void registerUser(String email, String password, UserData userData, BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .catchError((e) {
          Fluttertoast.showToast(msg: Strings.somethingWrong);
        });

    if(querySnapshot.docs.isNotEmpty){
      Fluttertoast.showToast(msg: Strings.userAvailable);
    }else{
      createNewUser(email, password, userData, context);
    }
  }

  void createNewUser(String email, String password, UserData userData, BuildContext context) async {
    String? token;
    FirebaseMessaging.instance.getToken().then((value) {
      token = value;
    });
    try{
      auth.signOut();
      await auth.createUserWithEmailAndPassword(email: email, password: password).catchError((onError){}).then((UserCredential userCredential) async {
        if(userCredential != null){
          User? user = userCredential.user;
          userData.authId = user!.uid;
          userData.fcmToken = token;
          addDataInFirestore(userData, context);
        }
      });
    }catch(e){
      Fluttertoast.showToast(msg: Strings.somethingWrong);
    }
  }

  void addDataInFirestore(UserData userData, BuildContext context) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('User').add(userData.toJson());
    userData.id = docRef.id;
    await PreferenceHelper.setUser(userData);
    Navigator.pushNamed(context, '/home');
  }

  Future<bool> checkMobile(String phone, String otp) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('phone', isEqualTo: "+91" + phone)
        .get()
        .catchError((e) {
      Fluttertoast.showToast(msg: Strings.somethingWrong);
    });

    if(querySnapshot.docs.isNotEmpty){
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      if(documentSnapshot!=null) {
        UserData? userData = UserData.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
        print("islinked: " + userData.isLinked.toString());
        if (userData.isLinked == false) {
          linkEmailPhone(userData.phone!);
          return true;
        } else {
          signInWithPhoneNumber(userData.phone!);
          return true;
        }
      }
    }else{
      print('error');
      return false;
    }
    return false;
  }

  linkEmailPhone(String phoneNo) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verId, int? forceResend) async {
            verificationId = verId;
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          }
      );

    }catch(e){
      print(e);
    }
  }

  void updateDataInFirestore(String id) async{
    FirebaseFirestore.instance.collection('User').doc(id).update({'is_linked': true});
  }

  void signInWithPhoneNumber(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verId, int? forceResend) async {
            verificationId = verId;
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          }
      );
    }catch(e){
      print(e);
    }
  }

  Future<bool> signInPhoneNumber(String phone, String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential;
    User? existingUser = FirebaseAuth.instance.currentUser;
    try{
      print("ssasd");
      credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otp);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('User').where('phone', isEqualTo: "+91" + phone).get().catchError((onError){
        print("sdasadsasadsa");
      });
      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        if(documentSnapshot.data()!=null){
          print("ssasdsdsd");
          UserData? userData = UserData.fromJson(documentSnapshot.data() as Map<String, dynamic>);
          print(userData.email);
          if(userData.isLinked == false){
            await existingUser!.linkWithCredential(credential);
            updateDataInFirestore(documentSnapshot.id);
            await PreferenceHelper.setUser(userData);
            return true;
          }else{
            await auth.signInWithCredential(credential);
            await PreferenceHelper.setUser(userData);
            return true;
          }
        }
      }
    }catch(e){
      print(e);
    }
    print("hhvhv");
    return false;
  }

  Future<bool> emailLogin(String email, String password) async {
    try{
      User? user = (await auth.signInWithEmailAndPassword(email: email, password: password)).user;
      if(user!=null){
        return true;
      }else{
        Fluttertoast.showToast(msg: "User not found");
        return false;
      }
    }catch(e){
      print(e);
    }
    return false;
  }

  void checkDataValidation(String data1, String data2, bool isUpdate){
    if(data1.isEmpty){
      Fluttertoast.showToast(msg: "Data1 is empty");
    }else if(data2.isEmpty){
      Fluttertoast.showToast(msg: "Data2 is empty");
    }else{
      StoreData storeData = StoreData(
        data1: data1,
        data2: data2,
      );
      if(isUpdate){
        updateData(storeData);
      }else {
        addDataToStore(storeData);
      }
    }
  }

  Future<void> addDataToStore(StoreData storeData) async {
    try{
      DocumentReference ref = await FirebaseFirestore.instance.collection('StoreData').add(storeData.toJson());
      storeData.id = ref.id;
      await PreferenceHelper.setData(storeData);
      print(storeData.id);
      print("success");
    }on FirebaseAuthException catch(e){
      print(e);
    }
  }

  void updateData(StoreData storeData) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('StoreData').where('data2', isEqualTo: "dataaaaaaa").get();
    String id = querySnapshot.docs[0].id;
    storeData.id = id;
    FirebaseFirestore.instance.collection('StoreData').doc(id).update(storeData.toJson());
  }
}
