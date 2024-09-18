import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_map.controller.dart';
import 'package:guest_allow/modules/features/event/models/requests/attend_event_as_guest.request.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/face_liveness/enum/motion_type_enum.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_controllers/maps.controller.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/modules/global_repositories/face_recognition.repository.dart';
import 'package:guest_allow/modules/global_repositories/maps.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class GuestAttendEventController extends GetxController {
  static GuestAttendEventController get to => Get.find();
  var args = Get.arguments;

  late EventData eventData;

  late CameraController cameraController;
  Rx<UIState> stateCamera = const UIState.idle().obs;
  Rx<UIState> stateLiveness = const UIState.idle().obs;
  Rx<UIState<XFile>> stateTakePicture = const UIState<XFile>.idle().obs;

  FaceDetectorService faceDetectorService = FaceDetectorService(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
    ),
  );

  late MotionTypeEnum selectedMotion;
  bool isOnDetectionFace = false;
  late double scaleCamera;
  int rightMotion = 0;

  RxInt countDown = 5.obs;

  Map<MotionTypeEnum, String> assetsPath = {
    MotionTypeEnum.blink: AssetConstant.emoticonEyeBlink,
    MotionTypeEnum.shakeHead: AssetConstant.emoticonShakeHead,
  };
  Map<MotionTypeEnum, String> wordings = {
    MotionTypeEnum.blink: 'Blink Your Eyes',
    MotionTypeEnum.shakeHead: 'Shake Your Head',
  };

  XFile? imageFile;

  EventRepository eventRepository = EventRepository();
  final MapsRepository _mapsRepository = MapsRepository();
  final FaceRecognitionRepository _faceRecognitionRepository =
      FaceRecognitionRepository();

  Position? userPosition;
  PlaceFeature? userPlacemark;
  StreamSubscription<Position>? userPositionStream;
  late MapsController mapsController;
  DetailMapController detailMapController = DetailMapController();
  late LatLng eventPosition;
  RxBool isOnArea = false.obs;

  void attendEvent() async {
    try {
      if (userPosition == null) {
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Failed to get your location',
          duration: 5,
        );
        return;
      }

      if (eventData.type == 1) {
        LatLng position = LatLng(
          double.parse(eventData.latitude ?? '0'),
          double.parse(eventData.longitude ?? '0'),
        );

        bool onArea = isOnRadius(
          position,
          double.parse('${eventData.radius ?? 0}'),
        );

        if (!onArea) {
          await CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description:
                'You are not in the event area, come closer to the event area and try again',
            duration: 5,
          );
          reInitTheState();
          return;
        }
      }

      if (userPlacemark == null) {
        CustomDialogWidget.showLoading();
        var response = await _mapsRepository.nominatimReverseGeocode(
          latitude: userPosition?.latitude ?? 0,
          longitude: userPosition?.longitude ?? 0,
        );

        CustomDialogWidget.closeLoading();

        if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
          if (((response.meta as NominatimFindPlaceResponse).features ?? [])
              .isEmpty) {
            await CustomDialogWidget.showDialogProblem(
              title: 'Failed',
              description: 'Failed to get location detail',
              duration: 5,
            );

            reInitTheState();
            return;
          } else {
            var data = (response.meta as NominatimFindPlaceResponse).features;
            if (data != null && data.isNotEmpty) {
              userPlacemark = data.first;
            } else {
              await CustomDialogWidget.showDialogProblem(
                title: 'Failed',
                description: 'Failed to get location detail',
                duration: 5,
              );

              reInitTheState();
              return;
            }
          }
        } else {
          await CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: response.message ?? 'Please try again',
            duration: 5,
          );

          reInitTheState();
          return;
        }
      }

      if (userPlacemark == null) {
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Failed to get your location',
          duration: 5,
        );

        reInitTheState();
        return;
      }

      File image = File(imageFile!.path);

      CustomDialogWidget.showLoading();

      var faceRecognitionResponse =
          await _faceRecognitionRepository.recognizeFace(
        image: image,
        subEventId: eventData.identifikaEventId,
      );

      if (faceRecognitionResponse.statusCode != 200) {
        CustomDialogWidget.closeLoading();
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: faceRecognitionResponse.message ?? 'Please try again',
          duration: 5,
        );
        reInitTheState();
        return;
      }

      if (faceRecognitionResponse.result!.verified!) {
        var timezone = tz.local;

        AttendEventAsGuestRequest request = AttendEventAsGuestRequest(
          latitude: userPosition?.latitude ?? 0,
          longitude: userPosition?.longitude ?? 0,
          location: userPlacemark?.properties?.displayName ?? '',
          timeZone: timezone.name,
          faceIdentifier: faceRecognitionResponse.result?.user?.id ?? '',
          eventId: eventData.id ?? '',
          image: image,
        );

        var response = await eventRepository.attendEventAsGuest(
          data: request,
        );

        CustomDialogWidget.closeLoading();

        if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
          var name = faceRecognitionResponse.result?.user?.userName ?? '';
          await CustomDialogWidget.showDialogSuccess(
            description: 'Success attend event as $name',
            duration: 5,
          );
          Get.back();
          Get.back();
        } else {
          await CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: response.message ?? 'Please try again',
            duration: 5,
          );

          reInitTheState();
        }
      } else {
        CustomDialogWidget.closeLoading();

        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Face not verified',
          duration: 5,
        );
        reInitTheState();
      }
    } catch (e) {
      CustomDialogWidget.closeLoading();

      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: e.toString(),
        duration: 5,
      );

      reInitTheState();
    }
  }

  void getUserPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: Platform.isIOS
          ? LocationAccuracy.bestForNavigation
          : LocationAccuracy.best,
    );

    userPosition = position;
  }

  void streamUserPosition() {
    userPositionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: Platform.isAndroid
            ? LocationAccuracy.best
            : LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      userPosition = position;
      if (eventData.type == 1) {
        bool onArea = isOnRadius(
          eventPosition,
          double.parse('${eventData.radius ?? 0}'),
        );

        isOnArea.value = onArea;
      }
    });
  }

  bool isOnRadius(LatLng position, double radius) {
    if (userPosition == null) {
      return false;
    }

    double distance = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    return distance <= radius;
  }

  void cameraInit() async {
    // init camera
    stateCamera.value = const UIState.loading();
    stateLiveness.value = const UIState.loading();

    CameraDescription frontCamera = await _initFrontCamera();

    // scale camera
    _setCameraScalling();

    await Future.delayed(const Duration(seconds: 2));
    stateCamera.value = const UIState.success(
      data: null,
    );

    await _streamCamera(frontCamera);
  }

  Future<void> _streamCamera(CameraDescription frontCamera) async {
    await cameraController.startImageStream(
      (image) async {
        if (isOnDetectionFace) {
          return;
        }

        isOnDetectionFace = true;
        var resFaces = await faceDetectorService.detectFacesFromCameraImage(
          source: image,
          cameraDescription: frontCamera,
          faceDetector: faceDetectorService.faceDetector,
        );

        await Future.delayed(const Duration(milliseconds: 1000));
        isOnDetectionFace = false;

        if (resFaces.length > 1) {
          if (Get.isOverlaysOpen) {
            return;
          }

          await Future.delayed(const Duration(seconds: 1));
          await CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: 'Only one face is allowed',
            buttonOnTap: () {
              Get.back();
            },
            duration: 5,
          );
        }

        if (resFaces.length == 1) {
          bool isMotionRight = _onMotionCheck(
            resFaces.first,
            selectedMotion,
          );

          if (!isMotionRight) {
            return;
          }

          rightMotion++;
          if (rightMotion < 1) {
            return;
          }

          stateLiveness.value = const UIState.success(data: null);
          // stop camera stream
          cameraController.stopImageStream();
          // take picture
          await startCountDown();

          Future.delayed(const Duration(seconds: 5), () {
            onTapTakePicture();
          });
        }
      },
    );
  }

  void onTapTakePicture() async {
    try {
      CustomDialogWidget.showLoading();
      stateTakePicture.value = const UIState.loading();

      XFile? file = await cameraController.takePicture();

      final dir = await getTemporaryDirectory();
      int randomNumber = Random().nextInt(100000);
      final targetPath =
          '${dir.path}/${randomNumber}temp.${FileHelper.getFileExtension(file.name)}';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 50,
        rotate: 0,
      );

      if (result == null) {
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Please try again',
          duration: 5,
        );

        reInitTheState();
        return;
      }

      File fileData = File(result.path);

      List<Face> faces = await faceDetectorService.detectFacesFromImageFile(
        source: fileData,
      );

      CustomDialogWidget.closeLoading();

      if (faces.isEmpty) {
        await CustomDialogWidget.showDialogProblem(
          title: 'Face Not Detected',
          description: 'Please try again',
          duration: 5,
        );

        reInitTheState();
        return;
      }

      if (faces.length > 1) {
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Only one face is allowed',
          duration: 5,
        );

        reInitTheState();
        return;
      }

      stateTakePicture.value = UIState.success(data: file);
      imageFile = file;

      if (faces.length == 1) {
        attendEvent();
      }

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      CustomDialogWidget.closeLoading();
      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: e.toString(),
        duration: 5,
      );

      reInitTheState();
    }
  }

  Future<void> startCountDown() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown.value == 0) {
        timer.cancel();
        return;
      }

      countDown.value--;
    });
  }

  Future<CameraDescription> _initFrontCamera() async {
    var cameras = await availableCameras();
    var frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController.initialize();
    return frontCamera;
  }

  void _setCameraScalling() {
    scaleCamera =
        cameraController.value.aspectRatio * Get.mediaQuery.size.aspectRatio;

    if (scaleCamera < 1) {
      scaleCamera = 1 / scaleCamera;
    }
  }

  void setUpMotionType() {
    Random random = Random();
    int randomNumber = random.nextInt(2);
    selectedMotion = MotionTypeEnum.values[randomNumber];
  }

  bool _onMotionCheck(Face face, MotionTypeEnum selectedMotion) {
    if (selectedMotion == MotionTypeEnum.blink) {
      if ((face.leftEyeOpenProbability ?? 0) > 0.1) return false;
      if ((face.rightEyeOpenProbability ?? 0) > 0.1) return false;
      return true;
    } else {
      var headEulerAngleY = face.headEulerAngleY ?? 0;
      if (headEulerAngleY > 20) return true;
      if (headEulerAngleY < -20) return true;

      return false;
    }
  }

  void setEventDataFromArgs() {
    if (args != null) {
      if (args is EventData) {
        eventData = args;
        eventPosition = LatLng(
          double.parse(eventData.latitude ?? '0'),
          double.parse(eventData.longitude ?? '0'),
        );
      } else {
        Get.back();
      }
    }
  }

  void reInitTheState() {
    stateLiveness.value = const UIState.idle();
    stateTakePicture.value = const UIState.idle();
    countDown.value = 5;
    rightMotion = 0;
    isOnDetectionFace = false;
    setUpMotionType();
    _streamCamera(cameraController.description);
  }

  @override
  void onClose() {
    cameraController.dispose();
    faceDetectorService.faceDetector.close();
    userPositionStream?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    cameraInit();
    setUpMotionType();
    setEventDataFromArgs();
    getUserPosition();
    streamUserPosition();
    super.onInit();
  }
}
