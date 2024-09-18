import 'package:guest_allow/modules/global_models/requests/global_request.dart';
import 'package:dio/dio.dart';

class InviteNewReceptionistGuestRequest extends DataRequest {
  String name;
  String email;
  String eventId;
  String? accessCode;
  bool sendEmail;

  InviteNewReceptionistGuestRequest({
    required this.name,
    required this.email,
    required this.eventId,
    this.accessCode,
    this.sendEmail = false,
  });

  @override
  Future<FormData> toFormData() async {
    Map<String, dynamic> data = toJson();
    FormData formData = FormData.fromMap(data);
    return formData;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'access_code': accessCode,
      'send_email': sendEmail,
    };
  }
}
