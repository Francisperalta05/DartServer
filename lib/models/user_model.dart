// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? firstName;
  String? lastName;
  String? userName;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? password;
  String? userUID;

  UserModel({
    this.firstName,
    this.lastName,
    this.userName,
    this.dateCreated,
    this.dateUpdated,
    this.password,
    this.userUID,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        password: json["password"],
        userName: json["user_name"],
        userUID: json["user_uid"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName?.trim(),
        "last_name": lastName?.trim(),
        "date_created": dateCreated?.toIso8601String(),
        "date_updated": dateUpdated?.toIso8601String(),
        "password": password?.trim(),
        "user_uid": userUID,
        "user_name": userName?.trim(),
      };
}
