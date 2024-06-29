// To parse this JSON data, do
//
//     final myJoinedEventResponse = myJoinedEventResponseFromJson(jsonString);

import 'dart:convert';

import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';

MyJoinedEventResponse myJoinedEventResponseFromJson(String str) =>
    MyJoinedEventResponse.fromJson(json.decode(str));

String myJoinedEventResponseToJson(MyJoinedEventResponse data) =>
    json.encode(data.toJson());

class MyJoinedEventResponse {
  int? statusCode;
  String? message;
  MetaMyJoinedEvent? data;

  MyJoinedEventResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  MyJoinedEventResponse copyWith({
    int? statusCode,
    String? message,
    MetaMyJoinedEvent? data,
  }) =>
      MyJoinedEventResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MyJoinedEventResponse.fromJson(Map<String, dynamic> json) =>
      MyJoinedEventResponse(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["meta"] == null
            ? null
            : MetaMyJoinedEvent.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": data?.toJson(),
      };
}

class MetaMyJoinedEvent {
  int? currentPage;
  List<DatumMyEvent>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  MetaMyJoinedEvent({
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

  MetaMyJoinedEvent copyWith({
    int? currentPage,
    List<DatumMyEvent>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Link>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) =>
      MetaMyJoinedEvent(
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

  factory MetaMyJoinedEvent.fromJson(Map<String, dynamic> json) =>
      MetaMyJoinedEvent(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<DatumMyEvent>.from(
                json["data"]!.map((x) => DatumMyEvent.fromJson(x))),
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

class DatumMyEvent {
  String? id;
  String? eventId;
  String? userId;
  String? arrivedAt;
  int? isUserConfirming;
  String? createdAt;
  String? updatedAt;
  EventData? event;

  DatumMyEvent({
    this.id,
    this.eventId,
    this.userId,
    this.arrivedAt,
    this.isUserConfirming,
    this.createdAt,
    this.updatedAt,
    this.event,
  });

  DatumMyEvent copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? arrivedAt,
    int? isUserConfirming,
    String? createdAt,
    String? updatedAt,
    EventData? event,
  }) =>
      DatumMyEvent(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        arrivedAt: arrivedAt ?? this.arrivedAt,
        isUserConfirming: isUserConfirming ?? this.isUserConfirming,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        event: event ?? this.event,
      );

  factory DatumMyEvent.fromJson(Map<String, dynamic> json) => DatumMyEvent(
        id: json["id"],
        eventId: json["event_id"],
        userId: json["user_id"],
        arrivedAt: json["arrived_at"],
        isUserConfirming: json["is_user_confirming"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        event: json["event"] == null ? null : EventData.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "user_id": userId,
        "arrived_at": arrivedAt,
        "is_user_confirming": isUserConfirming,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "event": event?.toJson(),
      };
}

class Event {
  String? id;
  String? title;
  String? description;
  String? location;
  String? latitude;
  String? longitude;
  int? radius;
  int? price;
  String? photo;
  String? startDate;
  String? endDate;
  String? link;
  int? visibility;
  int? type;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Event({
    this.id,
    this.title,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.radius,
    this.price,
    this.photo,
    this.startDate,
    this.endDate,
    this.link,
    this.visibility,
    this.type,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? latitude,
    String? longitude,
    int? radius,
    int? price,
    String? photo,
    String? startDate,
    String? endDate,
    String? link,
    int? visibility,
    int? type,
    String? createdById,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) =>
      Event(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        location: location ?? this.location,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radius: radius ?? this.radius,
        price: price ?? this.price,
        photo: photo ?? this.photo,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        link: link ?? this.link,
        visibility: visibility ?? this.visibility,
        type: type ?? this.type,
        createdById: createdById ?? this.createdById,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: json["radius"],
        price: json["price"],
        photo: json["photo"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        link: json["link"],
        visibility: json["visibility"],
        type: json["type"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
        "price": price,
        "photo": photo,
        "start_date": startDate,
        "end_date": endDate,
        "link": link,
        "visibility": visibility,
        "type": type,
        "created_by_id": createdById,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
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
