import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_models/requests/global_request.dart';

class CreateEventRequest extends DataRequest {
  String title;
  String description;
  String? location;
  double? latitude;
  double? longitude;
  int price;
  DateTime startDate;
  DateTime endDate;
  String? link;
  int type;
  int visibility;
  String radius;
  String timeZone;
  List<String> participants;
  List<String> receptionists;
  List<Guest>? guests;
  List<ReceptionistGuest>? receptionistGuests;
  File image;
  String? eventId;

  CreateEventRequest({
    required this.title,
    required this.description,
    this.location,
    this.latitude,
    this.longitude,
    required this.price,
    required this.startDate,
    required this.endDate,
    this.link,
    required this.type,
    required this.visibility,
    required this.radius,
    required this.timeZone,
    required this.participants,
    required this.receptionists,
    required this.image,
    this.guests,
    this.receptionistGuests,
    this.eventId,
  });

  @override
  Future<FormData> toFormData() async {
    Map<String, dynamic> data = toJson();

    FormData formData = FormData.fromMap(data);

    if (guests != null) {
      for (int i = 0; i < guests!.length; i++) {
        if (guests![i].image != null) {
          formData.files.add(MapEntry(
            'guests[$i][photo]',
            await MultipartFile.fromFile(
              guests![i].image!.path,
              filename: guests![i].image!.path.split('/').last,
            ),
          ));
        }
      }
    }

    formData.files.add(MapEntry(
      'photo',
      await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    ));

    return formData;
  }

  @override
  Map<String, dynamic> toJson() {
    // Convert to JSON structure for other uses
    return toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
      'link': link,
      'type': type,
      'visibility': visibility,
      'radius': radius,
      'time_zone': timeZone,
      'participants[]': participants,
      'receptionists[]': receptionists,
      'event_id': eventId,
    };

    if (guests != null) {
      for (int i = 0; i < guests!.length; i++) {
        data.addAll({
          'guests[$i][name]': guests![i].name,
          'guests[$i][email]': guests![i].email,
          'guests[$i][notify]': guests![i].notifiedByEmail ? 'TRUE' : 'FALSE',
        });
      }
    }

    if (receptionistGuests != null) {
      for (int i = 0; i < receptionistGuests!.length; i++) {
        data.addAll({
          'guest_receptionists[$i][name]': receptionistGuests![i].name,
          'guest_receptionists[$i][email]': receptionistGuests![i].email,
          'guest_receptionists[$i][access_code]':
              receptionistGuests![i].accessCode,
          'guest_receptionists[$i][notify]':
              guests![i].notifiedByEmail ? 'TRUE' : 'FALSE',
        });
      }
    }

    return data;
  }
}
