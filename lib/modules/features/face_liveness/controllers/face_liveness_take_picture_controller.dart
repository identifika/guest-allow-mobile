import 'dart:developer' as dev;
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
import 'package:guest_allow/utils/enums/ui_state.enum.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:path_provider/path_provider.dart';

class FaceLivenessTakePictureController extends GetxController {
  static FaceLivenessTakePictureController get to => Get.find();
  Rx<UIStateFaceEnum> stateCamera =
      Rx<UIStateFaceEnum>(UIStateFaceEnum.loading);
  Rx<UIStateFaceEnum> stateLiveness =
      Rx<UIStateFaceEnum>(UIStateFaceEnum.loading);

  /// * Variable
  int rightMotion = 0;
  late CameraController cameraController;
  late MotionTypeEnum selectedMotion;
  late double scaleCamera;

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

  Map<MotionTypeEnum, String> assetsPath = {
    MotionTypeEnum.blink: AssetConstant.emoticonEyeBlink,
    MotionTypeEnum.shakeHead: AssetConstant.emoticonShakeHead,
  };
  Map<MotionTypeEnum, String> wordings = {
    MotionTypeEnum.blink: 'Kedipkan Mata',
    MotionTypeEnum.shakeHead: 'Gelengkan Kepala',
  };

  late final FaceDetector _faceDetector;

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
    var randomIndex = Random().nextInt(2);
    selectedMotion = MotionTypeEnum.values[randomIndex];
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
      ),
    );
    initCamera();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
    _faceDetector.close();
  }

  void initCamera() async {
    stateCamera.value = UIStateFaceEnum.loading;
    stateLiveness.value = UIStateFaceEnum.loading;

    var cameras = await availableCameras();
    var frontCamera = cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: (Platform.isAndroid)
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await cameraController.initialize();

    scaleCamera =
        (cameraController.value.aspectRatio * Get.mediaQuery.size.aspectRatio);
    // to prevent scaling down, invert the value
    if (scaleCamera < 1) scaleCamera = 1 / scaleCamera;

    await Future.delayed(const Duration(seconds: 3));
    stateCamera.value = UIStateFaceEnum.success;
    await cameraController.startImageStream(
      (image) async {
        if (isOnDetectionFace) return;
        isOnDetectionFace = true;
        var resFaces = await faceDetectorService.detectFacesFromCameraImage(
          source: image,
          cameraDescription: frontCamera,
          faceDetector: _faceDetector,
        );

        await Future.delayed(const Duration(milliseconds: 1000));
        isOnDetectionFace = false;
        // return;
        if (resFaces.length > 1) {
          if (Get.isOverlaysOpen) return;
          await Future.delayed(const Duration(seconds: 1));

          CustomDialogWidget.showDialogProblem(
            title: 'Wajah Terlalu Banyak',
            description:
                'Wajah yang terdeteksi terlalu banyak, silakan coba lagi',
          );
          selectedMotion = MotionTypeEnum.values[Random().nextInt(3)];
          stateLiveness.value = UIStateFaceEnum.idle;
          update(['animation']);

          return;
        }
        if (resFaces.isEmpty) {
          if (Get.isOverlaysOpen) return;
          await Future.delayed(const Duration(seconds: 1));

          CustomDialogWidget.showDialogProblem(
            title: 'Wajah Tidak Terdeteksi',
            description: 'Pastikan wajah Anda berada di dalam bingkai',
          );
          selectedMotion = MotionTypeEnum.values[Random().nextInt(3)];
          stateLiveness.value = UIStateFaceEnum.idle;
          update(['animation']);
          return;
        }
        bool isMotionRight = _onMotionCheck(resFaces.first);
        if (!isMotionRight) return;
        rightMotion++;
        dev.log(rightMotion.toString(), name: 'right-motion');
        if (rightMotion < 1) return;
        stateLiveness.value = UIStateFaceEnum.success;
        Future.delayed(const Duration(milliseconds: 2000), () {
          onTapTakePicture();
        });
        dev.log(rightMotion.toString());
      },
    );
  }

  void onTapTakePicture() async {
    try {
      // await cameraController.stopImageStream();
      // await Future.delayed(const Duration(milliseconds: 1000));
      // await cameraController.pausePreview();
      CustomDialogWidget.showLoading();
      XFile? file = await cameraController.takePicture();

      final dir = await getTemporaryDirectory();
      int randomNumber = Random().nextInt(100000);
      final targetPath =
          '${dir.absolute.path}/${randomNumber}temp.${FileHelper.getFileExtension(file.name)}';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minWidth: 680,
        minHeight: 680,
        quality: 50,
        rotate: 0,
      );

      if (result == null) {
        CustomDialogWidget.showDialogProblem(
          title: 'Terjadi Kesalahan',
          description: 'Silakan coba lagi',
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
          title: 'Wajah Tidak Terdeteksi'.tr,
          description: 'Pastikan wajah Anda berada di dalam bingkai'.tr,
        );

        initCamera();

        return;
      }

      if (faces.length > 1) {
        CustomDialogWidget.showDialogProblem(
          title: 'Wajah Terlalu Banyak'.tr,
          description:
              'Wajah yang terdeteksi terlalu banyak, silakan coba lagi'.tr,
        );

        initCamera();

        return;
      }

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
    } catch (e) {
      dev.log(e.toString());
    }
  }

  bool _onMotionCheck(Face face) {
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
}

// 089501929242