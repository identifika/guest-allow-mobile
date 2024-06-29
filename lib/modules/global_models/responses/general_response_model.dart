// To parse this JSON data, do
//
//     final generalResponseModel = generalResponseModelFromJson(jsonString);

import 'dart:convert';

GeneralResponseModel generalResponseModelFromJson(String str) =>
    GeneralResponseModel.fromJson(json.decode(str));

String generalResponseModelToJson(GeneralResponseModel data) =>
    json.encode(data.toJson());

class GeneralResponseModel<T extends Object> {
  int? statusCode;
  String? message;
  T? meta;

  GeneralResponseModel({
    this.statusCode,
    this.message,
    this.meta,
  });

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) =>
      GeneralResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta,
      };
}
