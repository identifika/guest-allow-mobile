// To parse this JSON data, do
//
//     final getRegisteredUsersResponse = getRegisteredUsersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:guest_allow/modules/global_models/user_model.dart';

GetRegisteredUsersResponse getRegisteredUsersResponseFromJson(String str) =>
    GetRegisteredUsersResponse.fromJson(json.decode(str));

String getRegisteredUsersResponseToJson(GetRegisteredUsersResponse data) =>
    json.encode(data.toJson());

class GetRegisteredUsersResponse {
  int? statusCode;
  String? message;
  MetaRegisteredUsers? meta;

  GetRegisteredUsersResponse({
    this.statusCode,
    this.message,
    this.meta,
  });

  GetRegisteredUsersResponse copyWith({
    int? statusCode,
    String? message,
    MetaRegisteredUsers? meta,
  }) =>
      GetRegisteredUsersResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
      );

  factory GetRegisteredUsersResponse.fromJson(Map<String, dynamic> json) =>
      GetRegisteredUsersResponse(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"] == null
            ? null
            : MetaRegisteredUsers.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta?.toJson(),
      };
}

class MetaRegisteredUsers {
  int? currentPage;
  List<UserModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  MetaRegisteredUsers({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  MetaRegisteredUsers copyWith({
    int? currentPage,
    List<UserModel>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Link>? links,
    dynamic nextPageUrl,
    String? path,
    int? perPage,
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      MetaRegisteredUsers(
        currentPage: currentPage ?? this.currentPage,
        data: data ?? this.data,
        firstPageUrl: firstPageUrl ?? this.firstPageUrl,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
        links: links ?? this.links,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        prevPageUrl: prevPageUrl ?? this.prevPageUrl,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory MetaRegisteredUsers.fromJson(Map<String, dynamic> json) =>
      MetaRegisteredUsers(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<UserModel>.from(
                json["data"]!.map((x) => UserModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
