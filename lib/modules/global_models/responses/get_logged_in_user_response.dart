// To parse this JSON data, do
//
//     final getLoggedInUser = getLoggedInUserFromJson(jsonString);

import 'dart:convert';

import 'package:guest_allow/modules/global_models/user_model.dart';

GetLoggedInUser getLoggedInUserFromJson(String str) =>
    GetLoggedInUser.fromJson(json.decode(str));

String getLoggedInUserToJson(GetLoggedInUser data) =>
    json.encode(data.toJson());

class GetLoggedInUser {
  int? statusCode;
  String? message;
  UserModel? user;

  GetLoggedInUser({
    this.statusCode,
    this.message,
    this.user,
  });

  factory GetLoggedInUser.fromJson(Map<String, dynamic> json) =>
      GetLoggedInUser(
        statusCode: json["status_code"],
        message: json["message"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "user": user?.toJson(),
      };
}
