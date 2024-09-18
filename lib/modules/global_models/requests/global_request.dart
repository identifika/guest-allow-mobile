import 'package:dio/dio.dart';

abstract class DataRequest {
  // Convert the object to a JSON map
  Map<String, dynamic> toJson();

  // Convert the object to a Form Data map (useful for HTTP requests with multipart/form-data)
  Future<FormData> toFormData();
}
