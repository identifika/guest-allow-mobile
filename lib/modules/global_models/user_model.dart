import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? faceIdentifier;
  Pivot? pivot;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.faceIdentifier,
    this.pivot,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        photo: json["photo"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        faceIdentifier: json["face_identifier"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "photo": photo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "face_identifier": faceIdentifier,
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  String? eventId;
  String? userId;

  Pivot({
    this.eventId,
    this.userId,
  });

  factory Pivot.fromRawJson(String str) => Pivot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        eventId: json["event_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "user_id": userId,
      };
}
