// To parse this JSON data, do
//
//     final eventDetailResponse = eventDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';

EventDetailResponse eventDetailResponseFromJson(String str) =>
    EventDetailResponse.fromJson(json.decode(str));

String eventDetailResponseToJson(EventDetailResponse data) =>
    json.encode(data.toJson());

class EventDetailResponse {
  int? statusCode;
  String? message;
  EventData? data;

  EventDetailResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EventDetailResponse.fromJson(Map<String, dynamic> json) =>
      EventDetailResponse(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : EventData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}
