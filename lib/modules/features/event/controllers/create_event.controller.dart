import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/models/requests/create_event.request.dart';
import 'package:guest_allow/modules/features/event/models/responses/create_event.response.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/global_controllers/maps.controller.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/modules/global_repositories/maps.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/drawer_content_choose_file_widget.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
// import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;

class CreateEventController extends GetxController {
  static CreateEventController get to => Get.find();

  var args = Get.arguments;

  late MapsController mapsController;
  final EventRepository _eventRepository = EventRepository();
  final MapsRepository _mapsRepository = MapsRepository();
  late GoogleMapController chooseMapController;
  late String sessionToken;

  Rx<DateTime> selectedStartDate = DateTime.now().obs;
  Rx<DateTime> selectedEndDate = DateTime.now().obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxInt selectedEventStatus = 0.obs;
  RxInt selectedEventType = 0.obs;

  List<UserModel> selectedParticipants = [];
  List<UserModel> selectedReceptionists = [];
  List<Guest> selectedGuests = [];
  List<ReceptionistGuest> selectedReceptionistGuests = [];

  LatLng? selectedLocation;
  Placemark? selectedPlacemark;

  File? selectedImage;

  List<Marker> markers = [];
  final uuid = const Uuid();

  Rx<UIState<Position>> userPositionState = const UIState<Position>.idle().obs;
  Rx<UIState<Placemark>> placeMarkState = const UIState<Placemark>.idle().obs;

  /// NOMINATIM MAPS API
  Rx<UIState<List<PlaceFeature>>> placeFeatureState =
      const UIState<List<PlaceFeature>>.idle().obs;
  Rx<UIState<PlaceFeature>> placeDetailStateNominatim =
      const UIState<PlaceFeature>.idle().obs;

  RxBool isEditing = false.obs;
  RxBool showAddGuest = false.obs;
  RxBool showAddReceptionist = false.obs;

  EventData? event;

  @override
  void onInit() {
    super.onInit();
    sessionToken = uuid.v4();
    if (args != null) {
      if (args is EventData) {
        event = args;
        titleController.text = event!.title ?? '';
        descriptionController.text = event!.description ?? '';
        locationController.text = event!.location ?? '';
        radiusController.text = (event!.radius ?? 0).toString();
        linkController.text = event!.link ?? '';
        selectedStartDate.value = DateTime.tryParse(event!.startDate ?? '') ??
            DateTime.now().add(
              const Duration(minutes: 30),
            );
        startDateController.text =
            selectedStartDate.value.toHumanDateTimeShort();
        selectedEndDate.value =
            DateTime.tryParse(event!.endDate ?? '') ?? DateTime.now();
        endDateController.text = selectedEndDate.value.toHumanDateTimeShort();
        selectedEventStatus.value = event!.type ?? 0;
        selectedEventType.value = event!.visibility ?? 0;
        selectedParticipants = event!.participants ?? [];
        selectedReceptionists = event!.receptionists ?? [];
        selectedGuests = event!.guests ?? [];
        selectedReceptionistGuests = event!.receptionistGuests ?? [];
        double lat = double.tryParse(event!.latitude ?? '') ?? 0;
        double long = double.tryParse(event!.longitude ?? '') ?? 0;
        selectedLocation = LatLng(lat, long);
        setFileImageFromUrl(event!.photo ?? '');

        setMarker(selectedLocation!);
        if (event!.id != null) {
          isEditing.value = true;
        }
      }
    }
  }

  void setFileImageFromUrl(String imageUrl) async {
    try {
      selectedImage = await FileHelper.getImageFileFromUrl(imageUrl);
      update(['image']);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedStartDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1.2,
          child: Theme(
            data: ThemeData(),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != selectedStartDate.value) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        selectedStartDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (selectedStartDate.value.isAfter(selectedEndDate.value)) {
          selectedEndDate.value = selectedStartDate.value.add(
            const Duration(hours: 1),
          );

          endDateController.text = selectedEndDate.value.toHumanDateTimeShort();
        }
        startDateController.text =
            selectedStartDate.value.toHumanDateTimeShort();
      }
    }
  }

  void selectEndDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedEndDate.value,
      firstDate: selectedStartDate.value,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1.2,
          child: Theme(
            data: ThemeData(),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != selectedEndDate.value) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        picked = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (picked.isBefore(selectedStartDate.value)) {
          Get.snackbar(
            'Error',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
          );
          selectedEndDate.value = selectedStartDate.value;
          endDateController.text = selectedEndDate.value.toHumanDateTimeShort();
        } else {
          selectedEndDate.value = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          endDateController.text = selectedEndDate.value.toHumanDateTimeShort();
        }
      }
    }
  }

  void showMap() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return GetBuilder<CreateEventController>(
          id: 'map',
          initState: (_) {
            initializeMapsController();
          },
          builder: (state) {
            return _showMapModalBottomSheet(state);
          },
        );
      },
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  Container _showMapModalBottomSheet(CreateEventController state) {
    return Container(
      height: 0.9.sh,
      width: Get.width,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () =>
                      state.userPositionState.value.whenOrNull(
                        loading: () => CustomShimmerWidget.card(
                          height: 200,
                          width: 1.sw,
                          margin: 5,
                        ),
                        success: (data) {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: GoogleMap(
                              onMapCreated: (controller) {
                                chooseMapController = controller;
                              },
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  selectedLocation?.latitude ?? data.latitude,
                                  selectedLocation?.longitude ?? data.longitude,
                                ),
                                zoom: 16,
                              ),
                              onTap: (location) async {
                                selectedLocation = location;
                                setMarker(selectedLocation!);
                                nominatimReverseGeocode(selectedLocation!);
                              },
                              markers: markers.toSet(),
                              circles: {
                                if (radiusController.text.isNotEmpty &&
                                    selectedLocation != null)
                                  Circle(
                                    circleId: const CircleId('radius'),
                                    center: selectedLocation!,
                                    radius: double.parse(
                                      radiusController.text,
                                    ),
                                    fillColor: Colors.blue.withOpacity(0.3),
                                    strokeWidth: 2,
                                    strokeColor: Colors.blue,
                                  ),
                              },
                              myLocationEnabled: true,
                            ),
                          );
                        },
                        error: (message) => Center(
                          child: Text(message),
                        ),
                      ) ??
                      const SizedBox(),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search Location',
                                  border: InputBorder.none,
                                ),
                                onFieldSubmitted: (value) {
                                  nominatimFindPlace(value);
                                },
                              ),
                            ),
                            if (searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  searchController.clear();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () =>
                            state.placeFeatureState.value.whenOrNull(
                              loading: () => CustomShimmerWidget.card(
                                height: 100,
                                width: 1.sw,
                                margin: 5,
                              ),
                              success: (data) {
                                return Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 200,
                                    minHeight: 0,
                                  ),
                                  color: Colors.white,
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(data[index]
                                                .properties
                                                ?.displayName ??
                                            ""),
                                        onTap: () {
                                          searchController.text = data[index]
                                                  .properties
                                                  ?.displayName ??
                                              '';
                                          state.placeFeatureState.value =
                                              const UIState.idle();

                                          selectedLocation = LatLng(
                                            data[index]
                                                    .geometry
                                                    ?.coordinates
                                                    ?.last ??
                                                0,
                                            data[index]
                                                    .geometry
                                                    ?.coordinates
                                                    ?.first ??
                                                0,
                                          );

                                          setMarker(selectedLocation!);

                                          chooseMapController.animateCamera(
                                            CameraUpdate.newLatLng(
                                              selectedLocation!,
                                            ),
                                          );
                                          locationController.text = data[index]
                                                  .properties
                                                  ?.displayName ??
                                              '';

                                          update(['map']);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              error: (message) => Center(
                                child: Text(message),
                              ),
                            ) ??
                            const SizedBox(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Obx(
                    () =>
                        state.placeDetailStateNominatim.value.whenOrNull(
                          loading: () => CustomShimmerWidget.card(
                            height: 20,
                            width: 1.sw,
                            margin: 5,
                          ),
                          success: (data) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    data.properties?.displayName ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          error: (message) => Center(
                            child: Text(message),
                          ),
                        ) ??
                        const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MainColor.primary,
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            child: Container(
              width: 1.sw,
              alignment: Alignment.center,
              child: const Text(
                'Select Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setMarker(LatLng location) {
    markers = [
      Marker(
        markerId: const MarkerId('selectedLocation'),
        position: location,
      ),
    ];
    update(['map']);
  }

  Future<void> initializeMapsController() async {
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
      userPositionState.value =
          UIState.success(data: mapsController.userPosition);
    } catch (e) {
      userPositionState.value = UIState.error(message: e.toString());
    }
  }

  /// ================== NOMINATIM MAPS API ==================================
  /// This method is used to get suggestion from Nominatim Maps API

  Future<void> nominatimFindPlace(String input) async {
    try {
      placeFeatureState.value = const UIState.loading();

      GeneralResponseModel response = await _mapsRepository.nominatimFindPlace(
        query: input,
      );

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        if (((response.meta as NominatimFindPlaceResponse).features ?? [])
            .isEmpty) {
          placeFeatureState.value =
              const UIState.empty(message: 'No place found');
        } else {
          placeFeatureState.value = UIState.success(
              data:
                  (response.meta as NominatimFindPlaceResponse).features ?? []);

          nominatimReverseGeocode(
            LatLng(
              (response.meta as NominatimFindPlaceResponse)
                      .features
                      ?.first
                      .geometry
                      ?.coordinates
                      ?.last ??
                  0,
              (response.meta as NominatimFindPlaceResponse)
                      .features
                      ?.first
                      .geometry
                      ?.coordinates
                      ?.first ??
                  0,
            ),
          );
        }
      } else {
        placeFeatureState.value =
            UIState.error(message: response.message ?? 'Something went wrong');
      }
    } catch (e) {
      placeFeatureState.value = UIState.error(message: e.toString());
    }
  }

  Future<void> nominatimReverseGeocode(LatLng location) async {
    try {
      placeDetailStateNominatim.value = const UIState.loading();
      GeneralResponseModel response =
          await _mapsRepository.nominatimReverseGeocode(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        if (((response.meta as NominatimFindPlaceResponse).features ?? [])
            .isEmpty) {
          placeFeatureState.value =
              const UIState.empty(message: 'No place found');
        } else {
          var data = (response.meta as NominatimFindPlaceResponse).features;
          placeDetailStateNominatim.value =
              UIState.success(data: data?.first ?? PlaceFeature());

          locationController.text = data?.first.properties?.displayName ?? '';

          update(['map']);
        }
      } else {
        placeDetailStateNominatim.value =
            UIState.error(message: response.message ?? 'Something went wrong');
      }
    } catch (e) {
      placeDetailStateNominatim.value = UIState.error(message: e.toString());
    }
  }

  void selectParticipants() async {
    var data = await Get.toNamed(
      MainRoute.selectUser,
      arguments: {
        'selectedUsers': selectedParticipants,
      },
    );
    if (data != null) {
      selectedParticipants = data;
      update(['participants']);
    } else {
      showAddGuest.value = true;
    }
  }

  void selectReceptionists() async {
    var data = await Get.toNamed(
      MainRoute.selectUser,
      arguments: {
        'selectedUsers': selectedReceptionists,
      },
    );
    if (data != null) {
      selectedReceptionists = data;
      update(['receptionists']);
    } else {
      showAddReceptionist.value = true;
    }
  }

  void removeParticipant(String userId) {
    selectedParticipants.removeWhere((element) => element.id == userId);
    update(['participants']);
  }

  void removeReceptionist(String userId) {
    selectedReceptionists.removeWhere((element) => element.id == userId);
    update(['receptionists']);
  }

  void selectImage() async {
    var image = await showModalBottomSheet<File?>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih File',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: const DrawerContentChooseFileWidget(
                sourceFiles: [
                  SourceFileEnum.gallery,
                  SourceFileEnum.camera,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (image != null) {
      selectedImage = image;
      update(['image']);
    }
  }

  void removeImage() {
    selectedImage = null;
    update(['image']);
  }

  void removeGuest(String userId) {
    CustomDialogWidget.showDialogChoice(
      title: 'Remove Guest',
      description:
          'Are you sure want to remove this guest? The guest will be removed from the list and cannot be undone',
      onTapPositiveButton: () {
        Get.back();
        deleteGuest(userId);
      },
      onTapNegativeButton: () {
        Get.back();
      },
    );
  }

  void removeReceptionistGuest(String userId) {
    CustomDialogWidget.showDialogChoice(
      title: 'Remove Guest Receptionist',
      description:
          'Are you sure want to remove this guest receptionist? The data will be removed from the list and cannot be undone',
      onTapPositiveButton: () {
        Get.back();
        deleteGuestReceptionist(userId);
      },
      onTapNegativeButton: () {
        Get.back();
      },
    );
  }

  void selectGuests() async {
    var data = await Get.toNamed(
      MainRoute.editGuests,
      arguments: {
        'selectedGuests': selectedGuests,
        'eventId': event?.id,
        'isCreate': !isEditing.value,
      },
    );
    if (data != null) {
      selectedGuests = data;
      update(['guests']);
    }
  }

  void selectReceptionistGuests() async {
    var data = await Get.toNamed(
      MainRoute.editReceptionistGuests,
      arguments: {
        'selectedGuests': selectedReceptionistGuests,
        'eventId': event?.id,
        'isCreate': !isEditing.value,
      },
    );
    if (data != null) {
      selectedReceptionistGuests = data;
      update(['receptionists_guests']);
    }
  }

  Future<void> deleteGuest(String guestId) async {
    try {
      if (isEditing.value) {
        CustomDialogWidget.showLoading();

        var response = await _eventRepository.deleteGuest(
          eventId: event?.id ?? '',
          guestId: guestId,
        );
        CustomDialogWidget.closeLoading();

        if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
          selectedGuests.removeWhere((element) => element.id == guestId);
          update(['guests']);
        } else {
          log(response.message ?? '');
          CustomDialogWidget.showDialogProblem(
            description: response.message ?? 'Failed to delete guest',
          );
        }
      } else {
        selectedGuests.removeWhere((element) => element.id == guestId);
        update(['guests']);
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        description: 'Failed to delete guest',
      );
    }
  }

  Future<void> deleteGuestReceptionist(String id) async {
    try {
      if (isEditing.value) {
        CustomDialogWidget.showLoading();

        var response = await _eventRepository.deleteReceptionistGuest(
          eventId: event?.id ?? '',
          guestId: id,
        );
        CustomDialogWidget.closeLoading();

        if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
          selectedReceptionistGuests.removeWhere((element) => element.id == id);
          update(['receptionists_guests']);
        } else {
          log(response.message ?? '');
          CustomDialogWidget.showDialogProblem(
            description: response.message ?? 'Failed to delete guest',
          );
        }
      } else {
        selectedReceptionistGuests.removeWhere((element) => element.id == id);
        update(['receptionists_guests']);
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        description: 'Failed to delete guest',
      );
    }
  }

  void createEvent() async {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title cannot be empty',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Description cannot be empty',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (selectedEventStatus.value == 0) {
      if (linkController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Link cannot be empty',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    } else if (selectedEventStatus.value == 1) {
      if (locationController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Location cannot be empty',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    }

    if (startDateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Start date cannot be empty',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (endDateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'End date cannot be empty',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (selectedImage == null) {
      Get.snackbar(
        'Error',
        'Image cannot be empty',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    CreateEventRequest data = CreateEventRequest(
      title: titleController.text,
      description: descriptionController.text,
      location: locationController.text,
      latitude: selectedLocation?.latitude,
      longitude: selectedLocation?.longitude,
      price: 0,
      startDate: selectedStartDate.value.toUtc(),
      endDate: selectedEndDate.value.toUtc(),
      link: linkController.text,
      type: selectedEventStatus.value,
      visibility: selectedEventType.value,
      radius: radiusController.text,
      timeZone: tz.local.name,
      participants: selectedParticipants.map((e) => e.id ?? "").toList(),
      receptionists: selectedReceptionists.map((e) => e.id ?? "").toList(),
      image: selectedImage!,
    );

    try {
      CustomDialogWidget.showLoading();
      CreateEventResponse response;
      if (isEditing.value) {
        response = await _eventRepository.editEvent(
          id: event!.id ?? '',
          data: data,
        );
      } else {
        data.guests = selectedGuests;
        data.receptionistGuests = selectedReceptionistGuests;
        response = await _eventRepository.createEvent(
          data: data,
        );
      }
      CustomDialogWidget.closeLoading();
      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Something went wrong',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
