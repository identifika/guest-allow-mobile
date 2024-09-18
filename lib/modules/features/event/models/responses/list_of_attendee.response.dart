// To parse this JSON data, do
//
//     final listOfAttendeeResponse = listOfAttendeeResponseFromJson(jsonString);

import 'dart:convert';

ListOfAttendeeResponse listOfAttendeeResponseFromJson(String str) =>
    ListOfAttendeeResponse.fromJson(json.decode(str));

String listOfAttendeeResponseToJson(ListOfAttendeeResponse data) =>
    json.encode(data.toJson());

class ListOfAttendeeResponse {
  int? statusCode;
  String? message;
  Meta? meta;

  ListOfAttendeeResponse({
    this.statusCode,
    this.message,
    this.meta,
  });

  ListOfAttendeeResponse copyWith({
    int? statusCode,
    String? message,
    Meta? meta,
  }) =>
      ListOfAttendeeResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
      );

  factory ListOfAttendeeResponse.fromJson(Map<String, dynamic> json) =>
      ListOfAttendeeResponse(
        statusCode: json["status_code"],
        message: json["message"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "meta": meta?.toJson(),
      };
}

class Meta {
  ParticipantsMeta? participants;
  int? totalAttended;
  int? totalNotAttended;
  int? totalParticipants;
  int? totalGuestsAttended;
  int? totalGuestsNotAttended;
  int? totalGuests;

  Meta({
    this.participants,
    this.totalAttended,
    this.totalNotAttended,
    this.totalParticipants,
    this.totalGuestsAttended,
    this.totalGuestsNotAttended,
    this.totalGuests,
  });

  Meta copyWith({
    ParticipantsMeta? participants,
    int? totalAttended,
    int? totalNotAttended,
    int? totalParticipants,
    int? totalGuestsAttended,
    int? totalGuestsNotAttended,
    int? totalGuests,
  }) =>
      Meta(
        participants: participants ?? this.participants,
        totalAttended: totalAttended ?? this.totalAttended,
        totalNotAttended: totalNotAttended ?? this.totalNotAttended,
        totalParticipants: totalParticipants ?? this.totalParticipants,
        totalGuestsAttended: totalGuestsAttended ?? this.totalGuestsAttended,
        totalGuestsNotAttended:
            totalGuestsNotAttended ?? this.totalGuestsNotAttended,
        totalGuests: totalGuests ?? this.totalGuests,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        participants: json["merged"] == null
            ? null
            : ParticipantsMeta.fromJson(json["merged"]),
        totalAttended: json["total_attended"],
        totalNotAttended: json["total_not_attended"],
        totalParticipants: json["total_participants"],
        totalGuestsAttended: json["total_guests_attended"],
        totalGuestsNotAttended: json["total_guests_not_attended"],
        totalGuests: json["total_guests"],
      );

  Map<String, dynamic> toJson() => {
        "merged": participants?.toJson(),
        "total_attended": totalAttended,
        "total_not_attended": totalNotAttended,
        "total_participants": totalParticipants,
        "total_guests_attended": totalGuestsAttended,
        "total_guests_not_attended": totalGuestsNotAttended,
        "total_guests": totalGuests,
      };
}

class ParticipantsMeta {
  List<ParticipantData>? data;
  MergedMeta? meta;

  ParticipantsMeta({
    this.data,
    this.meta,
  });

  ParticipantsMeta copyWith({
    List<ParticipantData>? data,
    MergedMeta? meta,
  }) =>
      ParticipantsMeta(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory ParticipantsMeta.fromJson(Map<String, dynamic> json) =>
      ParticipantsMeta(
        data: json["data"] == null
            ? []
            : List<ParticipantData>.from(
                json["data"]!.map((x) => ParticipantData.fromJson(x))),
        meta: json["meta"] == null ? null : MergedMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class MergedMeta {
  int? total;
  int? currentPage;
  int? lastPage;
  int? perPage;

  MergedMeta({
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
  });

  MergedMeta copyWith({
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) =>
      MergedMeta(
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
      );

  factory MergedMeta.fromJson(Map<String, dynamic> json) => MergedMeta(
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

class ParticipantData {
  String? id;
  String? eventId;
  String? userId;
  String? arrivedAt;
  int? isUserConfirming;
  bool? isGuest;
  String? latitude;
  String? longitude;
  String? location;
  String? photo;
  String? timeZone;
  String? receptionistId;
  String? createdAt;
  String? updatedAt;
  User? user;

  ParticipantData({
    this.id,
    this.eventId,
    this.userId,
    this.arrivedAt,
    this.isUserConfirming,
    this.isGuest,
    this.latitude,
    this.longitude,
    this.location,
    this.photo,
    this.timeZone,
    this.receptionistId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  ParticipantData copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? arrivedAt,
    int? isUserConfirming,
    bool? isGuest,
    String? latitude,
    String? longitude,
    String? location,
    String? photo,
    String? timeZone,
    String? receptionistId,
    String? createdAt,
    String? updatedAt,
    User? user,
  }) =>
      ParticipantData(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        arrivedAt: arrivedAt ?? this.arrivedAt,
        isUserConfirming: isUserConfirming ?? this.isUserConfirming,
        isGuest: isGuest ?? this.isGuest,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        location: location ?? this.location,
        photo: photo ?? this.photo,
        timeZone: timeZone ?? this.timeZone,
        receptionistId: receptionistId ?? this.receptionistId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory ParticipantData.fromJson(Map<String, dynamic> json) =>
      ParticipantData(
        id: json["id"],
        eventId: json["event_id"],
        userId: json["user_id"],
        arrivedAt: json["arrived_at"],
        isUserConfirming: json["is_user_confirming"],
        isGuest: json["user_id"] == null,
        latitude: json["latitude"],
        longitude: json["longitude"],
        location: json["location"],
        photo: json["photo"],
        timeZone: json["time_zone"],
        receptionistId: json["receptionist_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "user_id": userId,
        "arrived_at": arrivedAt,
        "is_user_confirming": isUserConfirming,
        'is_guest': isGuest,
        "latitude": latitude,
        "longitude": longitude,
        "location": location,
        "photo": photo,
        "time_zone": timeZone,
        "receptionist_id": receptionistId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user?.toJson(),
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
