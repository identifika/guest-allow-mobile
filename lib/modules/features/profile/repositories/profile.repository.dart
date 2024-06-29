import 'package:dio/dio.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/profile/models/responses/get_my_event_response.dart';
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
}
