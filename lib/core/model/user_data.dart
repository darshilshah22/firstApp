class UserData {
  String? firstname;
  String? lastname;
  String? phone;
  String? email;
  String? authId;
  String id = '';
  bool? isLinked;
  String? fcmToken;

  UserData(
      {this.firstname,
      this.lastname,
      this.phone,
      this.email,
      this.authId,
      this.isLinked,
      this.fcmToken});

  UserData.fromJson(Map<String, dynamic> json):
      firstname = json["first_name"],
      lastname = json["last_name"],
      phone = json["phone"],
      email = json["email"],
      authId = json["auth_id"],
      id = json["id"],
      isLinked = json["is_linked"],
      fcmToken = json["fcm_token"];

  Map<String, dynamic> toJson() => {
    'first_name': firstname,
    'last_name': lastname,
    'phone': phone,
    'email': email,
    'auth_id': authId,
    'id': id,
    'is_linked': isLinked,
    'fcm_token': fcmToken
  };


}