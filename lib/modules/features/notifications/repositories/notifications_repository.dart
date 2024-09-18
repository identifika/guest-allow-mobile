import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/notifications/models/responses/get_list_notifications_response.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class NotificationsRepository {
  Future<GetNotificationListResponse> getListNofif({
    int? page,
    int? limit,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.userNotifications,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return GetNotificationListResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      return GetNotificationListResponse(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Something went wrong!',
      );
    } catch (e) {
      return GetNotificationListResponse(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }

  Future<GeneralResponseModel> readNotif({
    required String id,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.readNotif(id),
      );

      return GeneralResponseModel.fromJson(response.data);
    } on DioException catch (dioError) {
      return GeneralResponseModel(
        statusCode: dioError.response?.statusCode ?? 400,
        message: dioError.response?.data['message'] ?? 'Something went wrong!',
      );
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 0,
        message: 'Something went wrong!',
      );
    }
  }
}
