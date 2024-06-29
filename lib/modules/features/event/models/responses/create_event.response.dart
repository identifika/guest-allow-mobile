// To parse this JSON data, do
//
//     final createEventResponse = createEventResponseFromJson(jsonString);

import 'dart:convert';

CreateEventResponse createEventResponseFromJson(String str) =>
    CreateEventResponse.fromJson(json.decode(str));

String createEventResponseToJson(CreateEventResponse data) =>
    json.encode(data.toJson());

class CreateEventResponse {
  int? statusCode;
  String? message;

  CreateEventResponse({
    this.statusCode,
    this.message,
  });

  CreateEventResponse copyWith({
    int? statusCode,
    String? message,
  }) =>
      CreateEventResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
      );

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) =>
      CreateEventResponse(
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
      };
}
