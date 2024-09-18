import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/face_liveness/enum/motion_type_enum.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_confirmation_argument.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:path_provider/path_provider.dart';

class FaceLivenessTakePictureController extends GetxController {
  static FaceLivenessTakePictureController get to => Get.find();
  Rx<UIState> stateCamera = const UIState.idle().obs;
  Rx<UIState> stateLiveness = const UIState.idle().obs;

  Rx<UIState<XFile>> stateCapture = const UIState<XFile>.idle().obs;

  /// * Variable
  int rightMotion = 0;
  late CameraController cameraController;
  late MotionTypeEnum selectedMotion;

  late FaceLivenessTakePictureArgument faceLivenessArgument;
  late Function(String error) onErrorLiveness;

  FaceDetectorService faceDetectorService = FaceDetectorService(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
    ),
  );

  bool isOnDetectionFace = false;
  RxInt countDown = 5.obs;

  Map<MotionTypeEnum, String> assetsPath = {
    MotionTypeEnum.blink: AssetConstant.emoticonEyeBlink,
    MotionTypeEnum.shakeHead: AssetConstant.emoticonShakeHead,
  };
  Map<MotionTypeEnum, String> wordings = {
    MotionTypeEnum.blink: 'Blink Your Eyes',
    MotionTypeEnum.shakeHead: 'Shake Your Head',
  };

  late double cameraScale;
  late MotionTypeEnum motionType;

  bool isFaceDetected = false;

  late final FaceDetector _faceDetector;
  XFile? imageFile;

  @override
  void onInit() {
    var argument = Get.arguments;
    if (argument == null) {
      throw (Exception(
        'Terjadi Kesalahan, apakah kamu sudah '
        'passing arguments "FaceLivenessArgument"\n'
        'Saat Pergi ke halaman ini ?\n',
      ));
    }

    if (argument is! FaceLivenessTakePictureArgument) {
      throw (Exception(
        'Terjadi Kesalahan...\n'
        'Hayooo, Argument Harus Pakek model "FaceLivenessArgument" ya...\n'
        'Jangan Pakek Argument yang lain ?\n',
      ));
    }
    faceLivenessArgument = argument;
    onErrorLiveness = argument.onError;
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
      ),
    );
    cameraInit();
    setUpMotionType();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
    _faceDetector.close();
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

  void _setCameraScalling() {
    cameraScale =
        cameraController.value.aspectRatio * Get.mediaQuery.size.aspectRatio;

    if (cameraScale < 1) {
      cameraScale = 1 / cameraScale;
    }
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

  Future<void> startCountDown() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown.value == 0) {
        timer.cancel();
        return;
      }

      countDown.value--;
    });
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
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offNamed(
            MainRoute.faceLivenessConfirmation,
            arguments: FaceLivenessConfirmationArgument(
              faceLivenessArgument: faceLivenessArgument,
              file: File(
                result.path,
              ),
            ),
          );
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

  void reInitTheState() {
    stateLiveness.value = const UIState.idle();
    stateCapture.value = const UIState.idle();
    countDown.value = 5;
    rightMotion = 0;
    isFaceDetected = false;
    setUpMotionType();
    _streamCamera(cameraController.description);
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
}
