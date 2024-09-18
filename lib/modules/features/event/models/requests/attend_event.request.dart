import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/modules/global_models/requests/global_request.dart';

class AttendEventRequest extends DataRequest {
  double latitude;
  double longitude;
  String location;
  String timeZone;
  String eventId;
  String receptionistId;
  File image;

  AttendEventRequest({
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.timeZone,
    required this.eventId,
    required this.receptionistId,
    required this.image,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'time_zone': timeZone,
      'event_id': eventId,
      'receptionist_id': receptionistId,
    };
  }

  @override
  Future<FormData> toFormData() async {
    Map<String, dynamic> data = toJson();
    FormData formData = FormData.fromMap(data);
    formData.files.add(MapEntry(
      'photo',
      await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    ));
    return formData;
  }
}
