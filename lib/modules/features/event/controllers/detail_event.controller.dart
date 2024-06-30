import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_map.controller.dart';
import 'package:guest_allow/modules/features/event/models/responses/event_detail.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/global_controllers/maps.controller.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/face_recognition.service.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

enum EventDetailType {
  owner,
  participant,
  receptionist,
  guest,
}

// read event detail type

extension EventDetailTypeExtension on EventDetailType {
  String get read {
    switch (this) {
      case EventDetailType.owner:
        return 'owner';
      case EventDetailType.participant:
        return 'participant';
      case EventDetailType.receptionist:
        return 'receptionist';
      case EventDetailType.guest:
        return 'guest';
      default:
        return '';
    }
  }
}

enum EventStatus {
  onGoing,
  upcoming,
  finished,
}

extension EventStatusExtension on EventStatus {
  String get read {
    switch (this) {
      case EventStatus.onGoing:
        return 'onGoing';
      case EventStatus.upcoming:
        return 'upcoming';
      case EventStatus.finished:
        return 'finished';
      default:
        return '';
    }
  }
}

class DetailEventController extends GetxController {
  static DetailEventController get to => Get.find();
  var args = Get.arguments;

  final EventRepository _eventRepository = EventRepository();
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();

  Rx<UIState<EventData?>> eventDetailState =
      const UIState<EventData?>.idle().obs;

  Rx<UIState<Position>> userPosition = const UIState<Position>.idle().obs;

  late MapsController mapsController;
  DetailMapController detailMapController = Get.put(DetailMapController());

  late UserLocalData? userLocalData;
  EventDetailType eventDetailType = EventDetailType.guest;
  late EventStatus eventStatus;
  var currentTime = DateTime.now();

  Future<void> getEventDetail(String id) async {
    eventDetailState.value = const UIState<EventData>.loading();
    var response = await _eventRepository.getEventDetail(id);
    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.data != null) {
        _setUserToEventState(response);
        _setEventTimeStatus(response);
      }
      eventDetailState.value = UIState.success(data: response.data);
    } else {
      eventDetailState.value = UIState.error(
        message: response.message ?? 'Something went wrong',
      );
    }
  }

  void _setEventTimeStatus(EventDetailResponse response) {
    var startTime = tz.TZDateTime.from(
      DateTime.tryParse(response.data?.startDate ?? '') ?? DateTime.now(),
      tz.getLocation(response.data?.timeZone ?? ''),
    ).toLocal();

    var endTime = tz.TZDateTime.from(
      (DateTime.tryParse(response.data?.endDate ?? '') ?? DateTime.now()),
      tz.getLocation(response.data?.timeZone ?? ''),
    ).toLocal();

    if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
      eventStatus = EventStatus.onGoing;
    } else if (currentTime.isBefore(startTime)) {
      eventStatus = EventStatus.upcoming;
    } else {
      eventStatus = EventStatus.finished;
    }
  }

  void _setUserToEventState(EventDetailResponse response) {
    if (response.data?.createdById == userLocalData?.userId) {
      eventDetailType = EventDetailType.owner;
    } else if (response.data?.participantsExists ?? false) {
      eventDetailType = EventDetailType.participant;
    } else if (response.data?.receptionistsExists ?? false) {
      eventDetailType = EventDetailType.receptionist;
    } else {
      eventDetailType = EventDetailType.guest;
    }
  }

  Future<void> joinEvent(String id) async {
    CustomDialogWidget.showLoading();
    var response = await _eventRepository.joinEvent(id);
    CustomDialogWidget.closeLoading();
    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      await CustomDialogWidget.showDialogSuccess(
        description: response.message ?? 'Successfully joined the event',
      );
      getEventDetail(id);
    } else {
      eventDetailState.value = UIState.error(
        message: response.message ?? 'Something went wrong',
      );
    }
  }

  Future<void> cancelJoinEvent(String id) async {
    CustomDialogWidget.showLoading();
    var response = await _eventRepository.cancelJoinEvent(id);
    CustomDialogWidget.closeLoading();
    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      await CustomDialogWidget.showDialogSuccess(
        description: response.message ?? 'Successfully canceled participation',
      );
      getEventDetail(id);
    } else {
      eventDetailState.value = UIState.error(
        message: response.message ?? 'Something went wrong',
      );
    }
  }

  void dialogJoinEvent(String id, String eventName) {
    UserLocalData? user = LocalDbService.getUserLocalDataSync();
    if (user?.faceIdentifier == null) {
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'You have not enrolled your face yet',
        buttonOnTap: () {
          Get.back();
          _faceRecognitionService.enrollFace();
        },
      );
      return;
    }

    CustomDialogWidget.showDialogChoice(
      description: 'Are you sure you want to join the event $eventName?',
      onTapPositiveButton: () async {
        Get.back();
        await joinEvent(id);
      },
      onTapNegativeButton: () => Get.back(),
    );
  }

  void dialogCancelJoinEvent(String id, String eventName) {
    CustomDialogWidget.showDialogChoice(
      description:
          'Are you sure you want to cancel your participation in the event $eventName?',
      onTapPositiveButton: () async {
        Get.back();
        await cancelJoinEvent(id);
      },
      onTapNegativeButton: () => Get.back(),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      userPosition.value = const UIState<Position>.loading();
      await mapsController.getUserPosition();
      userPosition.value = UIState.success(data: mapsController.userPosition);
    } catch (e) {
      userPosition.value = UIState.error(message: e.toString());
    }
  }

  void initializeMapsController() {
    var isAlreadyExist = Get.isRegistered<MapsController>();
    if (!isAlreadyExist) {
      mapsController = Get.put(MapsController());
    } else {
      mapsController = Get.find<MapsController>();
    }
  }

  void attendOnlineEvent(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Url cannot be opened',
      );
    }
  }

  Future<void> initializeUserLocalData() async {
    userLocalData = await LocalDbService.getUserLocalData();
  }

  Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      CustomDialogWidget.showDialogSuccess(
        description: 'Url copied to clipboard',
      );
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Failed to copy url to clipboard',
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    initializeMapsController();
    await initializeUserLocalData();

    if (args != null) {
      if (args is EventModel) {
        getEventDetail(args.id);
      } else if (args is Map<String, dynamic>) {
        if (args['eventData'] != null) {
          getEventDetail(args['eventData']['id']);
        }
      } else {
        EventModel eventModel = EventModel.fromJson(args);
        getEventDetail(eventModel.id);
      }
    }
  }
}
