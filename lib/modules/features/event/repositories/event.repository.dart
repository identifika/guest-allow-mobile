import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/event/models/responses/create_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/each_date_total_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/event_detail.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/get_registered_users_response.dart';
import 'package:guest_allow/modules/features/event/models/responses/my_joined_event.response.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/utils/helpers/dio_error.helper.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class EventRepository {
  Future<EventDetailResponse> getEventDetail(String id) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.eventDetail(id),
      );

      return EventDetailResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return EventDetailResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return EventDetailResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return EventDetailResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GeneralResponseModel> joinEvent(String id) async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.joinEvent(id),
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
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GeneralResponseModel> cancelJoinEvent(String id) async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.leaveEvent(id),
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
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GetPopularEventsResponse> getThisMonthEvent({
    int? page,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    Position? userPosition,
    int? maxDistance,
    String? keyword,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.event,
        queryParameters: {
          'page': page ?? 1,
          'limit': limit ?? 5,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (userPosition != null) 'latitude': userPosition.latitude,
          if (userPosition != null) 'longitude': userPosition.longitude,
          if (maxDistance != null) 'max_distance': maxDistance,
          if (keyword != null) 'keyword': keyword,
        },
      );

      return GetPopularEventsResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return GetPopularEventsResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return GetPopularEventsResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GetPopularEventsResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GetRegisteredUsersResponse> getRegisteredUsers({
    int? page,
    int? limit,
    String? keyword,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.getRegisteredUsers,
        queryParameters: {
          'page': page ?? 1,
          'limit': limit ?? 5,
          if (keyword != null) 'keyword': keyword,
        },
      );

      return GetRegisteredUsersResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return GetRegisteredUsersResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return GetRegisteredUsersResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GetRegisteredUsersResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<CreateEventResponse> createEvent({
    required Map<String, dynamic> data,
    File? image,
  }) async {
    try {
      var newData = data;
      if (image != null) {
        newData['photo'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(newData);

      var response = await ApiServices.call().post(
        EndpointConstant.event,
        data: formData,
      );

      return CreateEventResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return CreateEventResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return CreateEventResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return CreateEventResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<MyJoinedEventResponse> getMyJoinedEvent({
    int? page,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    bool? isReceptionist,
  }) async {
    try {
      var response = await ApiServices.call().get(
        isReceptionist ?? false
            ? EndpointConstant.userReceptionist
            : EndpointConstant.userParticipating,
        queryParameters: {
          'page': page ?? 1,
          'limit': limit ?? 5,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
      );

      return MyJoinedEventResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return MyJoinedEventResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return MyJoinedEventResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return MyJoinedEventResponse(
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  Future<EachDateTotalEventResponse> getEachDateTotalEvent({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.eachDateTotalEvent,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      return EachDateTotalEventResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return EachDateTotalEventResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return EachDateTotalEventResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return EachDateTotalEventResponse(
        statusCode: 0,
        message: 'Terjadi kesalahan',
      );
    }
  }
}
