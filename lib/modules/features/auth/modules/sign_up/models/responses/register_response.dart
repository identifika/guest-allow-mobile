// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  int? statusCode;
  String? message;
  UserRegistered? user;

  RegisterResponse({
    this.statusCode,
    this.message,
    this.user,
  });

  RegisterResponse copyWith({
    int? statusCode,
    String? message,
    UserRegistered? user,
  }) =>
      RegisterResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        user: user ?? this.user,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        statusCode: json["status_code"],
        message: json["message"],
        user:
            json["user"] == null ? null : UserRegistered.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "user": user?.toJson(),
      };
}

class UserRegistered {
  String? name;
  String? email;
  String? timezone;
  String? id;
  String? updatedAt;
  String? createdAt;

  UserRegistered({
    this.name,
    this.email,
    this.timezone,
    this.id,
    this.updatedAt,
    this.createdAt,
  });

  UserRegistered copyWith({
    String? name,
    String? email,
    String? timezone,
    String? id,
    String? updatedAt,
    String? createdAt,
  }) =>
      UserRegistered(
        name: name ?? this.name,
        email: email ?? this.email,
        timezone: timezone ?? this.timezone,
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserRegistered.fromJson(Map<String, dynamic> json) => UserRegistered(
        name: json["name"],
        email: json["email"],
        timezone: json["timezone"],
        id: json["id"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "timezone": timezone,
        "id": id,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
}
