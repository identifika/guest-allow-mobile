import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/home/repositories/home.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/global_controllers/maps.controller.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/modules/global_repositories/maps.repository.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final HomeRepository _homeRepository = HomeRepository();
  final MapsRepository _mapsRepository = MapsRepository();

  DateTime selectedDate = DateTime.now();
  late MapsController mapsController;

  Rx<UIState<List<EventModel>>> popularEventState =
      const UIState<List<EventModel>>.idle().obs;
  Rx<UIState<List<EventModel>>> thisMonthEventState =
      const UIState<List<EventModel>>.idle().obs;
  Rx<UIState<PlaceFeature>> placeMarkState =
      const UIState<PlaceFeature>.idle().obs;

  Position? userPosition;
  Rx<UIState<UserLocalData>> userState =
      const UIState<UserLocalData>.idle().obs;

  Future<void> getPopularEvent() async {
    popularEventState.value = const UIState<List<EventModel>>.loading();
    var datenow = DateTime.now();

    GetPopularEventsResponse response = await _homeRepository.getPopularEvent(
      page: 1,
      limit: 5,
      userPosition: userPosition,
      startDate: DateTime(
        datenow.year,
        datenow.month,
        datenow.day,
        0,
        0,
        0,
      ),
    );
    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.meta?.data?.isNotEmpty ?? false) {
        List<EventModel> eventList = [];
        for (EventData e in (response.meta?.data ?? [])) {
          eventList.add(
            EventModel.fromEventData(
              e,
            ),
          );
        }

        popularEventState.value = UIState.success(data: eventList);
      } else {
        popularEventState.value = const UIState<List<EventModel>>.empty();
      }
    } else {
      popularEventState.value =
          UIState.error(message: response.message ?? 'Terjadi kesalahan');
    }
  }

  Future<void> getThisMonthEvent() async {
    thisMonthEventState.value = const UIState<List<EventModel>>.loading();
    // delete the existing data
    GetPopularEventsResponse response = await _homeRepository.getThisMonthEvent(
      page: 1,
      limit: 3,
      startDate: DateTime(selectedDate.year, selectedDate.month, 1),
      endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
      userPosition: userPosition,
      maxDistance: 10000,
    );
    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.meta?.data?.isNotEmpty ?? false) {
        List<EventModel> eventList = [];
        for (EventData e in (response.meta?.data ?? [])) {
          eventList.add(
            EventModel.fromEventData(
              e,
            ),
          );
        }

        thisMonthEventState.value = UIState.success(data: eventList);
      } else {
        thisMonthEventState.value = const UIState<List<EventModel>>.empty();
      }
    } else {
      thisMonthEventState.value =
          UIState.error(message: response.message ?? 'Terjadi kesalahan');
    }
  }

  Future<void> initializeMapsController() async {
    thisMonthEventState.value = const UIState<List<EventModel>>.loading();
    popularEventState.value = const UIState<List<EventModel>>.loading();

    var isAlreadyExist = Get.isRegistered<MapsController>();
    if (!isAlreadyExist) {
      mapsController = Get.put(MapsController());
    } else {
      mapsController = Get.find<MapsController>();
    }

    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      await mapsController.getUserPosition();
      userPosition = mapsController.userPosition;
      getPlaceMark();
    } catch (e) {
      userPosition = null;
    }
  }

  Future<void> getPlaceMark() async {
    try {
      placeMarkState.value = const UIState<PlaceFeature>.loading();

      var response = await _mapsRepository.nominatimReverseGeocode(
        latitude: userPosition?.latitude ?? 0,
        longitude: userPosition?.longitude ?? 0,
      );
      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        if (((response.meta as NominatimFindPlaceResponse).features ?? [])
            .isEmpty) {
          placeMarkState.value =
              const UIState.empty(message: "Can't get the current location");
        } else {
          placeMarkState.value = UIState.success(
              data: (response.meta as NominatimFindPlaceResponse)
                      .features
                      ?.first ??
                  PlaceFeature());
        }
      }
    } catch (e) {
      placeMarkState.value = UIState.error(message: e.toString());
    }
  }

  void getUser() async {
    try {
      userState.value = const UIState<UserLocalData>.loading();
      UserLocalData? user = await LocalDbService.getUserLocalData();
      if (user != null) {
        userState.value = UIState.success(data: user);
      } else {
        userState.value = const UIState<UserLocalData>.empty();
      }
    } catch (e) {
      userState.value = UIState.error(message: e.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initializeMapsController();
    getPopularEvent();
    getThisMonthEvent();
    getUser();
  }
}
