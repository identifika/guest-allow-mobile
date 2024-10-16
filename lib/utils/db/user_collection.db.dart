import 'package:isar/isar.dart';

part 'user_collection.db.g.dart';

@collection
class UserLocalData {
  Id id;
  String? userId;
  String? token;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? faceIdentifier;
  String? fcmToken;

  UserLocalData({
    this.id = Isar.autoIncrement,
    this.userId,
    this.token,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.faceIdentifier,
    this.fcmToken,
  });
}
