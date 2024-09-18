import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/responses/receptionist_guest.response.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/responses/sign_in.response.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/ui/components/login_as_receptionist_sheet.dart';
import 'package:guest_allow/modules/features/auth/repositories/auth.repository.dart';
import 'package:guest_allow/modules/features/event/controllers/receive_attende.controller.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/global_models/responses/general_response_model.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/modules/global_repositories/maps.repository.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController eventCodeController = TextEditingController();
  TextEditingController accessCodeController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode eventCodeFocus = FocusNode();
  FocusNode accessCodeFocus = FocusNode();

  final AuthRepository _authRepository = AuthRepository();
  final EventRepository _eventRepository = EventRepository();
  final MapsRepository _mapsRepository = MapsRepository();

  SignInResponse? signInResponse;

  Rx<UIState<EventData>> eventDataState = const UIState<EventData>.idle().obs;
  Rx<UIState<ReceptionistGuestResponse>> receptionistGuestState =
      const UIState<ReceptionistGuestResponse>.idle().obs;
  EventData? selectedEventData;
  ReceptionistGuestResponse? receptionistGuestData;

  bool isSignInButtonEnabled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Rx<UIState<SignInResponse>> signInState =
      const UIState<SignInResponse>.idle().obs;

  Future<void> signIn() async {
    CustomDialogWidget.showLoading();
    UserLocalData? oldData = await LocalDbService.getUserLocalData();

    signInResponse = await _authRepository.signIn(
      emailController.text,
      passwordController.text,
      fcmToken: oldData?.fcmToken,
    );
    CustomDialogWidget.closeLoading();

    if (ApiStatusHelper.isApiSuccess(signInResponse?.statusCode)) {
      await signInSuccessHandler(
          signInResponse?.user, signInResponse?.token ?? '');

      Get.offAllNamed(MainRoute.main);
    } else {
      CustomDialogWidget.showDialogProblem(
        title: 'Gagal',
        description: signInResponse?.message ?? '',
      );
    }
  }

  Future<void> signInSuccessHandler(UserModel? user, String token) async {
    UserLocalData? oldData = await LocalDbService.getUserLocalData();
    UserLocalData data = UserLocalData(
      id: 1,
      token: token,
      userId: user?.id,
      email: user?.email,
      name: user?.name,
      photo: user?.photo,
      emailVerifiedAt: user?.emailVerifiedAt,
      faceIdentifier: user?.faceIdentifier,
      createdAt: user?.createdAt,
      updatedAt: user?.updatedAt,
      fcmToken: oldData?.fcmToken,
    );
    LocalDbService.insertUserLocalData(data);
  }

  void signInAsReceptionist(BuildContext context) async {
    Get.bottomSheet(
      GetBuilder<SignInController>(
        id: 'login_as_receptionist',
        init: SignInController(),
        builder: (state) {
          return LoginAsReceptionistSheet(state: state);
        },
      ),
      isScrollControlled: true,
    );
  }

  void receiveAttende(EventData eventData) {
    CustomDialogWidget.showDialogChoice(
      title: 'Receive Attendee',
      description:
          'Ensure you are at the event location with your phone connected to the internet and GPS enabled. Additionally, confirm that your power source is ready. Are you sure you want to receive the attendee?',
      onTapPositiveButton: () {
        Get.back();
        goToReceiveAttendee(eventData);
      },
      onTapNegativeButton: () => Get.back(),
    );
  }

  void goToReceiveAttendee(EventData eventData) async {
    CustomDialogWidget.showLoading();

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      CustomDialogWidget.closeLoading();
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Location service is disabled',
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      CustomDialogWidget.closeLoading();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Location permission is denied',
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: Platform.isIOS
          ? LocationAccuracy.bestForNavigation
          : LocationAccuracy.best,
    );
    LatLng eventLocation = LatLng(
      double.parse(eventData.latitude ?? '0'),
      double.parse(eventData.longitude ?? '0'),
    );
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      eventLocation.latitude,
      eventLocation.longitude,
    );

    var radius = double.parse("${eventData.radius ?? 0}");

    log('position: $position');
    log('eventLocation: $eventLocation');
    log('distanceInMeters: $distanceInMeters');
    log('radius: $radius');

    if (distanceInMeters > radius) {
      CustomDialogWidget.closeLoading();
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'You are not at the event location',
      );
      return;
    }

    GeneralResponseModel response =
        await _mapsRepository.nominatimReverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    PlaceFeature? userAddress;

    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (((response.meta as NominatimFindPlaceResponse).features ?? [])
          .isEmpty) {
        CustomDialogWidget.closeLoading();
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Failed to get location detail',
        );
      } else {
        var data = (response.meta as NominatimFindPlaceResponse).features;
        userAddress = data?.first;
      }
    } else {
      CustomDialogWidget.closeLoading();
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: response.message ?? 'Failed to get location detail',
      );
    }

    CustomDialogWidget.closeLoading();

    Get.toNamed(
      MainRoute.receiveAttendees,
      arguments: {
        'eventData': eventData,
        'address': userAddress,
        'position': position,
        'userType': UserTypeEnum.guest,
        'receptionistGuest': receptionistGuestData?.receptionists,
      },
    );
  }

  void signInAsGuest(BuildContext context) async {
    await Get.bottomSheet(
      GetBuilder<SignInController>(
        id: 'login_as_guest',
        init: SignInController(),
        builder: (state) {
          return LoginAsGuestSheet(state: state);
        },
      ),
      isScrollControlled: true,
    );

    // // reset the event code controller
    // eventCodeController.clear();
    // eventDataState.value = const UIState<EventData>.idle();
    // selectedEventData = null;
  }

  Container test(SignInController state, BuildContext context) {
    return Container(
      height: 0.5.sh,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Masuk Sebagai Tamu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masukkan kode tamu untuk masuk sebagai tamu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: state.eventCodeController,
            maxLength: 6,
            onSubmitted: (value) {
              state.getEventData(value);
              // unfocus the text field
              FocusScope.of(context).unfocus();
            },
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: "Event Code",
              hintStyle: const TextStyle(
                color: MainColor.black,
                fontSize: 16,
              ),
              fillColor: MainColor.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.selectedEventData == null
                  ? null
                  : () {
                      Get.toNamed(
                        MainRoute.attendEventAsGuest,
                        arguments: selectedEventData,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () =>
                state.eventDataState.value.whenOrNull(
                  loading: () => const CustomShimmerWidget.card(
                    width: double.infinity,
                    height: 100,
                  ),
                  success: (data) {
                    EventModel event = EventModel.fromEventData(data);
                    return GestureDetector(
                      onTap: () {
                        setSelectEventData(data);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                            ),
                            decoration: BoxDecoration(
                              color: MainColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CardThisMonthEvent(
                              eventModel: event,
                            ),
                          ),
                          // selected effect
                          Visibility(
                            visible: selectedEventData != null &&
                                selectedEventData!.id == event.id,
                            child: Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: MainColor.info,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  empty: (message) => Center(
                    child: Text(message),
                  ),
                ) ??
                const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void setSelectEventData(EventData data) {
    if (selectedEventData != null && selectedEventData!.id == data.id) {
      selectedEventData = null;
    } else {
      selectedEventData = data;
    }
    update(['login_as_guest']);
  }

  void setReceptionistGuestData(ReceptionistGuestResponse data) {
    if (receptionistGuestData != null &&
        receptionistGuestData!.event == data.event) {
      receptionistGuestData = null;
    } else {
      receptionistGuestData = data;
    }
    update(['login_as_receptionist']);
  }

  Future<void> getEventData(String uniqueCode) async {
    eventDataState.value = const UIState<EventData>.loading();

    // delay for loading effect
    await Future.delayed(const Duration(seconds: 2));
    var response = await _eventRepository.getEventWithCode(code: uniqueCode);

    if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
      eventDataState.value =
          UIState<EventData>.success(data: response.meta ?? EventData());
    } else {
      eventDataState.value = UIState<EventData>.empty(
        message: response.message ?? '',
      );
    }
  }

  Future<void> getReceptionistGuest(
      String uniqueCode, String accessCode) async {
    receptionistGuestState.value =
        const UIState<ReceptionistGuestResponse>.loading();

    // delay for loading effect
    await Future.delayed(const Duration(seconds: 2));
    var response = await _eventRepository.getReceptionistGuest(
      uniqueCode: uniqueCode,
      accessCode: accessCode,
    );

    if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
      receptionistGuestState.value = UIState<ReceptionistGuestResponse>.success(
          data: response.meta ?? ReceptionistGuestResponse());
    } else {
      receptionistGuestState.value = UIState<ReceptionistGuestResponse>.empty(
        message: response.message ?? '',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      update(['signInButton']);
    });

    passwordController.addListener(() {
      update(['signInButton']);
    });
  }
}

class LoginAsGuestSheet extends StatelessWidget {
  final SignInController state;

  const LoginAsGuestSheet({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.sh,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Masuk Sebagai Tamu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masukkan kode tamu untuk masuk sebagai tamu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: state.eventCodeController,
            maxLength: 6,
            onSubmitted: (value) {
              state.getEventData(value);
              // unfocus the text field
              FocusScope.of(context).unfocus();
            },
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: "Event Code",
              hintStyle: const TextStyle(
                color: MainColor.black,
                fontSize: 16,
              ),
              fillColor: MainColor.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.selectedEventData == null
                  ? null
                  : () {
                      Get.toNamed(
                        MainRoute.attendEventAsGuest,
                        arguments: state.selectedEventData,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () =>
                state.eventDataState.value.whenOrNull(
                  loading: () => const CustomShimmerWidget.card(
                    width: double.infinity,
                    height: 100,
                  ),
                  success: (data) {
                    EventModel event = EventModel.fromEventData(data);
                    return GestureDetector(
                      onTap: () {
                        state.setSelectEventData(data);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                            ),
                            decoration: BoxDecoration(
                              color: MainColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CardThisMonthEvent(
                              eventModel: event,
                            ),
                          ),
                          // selected effect
                          Visibility(
                            visible: state.selectedEventData != null &&
                                state.selectedEventData!.id == event.id,
                            child: Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: MainColor.info,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  empty: (message) => Center(
                    child: Text(message),
                  ),
                ) ??
                const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
