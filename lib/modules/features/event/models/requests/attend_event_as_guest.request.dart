import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/modules/global_models/requests/global_request.dart';

class AttendEventAsGuestRequest extends DataRequest {
  double latitude;
  double longitude;
  String location;
  String timeZone;
  String faceIdentifier;
  String eventId;
  File image;

  AttendEventAsGuestRequest({
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.timeZone,
    required this.faceIdentifier,
    required this.eventId,
    required this.image,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'time_zone': timeZone,
      'face_identifier': faceIdentifier,
    };
  }

  @override
  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'time_zone': timeZone,
      'face_identifier': faceIdentifier,
    });
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
