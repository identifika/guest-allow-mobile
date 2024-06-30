import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_map.controller.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/face_liveness/enum/motion_type_enum.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_controllers/maps.controller.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class AttendEventController extends GetxController {
  static AttendEventController get to => Get.find();
  var args = Get.arguments;

  late EventData eventData;
  UserLocalData? user;

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
    MotionTypeEnum.blink: 'Kedipkan Mata',
    MotionTypeEnum.shakeHead: 'Gelengkan Kepala',
  };

  XFile? imageFile;

  EventRepository eventRepository = EventRepository();

  Position? userPosition;
  Placemark? userPlacemark;
  StreamSubscription<Position>? userPositionStream;
  late MapsController mapsController;
  DetailMapController detailMapController = DetailMapController();
  late LatLng eventPosition;
  RxBool isOnArea = false.obs;

  void attendEvent() async {
    try {
      if (userPosition == null) {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Failed to get your location',
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
          CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: 'You are not in the event area',
          );
          return;
        }
      }

      if (userPlacemark == null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          userPosition!.latitude,
          userPosition!.longitude,
        );

        userPlacemark = placemarks.first;
      }

      if (userPlacemark == null) {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Failed to get your location',
        );
        return;
      }

      var timezone = tz.local;
      var receptionistId = user?.userId ?? '';

      Map<String, dynamic> data = {
        'latitude': userPosition?.latitude,
        'longitude': userPosition?.longitude,
        'location': userPlacemark?.street,
        'receptionist_id': receptionistId,
        'time_zone': timezone.name,
      };

      // XFile to file
      File image = File(imageFile!.path);

      CustomDialogWidget.showLoading();

      var response = await eventRepository.attendEvent(
        id: eventData.id ?? '',
        data: data,
        image: image,
      );

      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
          ApiStatusEnum.success) {
        CustomDialogWidget.showDialogSuccess(
          title: 'Success',
          description: 'You have successfully joined the event',
          buttonOnTap: () {
            Get.back();
          },
        );
      } else {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: response.message ?? 'Please try again',
        );
      }
    } catch (e) {
      log("attendEvent: $e");
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: e.toString(),
      );
    }
  }

  void cancelJoinEvent(String id) async {
    // call cancel join event api
  }

  void getUserPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
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
          CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: 'Only one face is allowed',
            buttonOnTap: () {
              Get.back();
            },
          );
        }

        if (resFaces.isEmpty) {
          if (Get.isOverlaysOpen) {
            return;
          }

          await Future.delayed(const Duration(seconds: 1));
          CustomDialogWidget.showDialogProblem(
            title: 'Failed',
            description: 'Face not detected',
            buttonOnTap: () {
              Get.back();
            },
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
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Please try again',
        );
        return;
      }

      File fileData = File(result.path);

      List<Face> faces = await faceDetectorService.detectFacesFromImageFile(
        source: fileData,
      );

      CustomDialogWidget.closeLoading();

      if (faces.isEmpty) {
        CustomDialogWidget.showDialogProblem(
          title: 'Face Not Detected',
          description: 'Please try again',
        );
        return;
      }

      if (faces.length > 1) {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: 'Only one face is allowed',
        );
        return;
      }

      stateTakePicture.value = UIState.success(data: file);
      imageFile = file;

      if (faces.length == 1) {
        attendEvent();
      }

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      log(e.toString());
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

  Future userLocalData() async {
    try {
      user = await LocalDbService.getUserLocalData();
    } catch (e) {
      log(e.toString());
    }
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
    // streamUserPosition();
    userLocalData();
    super.onInit();
  }
}
