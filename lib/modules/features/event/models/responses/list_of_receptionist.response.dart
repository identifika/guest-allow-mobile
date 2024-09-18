// To parse this JSON data, do
//
//     final listOfReceptionistResponse = listOfReceptionistResponseFromJson(jsonString);

import 'dart:convert';

ListOfReceptionistResponse listOfReceptionistResponseFromJson(String str) =>
    ListOfReceptionistResponse.fromJson(json.decode(str));

String listOfReceptionistResponseToJson(ListOfReceptionistResponse data) =>
    json.encode(data.toJson());

class ListOfReceptionistResponse {
  int? statusCode;
  String? message;
  ListOfReceptionistResponseMeta? meta;

  ListOfReceptionistResponse({
    this.statusCode,
    this.message,
    this.meta,
  });

  ListOfReceptionistResponse copyWith({
    int? statusCode,
    String? message,
    ListOfReceptionistResponseMeta? meta,
  }) =>
      ListOfReceptionistResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
      );

  factory ListOfReceptionistResponse.fromJson(Map<String, dynamic> json) =>
      ListOfReceptionistResponse(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"] == null
            ? null
            : ListOfReceptionistResponseMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta?.toJson(),
      };
}

class ListOfReceptionistResponseMeta {
  ReceptionistMerged? merged;
  int? totalGuests;
  int? totalReceptionists;

  ListOfReceptionistResponseMeta({
    this.merged,
    this.totalGuests,
    this.totalReceptionists,
  });

  ListOfReceptionistResponseMeta copyWith({
    ReceptionistMerged? merged,
    int? totalGuests,
    int? totalReceptionists,
  }) =>
      ListOfReceptionistResponseMeta(
        merged: merged ?? this.merged,
        totalGuests: totalGuests ?? this.totalGuests,
        totalReceptionists: totalReceptionists ?? this.totalReceptionists,
      );

  factory ListOfReceptionistResponseMeta.fromJson(Map<String, dynamic> json) =>
      ListOfReceptionistResponseMeta(
        merged: json["merged"] == null
            ? null
            : ReceptionistMerged.fromJson(json["merged"]),
        totalGuests: json["total_guests"],
        totalReceptionists: json["total_receptionists"],
      );

  Map<String, dynamic> toJson() => {
        "merged": merged?.toJson(),
        "total_guests": totalGuests,
        "total_receptionists": totalReceptionists,
      };
}

class ReceptionistMerged {
  List<Datum>? data;
  ReceptionistMergedMeta? meta;

  ReceptionistMerged({
    this.data,
    this.meta,
  });

  ReceptionistMerged copyWith({
    List<Datum>? data,
    ReceptionistMergedMeta? meta,
  }) =>
      ReceptionistMerged(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory ReceptionistMerged.fromJson(Map<String, dynamic> json) =>
      ReceptionistMerged(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null
            ? null
            : ReceptionistMergedMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Datum {
  String? id;
  String? eventId;
  String? userId;
  dynamic createdAt;
  dynamic updatedAt;
  User? user;
  bool? isGuest;
  dynamic arrivedAt;
  dynamic timeZone;
  dynamic latitude;
  dynamic longitude;
  dynamic location;
  dynamic receptionistId;
  dynamic photo;

  Datum({
    this.id,
    this.eventId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.isGuest,
    this.arrivedAt,
    this.timeZone,
    this.latitude,
    this.longitude,
    this.location,
    this.receptionistId,
    this.photo,
  });

  Datum copyWith({
    String? id,
    String? eventId,
    String? userId,
    dynamic createdAt,
    dynamic updatedAt,
    User? user,
    bool? isGuest,
    dynamic arrivedAt,
    dynamic timeZone,
    dynamic latitude,
    dynamic longitude,
    dynamic location,
    dynamic receptionistId,
    dynamic photo,
  }) =>
      Datum(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        isGuest: isGuest ?? this.isGuest,
        arrivedAt: arrivedAt ?? this.arrivedAt,
        timeZone: timeZone ?? this.timeZone,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        location: location ?? this.location,
        receptionistId: receptionistId ?? this.receptionistId,
        photo: photo ?? this.photo,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        eventId: json["event_id"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isGuest: json["user_id"] == null,
        arrivedAt: json["arrived_at"],
        timeZone: json["time_zone"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        location: json["location"],
        receptionistId: json["receptionist_id"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user?.toJson(),
        'is_guest': isGuest,
        "arrived_at": arrivedAt,
        "time_zone": timeZone,
        "latitude": latitude,
        "longitude": longitude,
        "location": location,
        "receptionist_id": receptionistId,
        "photo": photo,
      };
}

class User {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? photo;
  String? faceIdentifier;
  String? timezone;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.photo,
    this.faceIdentifier,
    this.timezone,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
    String? photo,
    String? faceIdentifier,
    String? timezone,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        photo: photo ?? this.photo,
        faceIdentifier: faceIdentifier ?? this.faceIdentifier,
        timezone: timezone ?? this.timezone,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        photo: json["photo"],
        faceIdentifier: json["face_identifier"],
        timezone: json["timezone"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "photo": photo,
        "face_identifier": faceIdentifier,
        "timezone": timezone,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ReceptionistMergedMeta {
  dynamic total;
  dynamic currentPage;
  dynamic lastPage;
  dynamic perPage;

  ReceptionistMergedMeta({
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
  });

  ReceptionistMergedMeta copyWith({
    dynamic total,
    dynamic currentPage,
    dynamic lastPage,
    dynamic perPage,
  }) =>
      ReceptionistMergedMeta(
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
      );

  factory ReceptionistMergedMeta.fromJson(Map<String, dynamic> json) =>
      ReceptionistMergedMeta(
        total: json["total"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
      };
}
