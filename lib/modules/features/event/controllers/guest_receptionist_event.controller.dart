import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/face_liveness/enum/motion_type_enum.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/global_models/responses/face_recognition/face_recognition.response.dart';
import 'package:guest_allow/modules/global_models/responses/nominatim_maps/find_place.response.dart';
import 'package:guest_allow/modules/global_repositories/face_recognition.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class GuestReceptionistEventController extends GetxController {
  static GuestReceptionistEventController get to => Get.find();
  var args = Get.arguments;

  final EventRepository _eventRepository = EventRepository();
  final FaceRecognitionRepository _faceRecognitionRepository =
      FaceRecognitionRepository();

  late EventData eventData;
  late Position userPosition;
  late PlaceFeature userAddress;
  late ReceptionistGuest receptionistGuest;

  late CameraController cameraController;
  Rx<UIState> stateCamera = const UIState.idle().obs;
  Rx<UIState> stateLiveness = const UIState.idle().obs;
  Rx<UIState<XFile>> stateCapture = const UIState<XFile>.idle().obs;
  FaceRecognitionResponse? faceRecognitionResponse;

  FaceDetectorService faceDetectorService = FaceDetectorService(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  bool isFaceDetected = false;
  RxInt countDown = 5.obs;
  late MotionTypeEnum motionType;
  late double cameraScale;
  int rightMotion = 0;

  Map<MotionTypeEnum, String> assetsPath = {
    MotionTypeEnum.blink: AssetConstant.emoticonEyeBlink,
    MotionTypeEnum.shakeHead: AssetConstant.emoticonShakeHead,
  };
  Map<MotionTypeEnum, String> wordings = {
    MotionTypeEnum.blink: 'Blink Your Eyes',
    MotionTypeEnum.shakeHead: 'Shake Your Head',
  };

  XFile? imageFile;

  Future<void> setInitialData() async {
    if (args != null) {
      args = args as Map<String, dynamic>;
      if (args.containsKey('eventData')) {
        eventData = args['eventData'];
      } else {
        await CustomDialogWidget.showDialogProblem(
          title: 'Error',
          description: 'Event data not found',
          buttonOnTap: () {
            Get.back();
          },
          textButton: 'Ok',
        );
      }
      if (args.containsKey('position') && args['position'] != null) {
        userPosition = args['position'];
      } else {
        await CustomDialogWidget.showDialogProblem(
          title: 'Error',
          description: 'User position not found',
          buttonOnTap: () {
            Get.back();
          },
          textButton: 'Ok',
        );
      }
      if (args.containsKey('address') && args['address'] != null) {
        userAddress = args['address'];
      } else {
        await CustomDialogWidget.showDialogProblem(
          title: 'Error',
          description: 'User address not found',
          buttonOnTap: () {
            Get.back();
          },
          textButton: 'Ok',
        );
      }
    }
  }

  Future<void> receiveAttendee() async {
    try {
      var timezone = tz.local;

      var identifier = faceRecognitionResponse!.result!.user!.id ?? '';

      Map<String, dynamic> data = {
        'latitude': userPosition.latitude,
        'longitude': userPosition.longitude,
        'location': userAddress.properties?.displayName ?? '',
        'time_zone': timezone.name,
        'face_identifier': identifier,
        'access_code': receptionistGuest.accessCode,
      };

      // XFile to file
      File image = File(imageFile!.path);

      var response = await _eventRepository.receiveAttendeAsReceptionistGuest(
        id: eventData.id ?? '',
        data: data,
        image: image,
      );

      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        await CustomDialogWidget.showDialogSuccess(
          title: 'Success Receive Attendee',
          description:
              '${faceRecognitionResponse!.result!.user!.userName} has been received',
          buttonOnTap: () {
            Get.back();
          },
          duration: 5,
        );
      } else {
        await CustomDialogWidget.showDialogProblem(
          title: 'Failed',
          description: response.message ?? 'Please try again',
          duration: 5,
        );
      }
      reInitTheState();
    } catch (e) {
      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: e.toString(),
      );
      reInitTheState();
    }
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
        if (isFaceDetected) {
          return;
        }

        isFaceDetected = true;
        var resFaces = await faceDetectorService.detectFacesFromCameraImage(
          source: image,
          cameraDescription: frontCamera,
          faceDetector: faceDetectorService.faceDetector,
        );

        await Future.delayed(const Duration(milliseconds: 1000));
        isFaceDetected = false;

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

          return;
        }

        if (resFaces.length == 1) {
          bool isMotionRight = _onMotionCheck(
            resFaces.first,
            motionType,
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
      stateCapture.value = const UIState.loading();

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

      stateCapture.value = UIState.success(data: file);
      imageFile = file;

      if (faces.length == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          recognizeFace();
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      reInitTheState();
      CustomDialogWidget.closeLoading();
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Please try again',
      );
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
    cameraScale =
        cameraController.value.aspectRatio * Get.mediaQuery.size.aspectRatio;

    if (cameraScale < 1) {
      cameraScale = 1 / cameraScale;
    }
  }

  void setUpMotionType() {
    Random random = Random();
    int randomNumber = random.nextInt(2);
    motionType = MotionTypeEnum.values[randomNumber];
  }

  bool _onMotionCheck(Face face, MotionTypeEnum motionType) {
    if (motionType == MotionTypeEnum.blink) {
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

  void reInitTheState() {
    stateLiveness.value = const UIState.idle();
    stateCapture.value = const UIState.idle();
    countDown.value = 5;
    rightMotion = 0;
    isFaceDetected = false;
    setUpMotionType();
    _streamCamera(cameraController.description);
  }

  Future<void> recognizeFace() async {
    if (imageFile == null) {
      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Please take a picture first',
        duration: 5,
      );
      reInitTheState();

      return;
    }

    CustomDialogWidget.showLoading();
    stateCapture.value = const UIState.loading();

    faceRecognitionResponse = await _faceRecognitionRepository.recognizeFace(
      image: File(imageFile!.path),
    );

    if (faceRecognitionResponse!.statusCode != 200) {
      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: faceRecognitionResponse!.message ?? 'Please try again',
        duration: 5,
      );
      reInitTheState();
      return;
    }

    if (faceRecognitionResponse!.result!.verified!) {
      receiveAttendee();
    } else {
      CustomDialogWidget.closeLoading();

      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: 'Face not verified',
        duration: 5,
      );
      reInitTheState();
    }
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    await setInitialData();
    setUpMotionType();
    cameraInit();
  }
}
