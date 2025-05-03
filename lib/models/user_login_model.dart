import 'dart:convert';

class UserLoginModel {
  bool success;
  String message;
  String token;
  User user;

  UserLoginModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory UserLoginModel.fromRawJson(String str) =>
      UserLoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        success: json["success"],
        message: json["message"],
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  String id;
  String userfName;
  String userlName;
  String userEmail;
  String userPhone;

  User({
    required this.id,
    required this.userfName,
    required this.userlName,
    required this.userEmail,
    required this.userPhone,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userfName: json["userfName"],
        userlName: json["userlName"],
        userEmail: json["userEmail"],
        userPhone: json["userPhone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userfName": userfName,
        "userlName": userlName,
        "userEmail": userEmail,
        "userPhone": userPhone,
      };
}
