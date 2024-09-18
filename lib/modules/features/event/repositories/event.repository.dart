import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/responses/receptionist_guest.response.dart';
import 'package:guest_allow/modules/features/event/models/requests/attend_event.request.dart';
import 'package:guest_allow/modules/features/event/models/requests/attend_event_as_guest.request.dart';
import 'package:guest_allow/modules/features/event/models/requests/create_event.request.dart';
import 'package:guest_allow/modules/features/event/models/requests/invite_new_guest.request.dart';
import 'package:guest_allow/modules/features/event/models/requests/invite_new_receptionist_guest.request.dart';
import 'package:guest_allow/modules/features/event/models/responses/create_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/each_date_total_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/event_detail.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/get_registered_users_response.dart';
import 'package:guest_allow/modules/features/event/models/responses/list_of_attendee.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/list_of_receptionist.response.dart';
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
      log(e.toString());
      return EventDetailResponse(
        statusCode: 0,
        message: 'Something went wrong',
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
        message: 'Something went wrong',
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
        message: 'Something went wrong',
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
        message: 'Something went wrong',
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
        message: 'Something went wrong',
      );
    }
  }

  Future<CreateEventResponse> createEvent({
    required CreateEventRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();

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
        message: 'Something went wrong',
      );
    }
  }

  Future<CreateEventResponse> editEvent({
    required String id,
    required CreateEventRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();

      var response = await ApiServices.call().post(
        EndpointConstant.editEvent(id),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<MyJoinedEventResponse> getMyJoinedEvent({
    int? page,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    bool? isReceptionist,
    String? keyword,
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
          if (keyword != null) 'keyword': keyword,
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> attendEvent({
    required AttendEventRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();

      var response = await ApiServices.call().post(
        EndpointConstant.attendEvent(data.eventId),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> receiveAttende({
    required String id,
    required Map<String, dynamic> data,
    File? image,
    String? receptionistId,
  }) async {
    try {
      var newData = data;
      if (image != null) {
        newData['photo'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      if (receptionistId != null) {
        newData['receptionist_id'] = receptionistId;
      }

      FormData formData = FormData.fromMap(newData);

      var response = await ApiServices.call().post(
        EndpointConstant.receiveAttende(id),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> receiveAttendeAsReceptionistGuest({
    required String id,
    required Map<String, dynamic> data,
    File? image,
    String? receptionistId,
  }) async {
    try {
      var newData = data;
      if (image != null) {
        newData['photo'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      if (receptionistId != null) {
        newData['receptionist_id'] = receptionistId;
      }

      FormData formData = FormData.fromMap(newData);

      var response = await ApiServices.call().post(
        EndpointConstant.receiveGuest(id),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> attendEventAsGuest({
    required AttendEventAsGuestRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();

      var response = await ApiServices.call().post(
        EndpointConstant.guestAttendEvent(data.eventId),
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
      log('e: $e');
      return GeneralResponseModel(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel<EventData>> importEvent({
    required File file,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      var response = await ApiServices.call().post(
        EndpointConstant.eventImport,
        data: formData,
      );

      return GeneralResponseModel<EventData>.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel<EventData>.fromJson(
            dioError.response?.data);
      } catch (e) {
        return GeneralResponseModel<EventData>(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GeneralResponseModel<EventData>(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<ListOfAttendeeResponse> getEventParticipants({
    required String id,
    String? status,
    int? page,
    int? limit,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.getEventParticipants(id),
        queryParameters: {
          'page': page ?? 1,
          'limit': limit ?? 5,
          if (status != null) 'status': status,
        },
      );

      return ListOfAttendeeResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return ListOfAttendeeResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return ListOfAttendeeResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return ListOfAttendeeResponse(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<ListOfReceptionistResponse> getEventReceptionists({
    required String id,
    int? page,
    int? limit,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.getEventReceptionists(id),
        queryParameters: {
          'page': page ?? 1,
          'limit': limit ?? 5,
        },
      );

      return ListOfReceptionistResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      try {
        return ListOfReceptionistResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return ListOfReceptionistResponse(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return ListOfReceptionistResponse(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel<Guest>> inviteGuest({
    required InviteNewGuestRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();
      var response = await ApiServices.call().post(
        EndpointConstant.addGuest(data.eventId),
        data: formData,
      );

      return GeneralResponseModel<Guest>.fromJson(
        response.data,
        fromJsonT: (data) => Guest.fromJson(data),
      );
    } on DioException catch (dioError) {
      log('dioError: $dioError');
      try {
        return GeneralResponseModel<Guest>.fromJson(
          dioError.response?.data,
          fromJsonT: (data) => Guest.fromJson(data),
        );
      } catch (e) {
        return GeneralResponseModel<Guest>(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      log('e: $e');
      return GeneralResponseModel<Guest>(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel<ReceptionistGuest>> inviteReceptionistGuest({
    required InviteNewReceptionistGuestRequest data,
  }) async {
    try {
      FormData formData = await data.toFormData();
      var response = await ApiServices.call().post(
        EndpointConstant.addReceptionist(data.eventId),
        data: formData,
      );

      return GeneralResponseModel<ReceptionistGuest>.fromJson(
        response.data,
        fromJsonT: (data) => ReceptionistGuest.fromJson(data),
      );
    } on DioException catch (dioError) {
      log('dioError: $dioError');
      try {
        return GeneralResponseModel<ReceptionistGuest>.fromJson(
          dioError.response?.data,
          fromJsonT: (data) => ReceptionistGuest.fromJson(data),
        );
      } catch (e) {
        return GeneralResponseModel<ReceptionistGuest>(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      log('e: $e');
      return GeneralResponseModel<ReceptionistGuest>(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel<EventData>> getEventWithCode({
    required String code,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.getEventByUniqueCode(code),
      );

      return GeneralResponseModel<EventData>.fromJson(
        response.data,
        fromJsonT: (data) => EventData.fromJson(data),
      );
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel<EventData>.fromJson(
          dioError.response?.data,
          fromJsonT: (data) => EventData.fromJson(data),
        );
      } catch (e) {
        return GeneralResponseModel<EventData>(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GeneralResponseModel<EventData>(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel<ReceptionistGuestResponse>> getReceptionistGuest({
    required String accessCode,
    required String uniqueCode,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'access_code': accessCode,
        'unique_code': uniqueCode,
      });

      var response = await ApiServices.call().post(
        EndpointConstant.accessAsReceptionist,
        data: formData,
      );

      return GeneralResponseModel<ReceptionistGuestResponse>.fromJson(
        response.data,
        fromJsonT: (data) => ReceptionistGuestResponse.fromJson(data),
      );
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel<ReceptionistGuestResponse>.fromJson(
          dioError.response?.data,
          fromJsonT: (data) => ReceptionistGuestResponse.fromJson(data),
        );
      } catch (e) {
        return GeneralResponseModel<ReceptionistGuestResponse>(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      }
    } catch (e) {
      return GeneralResponseModel<ReceptionistGuestResponse>(
        statusCode: 0,
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> deleteGuest({
    required String eventId,
    required String guestId,
  }) async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.deleteGuest(eventId, guestId),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> deleteReceptionistGuest({
    required String eventId,
    required String guestId,
  }) async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.deleteReceptionist(eventId, guestId),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<GeneralResponseModel> deleteEvent({
    required String eventId,
  }) async {
    try {
      var response = await ApiServices.call().post(
        EndpointConstant.deleteEvent(eventId),
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
        message: 'Something went wrong',
      );
    }
  }

  Future<MyJoinedEventResponse> myCreatedEvents({
    required DateTime startDate,
    required DateTime endDate,
    int? limit,
    int? page,
    String? keyword,
  }) async {
    try {
      var response = await ApiServices.call().get(
        EndpointConstant.myEvents,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'page': page ?? 1,
          'limit': limit ?? 5,
          if (keyword != null) 'keyword': keyword,
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
        message: 'Something went wrong',
      );
    }
  }
}
