import 'dart:convert';

import 'package:guest_allow/modules/global_models/user_model.dart';

class SignInResponse {
  int? statusCode;
  String? message;
  String? token;
  UserModel? user;

  SignInResponse({
    this.statusCode,
    this.message,
    this.token,
    this.user,
  });

  factory SignInResponse.fromRawJson(String str) =>
      SignInResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        statusCode: json["status_code"],
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "token": token,
        "user": user?.toJson(),
      };
}
