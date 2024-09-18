import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/modules/global_models/requests/global_request.dart';
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
  String? uniqueCode;
  String? identifikaEventId;
  int? radius;
  int? price;
  int? visibility;
  int? type;
  int? isImported;
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
  List<ReceptionistGuest>? receptionistGuests;
  List<Guest>? guests;

  EventData({
    this.id,
    this.title,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.uniqueCode,
    this.identifikaEventId,
    this.radius,
    this.price,
    this.visibility,
    this.type,
    this.isImported,
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
    this.receptionistGuests,
    this.guests,
  });

  factory EventData.fromRawJson(String str) =>
      EventData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  EventData copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? latitude,
    String? longitude,
    String? uniqueCode,
    String? identifikaEventId,
    int? radius,
    int? price,
    int? visibility,
    int? type,
    int? isImported,
    String? photo,
    String? startDate,
    String? endDate,
    String? timeZone,
    String? createdById,
    String? link,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    int? receptionistsCount,
    int? participantsCount,
    bool? participantsExists,
    bool? receptionistsExists,
    UserModel? createdBy,
    MyArrival? myArrival,
    List<UserModel>? participants,
    List<UserModel>? receptionists,
    List<ReceptionistGuest>? receptionistGuests,
    List<Guest>? guests,
  }) {
    return EventData(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      identifikaEventId: identifikaEventId ?? this.identifikaEventId,
      radius: radius ?? this.radius,
      price: price ?? this.price,
      visibility: visibility ?? this.visibility,
      type: type ?? this.type,
      isImported: isImported ?? this.isImported,
      photo: photo ?? this.photo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timeZone: timeZone ?? this.timeZone,
      createdById: createdById ?? this.createdById,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      receptionistsCount: receptionistsCount ?? this.receptionistsCount,
      participantsCount: participantsCount ?? this.participantsCount,
      participantsExists: participantsExists ?? this.participantsExists,
      receptionistsExists: receptionistsExists ?? this.receptionistsExists,
      createdBy: createdBy ?? this.createdBy,
      myArrival: myArrival ?? this.myArrival,
      participants: participants ?? this.participants,
      receptionists: receptionists ?? this.receptionists,
      receptionistGuests: receptionistGuests,
      guests: guests,
    );
  }

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        uniqueCode: json["unique_code"],
        identifikaEventId: json["identifika_event_id"],
        radius: json["radius"],
        price: json["price"],
        visibility: json["visibility"],
        type: json["type"],
        isImported: json["is_imported"],
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
        receptionistGuests: json["receptionist_guests"] == null
            ? []
            : List<ReceptionistGuest>.from(json["receptionist_guests"]
                .map((x) => ReceptionistGuest.fromJson(x))),
        guests: json["guests"] == null
            ? []
            : List<Guest>.from(json["guests"].map((x) => Guest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "unique_code": uniqueCode,
        "identifika_event_id": identifikaEventId,
        "radius": radius,
        "price": price,
        "visibility": visibility,
        "type": type,
        "is_imported": isImported,
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
        "receptionist_guests": receptionistGuests == null
            ? []
            : List<dynamic>.from(receptionistGuests!.map((x) => x.toJson())),
        "guests": guests == null
            ? []
            : List<dynamic>.from(guests!.map((x) => x.toJson())),
      };
}

class ReceptionistGuest {
  String? id;
  String? name;
  String? email;
  String? eventId;
  String? accessCode;
  String? createdAt;
  String? updatedAt;
  bool notifiedByEmail;

  ReceptionistGuest({
    this.id,
    this.name,
    this.email,
    this.eventId,
    this.accessCode,
    this.createdAt,
    this.updatedAt,
    this.notifiedByEmail = false,
  });

  ReceptionistGuest copyWith({
    String? id,
    String? name,
    String? email,
    String? eventId,
    String? accessCode,
    String? createdAt,
    String? updatedAt,
    bool? notifiedByEmail,
  }) =>
      ReceptionistGuest(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        eventId: eventId ?? this.eventId,
        accessCode: accessCode ?? this.accessCode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        notifiedByEmail: notifiedByEmail ?? this.notifiedByEmail,
      );

  factory ReceptionistGuest.fromJson(Map<String, dynamic> json) =>
      ReceptionistGuest(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        eventId: json["event_id"],
        accessCode: json["access_code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "event_id": eventId,
        "access_code": accessCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
        'send_email': notifiedByEmail,
      };
}

class Guest extends DataRequest {
  String? id;
  String? eventId;
  String? name;
  String? email;
  String? faceIdentifier;
  String? profilePhoto;
  String? latitude;
  String? longitude;
  String? location;
  String? photo;
  String? timeZone;
  String? receptionistId;
  String? arrivedAt;
  String? createdAt;
  String? updatedAt;
  File? image;
  bool notifiedByEmail;

  Guest({
    this.id,
    this.eventId,
    this.name,
    this.email,
    this.faceIdentifier,
    this.profilePhoto,
    this.latitude,
    this.longitude,
    this.location,
    this.photo,
    this.timeZone,
    this.receptionistId,
    this.arrivedAt,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.notifiedByEmail = false,
  });

  Guest copyWith({
    String? id,
    String? eventId,
    String? name,
    String? email,
    String? faceIdentifier,
    String? profilePhoto,
    String? latitude,
    String? longitude,
    String? location,
    String? photo,
    String? timeZone,
    String? receptionistId,
    String? arrivedAt,
    String? createdAt,
    String? updatedAt,
    File? image,
    bool? notifiedByEmail,
  }) =>
      Guest(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
        email: email ?? this.email,
        faceIdentifier: faceIdentifier ?? this.faceIdentifier,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        location: location ?? this.location,
        photo: photo ?? this.photo,
        timeZone: timeZone ?? this.timeZone,
        receptionistId: receptionistId ?? this.receptionistId,
        arrivedAt: arrivedAt ?? this.arrivedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        image: image ?? this.image,
        notifiedByEmail: notifiedByEmail ?? this.notifiedByEmail,
      );

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        id: json["id"],
        eventId: json["event_id"],
        name: json["name"],
        email: json["email"],
        faceIdentifier: json["face_identifier"],
        profilePhoto: json["profile_photo"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        location: json["location"],
        photo: json["photo"],
        timeZone: json["time_zone"],
        receptionistId: json["receptionist_id"],
        arrivedAt: json["arrived_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "name": name,
        "email": email,
        "face_identifier": faceIdentifier,
        "profile_photo": profilePhoto,
        "latitude": latitude,
        "longitude": longitude,
        "location": location,
        "photo": photo,
        "time_zone": timeZone,
        "receptionist_id": receptionistId,
        "arrived_at": arrivedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        'send_email': notifiedByEmail,
      };

  @override
  Future<FormData> toFormData() async {
    Map<String, dynamic> data = toJson();
    FormData formData = FormData.fromMap(data);
    if (image != null) {
      formData.files.add(MapEntry(
        'photo',
        await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
      ));
    }
    return formData;
  }
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
