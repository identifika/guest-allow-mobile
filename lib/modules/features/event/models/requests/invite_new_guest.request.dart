import 'dart:io';

import 'package:guest_allow/modules/global_models/requests/global_request.dart';
import 'package:dio/dio.dart';

class InviteNewGuestRequest extends DataRequest {
  String name;
  String email;
  File file;
  String eventId;
  bool sendEmail;

  InviteNewGuestRequest({
    required this.name,
    required this.email,
    required this.file,
    required this.eventId,
    this.sendEmail = false,
  });

  @override
  Future<FormData> toFormData() async {
    Map<String, dynamic> data = toJson();
    data['photo'] = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    );

    FormData formData = FormData.fromMap(data);
    return formData;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'send_email': sendEmail,
    };
  }
}
