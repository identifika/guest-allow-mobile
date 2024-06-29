import 'package:dio/dio.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/modules/global_models/responses/google_maps/get_address_detail.response.dart';
import 'package:guest_allow/modules/global_models/responses/google_maps/place_suggestion.response.dart';
import 'package:guest_allow/modules/global_models/responses/google_maps/reverse_geocode.response.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/utils/helpers/dio_error.helper.dart';

class MapsRepository {
  Future<PlaceSuggestionResponse> getPlaceSuggestions({
    required String query,
    required String sessionToken,
  }) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';

      String apiKey = 'AIzaSyD8A8iSFwEWu2PPuR-sgFr6Xb86eH1Bvv0';

      Dio dio = Dio();
      var response = await dio.get(
        baseURL,
        queryParameters: {
          'input': query,
          'key': apiKey,
          'sessiontoken': sessionToken,
        },
      );

      PlaceSuggestionResponse placeSuggestionResponse =
          PlaceSuggestionResponse.fromJson(response.data);

      return placeSuggestionResponse;
    } on DioException catch (dioError) {
      try {
        return PlaceSuggestionResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return PlaceSuggestionResponse(
          status: 'error',
          predictions: [],
        );
      }
    } catch (e) {
      return PlaceSuggestionResponse(
        status: 'error',
        predictions: [],
      );
    }
  }

  Future<GetAddressDetailResponse> getPlaceCoordinates({
    required String query,
    required String sessionToken,
  }) async {
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json';

      String apiKey = 'AIzaSyD8A8iSFwEWu2PPuR-sgFr6Xb86eH1Bvv0';

      Dio dio = Dio();
      var response = await dio.get(
        baseURL,
        queryParameters: {
          'address': query,
          'key': apiKey,
          'sessiontoken': sessionToken,
        },
      );

      GetAddressDetailResponse findPlaceResponse =
          GetAddressDetailResponse.fromJson(response.data);

      return findPlaceResponse;
    } on DioException catch (dioError) {
      try {
        return GetAddressDetailResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return GetAddressDetailResponse(
          status: 'error',
          results: [],
        );
      }
    } catch (e) {
      return GetAddressDetailResponse(
        status: 'error',
        results: [],
      );
    }
  }

  Future<ReverseGeocodeResponse> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json';

      String apiKey = 'AIzaSyD8A8iSFwEWu2PPuR-sgFr6Xb86eH1Bvv0';

      Dio dio = Dio();
      var response = await dio.get(
        baseURL,
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': apiKey,
        },
      );

      ReverseGeocodeResponse reverseGeocodeResponse =
          ReverseGeocodeResponse.fromJson(response.data);

      return reverseGeocodeResponse;
    } on DioException catch (dioError) {
      try {
        return ReverseGeocodeResponse.fromJson(dioError.response?.data);
      } catch (e) {
        return ReverseGeocodeResponse(
          status: 'error',
          results: [],
        );
      }
    } catch (e) {
      return ReverseGeocodeResponse(
        status: 'error',
        results: [],
      );
    }
  }

  Future<GeneralResponseModel> nominatimFindPlace({
    required String query,
  }) async {
    try {
      String baseURL = 'https://nominatim.openstreetmap.org/search';

      Dio dio = Dio();
      var response = await dio.get(
        baseURL,
        queryParameters: {
          'q': query,
          'format': 'geojson',
          'limit': 5,
        },
      );

      NominatimFindPlaceResponse nominatimFindPlaceResponse =
          NominatimFindPlaceResponse.fromJson(response.data);

      GeneralResponseModel generalResponseModel = GeneralResponseModel(
        statusCode: 200,
        message: 'Success',
        meta: nominatimFindPlaceResponse,
      );

      return generalResponseModel;
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      } catch (e) {
        return GeneralResponseModel(
          statusCode: 400,
          message: 'Terjadi kesalahan',
        );
      }
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 400,
        message: 'Terjadi kesalahan',
      );
    }
  }

  Future<GeneralResponseModel> nominatimReverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      String baseURL = 'https://nominatim.openstreetmap.org/reverse';

      Dio dio = Dio();
      var response = await dio.get(
        baseURL,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'geojson',
        },
      );

      NominatimFindPlaceResponse nominatimFindPlaceResponse =
          NominatimFindPlaceResponse.fromJson(response.data);

      GeneralResponseModel generalResponseModel = GeneralResponseModel(
        statusCode: 200,
        message: 'Success',
        meta: nominatimFindPlaceResponse,
      );

      return generalResponseModel;
    } on DioException catch (dioError) {
      try {
        return GeneralResponseModel(
          statusCode: dioError.response?.statusCode ?? 400,
          message: DioErrorHelper.fromDioError(dioError),
        );
      } catch (e) {
        return GeneralResponseModel(
          statusCode: 400,
          message: 'Terjadi kesalahan',
        );
      }
    } catch (e) {
      return GeneralResponseModel(
        statusCode: 400,
        message: 'Terjadi kesalahan',
      );
    }
  }
}
