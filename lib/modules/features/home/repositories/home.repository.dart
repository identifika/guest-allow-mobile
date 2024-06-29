import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/utils/helpers/dio_error.helper.dart';
import 'package:guest_allow/utils/services/api.service.dart';

class HomeRepository {
  Future<GetPopularEventsResponse> getPopularEvent({
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
        EndpointConstant.getPopularEvent,
        queryParameters: {
          'page': page,
          'limit': limit,
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
}
