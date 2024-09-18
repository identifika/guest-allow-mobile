// To parse this JSON data, do
//
//     final faceRecognitionResponse = faceRecognitionResponseFromJson(jsonString);

import 'dart:convert';

FaceRecognitionResponse faceRecognitionResponseFromJson(String str) =>
    FaceRecognitionResponse.fromJson(json.decode(str));

String faceRecognitionResponseToJson(FaceRecognitionResponse data) =>
    json.encode(data.toJson());

class FaceRecognitionResponse {
  String? message;
  Result? result;
  int? statusCode;

  FaceRecognitionResponse({
    this.message,
    this.result,
    this.statusCode,
  });

  FaceRecognitionResponse copyWith({
    String? message,
    Result? result,
    int? statusCode,
  }) =>
      FaceRecognitionResponse(
        message: message ?? this.message,
        result: result ?? this.result,
        statusCode: statusCode ?? this.statusCode,
      );

  factory FaceRecognitionResponse.fromJson(Map<String, dynamic> json) =>
      FaceRecognitionResponse(
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        statusCode: json["status_code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "result": result?.toJson(),
        "status_code": statusCode,
      };
}

class Result {
  User? user;
  bool? verified;

  Result({
    this.user,
    this.verified,
  });

  Result copyWith({
    User? user,
    bool? verified,
  }) =>
      Result(
        user: user ?? this.user,
        verified: verified ?? this.verified,
      );

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        verified: json["verified"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "verified": verified,
      };
}

class User {
  String? id;
  double? annoyDistance;
  String? clientId;
  int? knnIndexing;
  String? userName;

  User({
    this.id,
    this.annoyDistance,
    this.clientId,
    this.knnIndexing,
    this.userName,
  });

  User copyWith({
    String? id,
    double? annoyDistance,
    String? clientId,
    int? knnIndexing,
    String? userName,
  }) =>
      User(
        id: id ?? this.id,
        annoyDistance: annoyDistance ?? this.annoyDistance,
        clientId: clientId ?? this.clientId,
        knnIndexing: knnIndexing ?? this.knnIndexing,
        userName: userName ?? this.userName,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        annoyDistance: json["annoy_distance"]?.toDouble(),
        clientId: json["client_id"],
        knnIndexing: json["knn_indexing"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "annoy_distance": annoyDistance,
        "client_id": clientId,
        "knn_indexing": knnIndexing,
        "user_name": userName,
      };
}
