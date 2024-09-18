import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/responses/sign_in.response.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_up/models/responses/register_response.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/utils/helpers/dio_error.helper.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class AuthRepository {
  Future<SignInResponse> signIn(
    String email,
    String password, {
    String? fcmToken,
  }) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        if (fcmToken != null) 'fcm_token': fcmToken,
      };
      var response = await ApiServices.call().post(
        EndpointConstant.login,
        data: body,
      );

      return SignInResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return SignInResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return SignInResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return SignInResponse(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }

  Future<GeneralResponseModel> logout() async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.logout,
      );

      return GeneralResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel.fromJson(dioError.response?.data);
      } catch (e) {
        return GeneralResponseModel(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }

  Future<RegisterResponse> signUp({
    required String name,
    required String email,
    required String password,
    required String timezone,
    required String passwordConfirmation,
  }) async {
    try {
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'password': password,
        'timezone': timezone,
        'password_confirmation': passwordConfirmation,
      };
      var response = await ApiServices.call().post(
        EndpointConstant.register,
        data: body,
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return RegisterResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return RegisterResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return RegisterResponse(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }

  Future<GeneralResponseModel> forgotPassword({
    required String email,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'email': email,
      });
      var response = await ApiServices.call().post(
        EndpointConstant.forgotPassword,
        data: formData,
      );

      return GeneralResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel.fromJson(dioError.response?.data);
      } catch (e) {
        return GeneralResponseModel(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }
}
