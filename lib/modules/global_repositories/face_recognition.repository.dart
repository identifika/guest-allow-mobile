import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class FaceRecognitionRepository {
  Future<GeneralResponseModel> enrollFace({
    required File image,
  }) async {
    try {
      Map<String, dynamic> body = {
        'photo': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      };

      FormData formData = FormData.fromMap(body);

      var response = await ApiServices.call().post(
        EndpointConstant.userFace,
        data: formData,
      );

      response.data['meta'] = response.data['data'] ?? {};

      return GeneralResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      return GeneralResponseModel(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }
}
