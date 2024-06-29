// To parse this JSON data, do
//
//     final eachDateTotalEventResponse = eachDateTotalEventResponseFromJson(jsonString);

import 'dart:convert';

EachDateTotalEventResponse eachDateTotalEventResponseFromJson(String str) =>
    EachDateTotalEventResponse.fromJson(json.decode(str));

String eachDateTotalEventResponseToJson(EachDateTotalEventResponse data) =>
    json.encode(data.toJson());

class EachDateTotalEventResponse {
  int? statusCode;
  String? message;
  List<DatumEventTotal>? data;

  EachDateTotalEventResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  EachDateTotalEventResponse copyWith({
    int? statusCode,
    String? message,
    List<DatumEventTotal>? data,
  }) =>
      EachDateTotalEventResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory EachDateTotalEventResponse.fromJson(Map<String, dynamic> json) =>
      EachDateTotalEventResponse(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DatumEventTotal>.from(
                json["data"]!.map((x) => DatumEventTotal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumEventTotal {
  DateTime? date;
  int? total;

  DatumEventTotal({
    this.date,
    this.total,
  });

  DatumEventTotal copyWith({
    DateTime? date,
    int? total,
  }) =>
      DatumEventTotal(
        date: date ?? this.date,
        total: total ?? this.total,
      );

  factory DatumEventTotal.fromJson(Map<String, dynamic> json) =>
      DatumEventTotal(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "total": total,
      };
}
