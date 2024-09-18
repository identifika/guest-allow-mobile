import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/profile/models/responses/get_my_event_response.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class ProfileRepository {
  Future<ListOfMyEventsResponse> getMyEvents({
    int? page,
    int? limit,
    String? type,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.getMyEvents,
        queryParameters: {
          'page': page,
          'limit': limit,
          'selected_menu': type,
        },
      );

      return ListOfMyEventsResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      return ListOfMyEventsResponse(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return ListOfMyEventsResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GeneralResponseModel<UserModel>> updateUser({
    File? image,
    String? name,
    String? timezone,
  }) async {
    try {
      Map<String, dynamic> data = {
        if (name != null) 'name': name,
        if (timezone != null) 'timezone': timezone,
      };
      if (image != null) {
        data['photo'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(data);

      var response = await ApiServices.call().post(
        EndpointConstant.userUpdate,
        data: formData,
      );

      return GeneralResponseModel<UserModel>.fromJson(
        response.data,
        fromJsonT: (data) => UserModel.fromJson(data),
      );
    } on DioException catch (dioError) {
      return GeneralResponseModel<UserModel>(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Something went wrong!',
      );
    } catch (e) {
      log(e.toString());
      return GeneralResponseModel<UserModel>(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }
}
