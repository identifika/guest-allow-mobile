import 'dart:convert';

import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';
import 'package:timezone/timezone.dart' as tz;

class EventModel {
  EventModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.location,
    required this.description,
    required this.price,
    required this.isOnline,
    required this.isImported,
    this.link,
    this.participants,
    this.totalParticipant,
  });

  String id;
  String title;
  String image;
  String date;
  String location;
  String description;
  num price;
  bool isOnline;
  bool isImported;
  String? link;
  List<UserModel>? participants;
  int? totalParticipant;

  factory EventModel.fromRawJson(String str) =>
      EventModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        date: json["date"],
        location: json["location"],
        description: json["description"],
        price: json["price"],
        participants: json["participants"] == null
            ? null
            : List<UserModel>.from(
                json["participants"].map((x) => UserModel.fromJson(x))),
        isOnline: json["is_online"] != null ? json['is_online'] == 0 : false,
        isImported:
            json["is_imported"] != null ? json['is_imported'] == 0 : false,
        link: json["link"],
        totalParticipant: json["total_participant"],
      );

  factory EventModel.fromEventData(EventData? data) => EventModel(
        id: data?.id ?? '',
        title: data?.title ?? '',
        description: data?.description ?? '',
        image: data?.photo ?? '',
        date: tz.TZDateTime.from(
                DateTime.tryParse(data?.startDate ?? '') ?? DateTime.now(),
                tz.getLocation(data?.timeZone ?? ''))
            .toLocal()
            .toDayMonth(),
        location: data?.location ?? '',
        price: data?.price ?? 0,
        participants: data?.participants,
        totalParticipant: data?.participantsCount,
        isOnline: data?.type == 0,
        isImported: data?.isImported == 1,
        link: data?.link,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "date": date,
        "location": location,
        "description": description,
        "price": price,
        "participants": participants == null
            ? null
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "is_online": isOnline ? 1 : 0,
        "is_imported": isImported ? 1 : 0,
        "link": link,
        "total_participant": totalParticipant,
      };
}
