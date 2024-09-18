import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/constants/cores/environtment_constant.dart';
import 'package:guest_allow/modules/global_models/responses/face_recognition/face_recognition.response.dart';
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

  Future<FaceRecognitionResponse> recognizeFace({
    required File image,
    String? subEventId,
  }) async {
    try {
      String baseUrl = '${EndpointConstant.faceBaseUrl}face_recognition';
      String apiKey = EnvirontmentConstant.IDENTIFIKA_API_KEY;

      Dio dio = Dio();
      dio.options.headers['e-face-api-key'] = apiKey;

      var response = await dio.post(
        baseUrl,
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
          'sub_client_id': subEventId,
        }),
      );

      return FaceRecognitionResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      log('Error in recognizeFace: ${dioError.response?.data}');
      return FaceRecognitionResponse(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      log('Error in recognizeFace: $e');
      return FaceRecognitionResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }
}
