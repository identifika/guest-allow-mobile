import 'dart:convert';

import 'package:guest_allow/modules/global_models/user_model.dart';

class GetPopularEventsResponse {
  int? statusCode;
  String? message;
  PopularEventResponseMeta? meta;

  GetPopularEventsResponse({
    this.statusCode,
    this.message,
    this.meta,
  });

  factory GetPopularEventsResponse.fromRawJson(String str) =>
      GetPopularEventsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPopularEventsResponse.fromJson(Map<String, dynamic> json) =>
      GetPopularEventsResponse(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"] == null
            ? null
            : PopularEventResponseMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta?.toJson(),
      };
}

class PopularEventResponseMeta {
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
  dynamic prevPageUrl;
  int? to;
  int? total;

  PopularEventResponseMeta({
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

  factory PopularEventResponseMeta.fromRawJson(String str) =>
      PopularEventResponseMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  PopularEventResponseMeta copyWith({
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
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      PopularEventResponseMeta(
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

  factory PopularEventResponseMeta.fromJson(Map<String, dynamic> json) =>
      PopularEventResponseMeta(
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

class EventData {
  String? id;
  String? title;
  String? description;
  String? location;
  String? latitude;
  String? longitude;
  int? radius;
  int? price;
  int? visibility;
  int? type;
  String? photo;
  String? startDate;
  String? endDate;
  String? timeZone;
  String? createdById;
  String? link;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? receptionistsCount;
  int? participantsCount;
  bool? participantsExists;
  bool? receptionistsExists;
  UserModel? createdBy;
  MyArrival? myArrival;
  List<UserModel>? participants;
  List<UserModel>? receptionists;

  EventData({
    this.id,
    this.title,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.radius,
    this.price,
    this.visibility,
    this.type,
    this.photo,
    this.startDate,
    this.endDate,
    this.timeZone,
    this.createdById,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.receptionistsCount,
    this.participantsCount,
    this.participantsExists,
    this.receptionistsExists,
    this.createdBy,
    this.myArrival,
    this.participants,
    this.receptionists,
  });

  factory EventData.fromRawJson(String str) =>
      EventData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: json["radius"],
        price: json["price"],
        visibility: json["visibility"],
        type: json["type"],
        photo: json["photo"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        timeZone: json["time_zone"],
        createdById: json["created_by_id"],
        link: json["link"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        receptionistsCount: json["receptionists_count"],
        participantsCount: json["participants_count"],
        participantsExists: json["participants_exists"],
        receptionistsExists: json["receptionists_exists"],
        createdBy: json["created_by"] == null
            ? null
            : UserModel.fromJson(json["created_by"]),
        myArrival: json["my_arrival"] == null
            ? null
            : MyArrival.fromJson(json["my_arrival"]),
        participants: json["participants"] == null
            ? []
            : List<UserModel>.from(
                json["participants"]!.map((x) => UserModel.fromJson(x))),
        receptionists: json["receptionists"] == null
            ? []
            : List<UserModel>.from(
                json["receptionists"]!.map((x) => UserModel.fromJson(x))),
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
        "visibility": visibility,
        "type": type,
        "photo": photo,
        "start_date": startDate,
        "end_date": endDate,
        "time_zone": timeZone,
        "created_by_id": createdById,
        "link": link,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "receptionists_count": receptionistsCount,
        "participants_count": participantsCount,
        "participants_exists": participantsExists,
        "receptionists_exists": receptionistsExists,
        "created_by": createdBy?.toJson(),
        "my_arrival": myArrival?.toJson(),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "receptionists": receptionists == null
            ? []
            : List<dynamic>.from(receptionists!.map((x) => x.toJson())),
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

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class MyArrival {
  String? id;
  String? eventId;
  String? userId;
  String? arrivedAt;
  int? isUserConfirming;
  String? latitude;
  String? longitude;
  String? location;
  String? photo;
  String? timeZone;
  String? receptionistId;
  String? createdAt;
  String? updatedAt;

  MyArrival({
    this.id,
    this.eventId,
    this.userId,
    this.arrivedAt,
    this.isUserConfirming,
    this.latitude,
    this.longitude,
    this.location,
    this.photo,
    this.timeZone,
    this.receptionistId,
    this.createdAt,
    this.updatedAt,
  });

  MyArrival copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? arrivedAt,
    int? isUserConfirming,
    String? latitude,
    String? longitude,
    String? location,
    String? photo,
    String? timeZone,
    String? receptionistId,
    String? createdAt,
    String? updatedAt,
  }) =>
      MyArrival(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        arrivedAt: arrivedAt ?? this.arrivedAt,
        isUserConfirming: isUserConfirming ?? this.isUserConfirming,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        location: location ?? this.location,
        photo: photo ?? this.photo,
        timeZone: timeZone ?? this.timeZone,
        receptionistId: receptionistId ?? this.receptionistId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory MyArrival.fromJson(Map<String, dynamic> json) => MyArrival(
        id: json["id"],
        eventId: json["event_id"],
        userId: json["user_id"],
        arrivedAt: json["arrived_at"],
        isUserConfirming: json["is_user_confirming"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        location: json["location"],
        photo: json["photo"],
        timeZone: json["time_zone"],
        receptionistId: json["receptionist_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "user_id": userId,
        "arrived_at": arrivedAt,
        "is_user_confirming": isUserConfirming,
        "latitude": latitude,
        "longitude": longitude,
        "location": location,
        "photo": photo,
        "time_zone": timeZone,
        "receptionist_id": receptionistId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
