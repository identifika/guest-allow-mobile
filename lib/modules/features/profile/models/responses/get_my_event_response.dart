// To parse this JSON data, do
//
//     final listOfMyEventsResponse = listOfMyEventsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';

ListOfMyEventsResponse listOfMyEventsResponseFromJson(String str) =>
    ListOfMyEventsResponse.fromJson(json.decode(str));

String listOfMyEventsResponseToJson(ListOfMyEventsResponse data) =>
    json.encode(data.toJson());

class ListOfMyEventsResponse {
  int? statusCode;
  String? message;
  MetaOfListMyEventResponse? meta;
  Totals? totals;

  ListOfMyEventsResponse({
    this.statusCode,
    this.message,
    this.meta,
    this.totals,
  });

  ListOfMyEventsResponse copyWith({
    int? statusCode,
    String? message,
    MetaOfListMyEventResponse? meta,
    Totals? totals,
  }) =>
      ListOfMyEventsResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
        totals: totals ?? this.totals,
      );

  factory ListOfMyEventsResponse.fromJson(Map<String, dynamic> json) =>
      ListOfMyEventsResponse(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"] == null
            ? null
            : MetaOfListMyEventResponse.fromJson(json["meta"]),
        totals: json["totals"] == null ? null : Totals.fromJson(json["totals"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta?.toJson(),
        "totals": totals?.toJson(),
      };
}

class MetaOfListMyEventResponse {
  int? currentPage;
  List<EventData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  MetaOfListMyEventResponse({
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

  MetaOfListMyEventResponse copyWith({
    int? currentPage,
    List<EventData>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Link>? links,
    dynamic nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) =>
      MetaOfListMyEventResponse(
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

  factory MetaOfListMyEventResponse.fromJson(Map<String, dynamic> json) =>
      MetaOfListMyEventResponse(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<EventData>.from(
                json["data"]!.map((x) => EventData.fromJson(x))),
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

class Totals {
  int? mine;
  int? joined;
  int? receptionist;

  Totals({
    this.mine,
    this.joined,
    this.receptionist,
  });

  Totals copyWith({
    int? mine,
    int? joined,
    int? receptionist,
  }) =>
      Totals(
        mine: mine ?? this.mine,
        joined: joined ?? this.joined,
        receptionist: receptionist ?? this.receptionist,
      );

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        mine: json["mine"],
        joined: json["joined"],
        receptionist: json["receptionist"],
      );

  Map<String, dynamic> toJson() => {
        "mine": mine,
        "joined": joined,
        "receptionist": receptionist,
      };
}
