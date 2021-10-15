import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firstapp/core/model/user_data.dart';
import 'package:firstapp/core/preferences.dart';
import 'package:firstapp/core/util/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../strings.dart';

class AuthenticationServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;

  bool checkValidations(String firstname, String lastname, String phone,
      String email, String password, String cPassword) {
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

        registerUser(email, password, userData);
        return true;
      }
    }
    return false;
  }

  void registerUser(String email, String password, UserData userData) async {
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
      createNewUser(email, password, userData);
    }
  }

  void createNewUser(String email, String password, UserData userData) async {
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
          addDataInFirestore(userData);
        }
      });
    }catch(e){
      Fluttertoast.showToast(msg: Strings.somethingWrong);
    }
  }

  void addDataInFirestore(UserData userData) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('User').add(userData.toJson());
    userData.id = docRef.id;
    await PreferenceHelper.setUser(userData);
    print(userData.fcmToken);
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
          linkEmailPhone(phone, otp);
          updateDataInFirestore(documentSnapshot.id);
          await PreferenceHelper.setUser(userData);
          return true;
        } else {
          signInWithPhoneNumber(phone, otp);
          await PreferenceHelper.setUser(userData);
          return true;
        }
      }
    }else{
      print('error');
      return false;
    }
    return false;
  }

  linkEmailPhone(String phoneNo, String otp) async {
    print("Yes");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + phoneNo,
          timeout: const Duration(seconds: 5),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verId, int? forceResend) async {
            verificationId = verId;
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otp);
            signIn(credential);
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

  signIn(PhoneAuthCredential phoneAuthCredential) async {
    User? existingUser = FirebaseAuth.instance.currentUser;
    UserCredential credential = await existingUser!.linkWithCredential(phoneAuthCredential);
  }

  void signInWithPhoneNumber(String phone, String otp) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + phone,
          timeout: const Duration(seconds: 50),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verId, int? forceResend) async {
            verificationId = verId;
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otp);
            await auth.signInWithCredential(credential);
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          }
      );
    }catch(e){
      print(e);
    }
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
}
