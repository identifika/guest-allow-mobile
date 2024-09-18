import 'dart:io';

import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_guide_argument.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';
import 'package:guest_allow/modules/global_repositories/face_recognition.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/face_detector.service.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';

class FaceRecognitionService {
  FaceDetectorService faceDetectorService = FaceDetectorService();
  FaceRecognitionRepository faceRecognitionRepository =
      FaceRecognitionRepository();

  Future<File?> cropFaces(File selectedImage) async {
    var cropFaces = await faceDetectorService.cropFacesFromImageFile(
      file: selectedImage,
      useBakeOrientation: true,
    );

    File? resultOfFaceOnly;

    if (cropFaces.$2.isNotEmpty && cropFaces.$1.isNotEmpty) {
      resultOfFaceOnly = cropFaces.$1.first;
    }

    if (resultOfFaceOnly == null) {
      CustomDialogWidget.showDialogProblem(
        title: 'Wajah Tidak Terdeteksi',
        description: 'Mohon pilih foto yang jelas dan terang',
      );
      return null;
    }

    File fileDataOfFaceOnly = File(resultOfFaceOnly.path);

    return fileDataOfFaceOnly;
  }

  Future<void> enrollFace() async {
    Get.toNamed(
      MainRoute.faceLivenessGuide,
      arguments: FaceLivenessGuideArgument(
        steps: [
          'Take Picture',
          'Data Confirmation',
          'Face Verification',
        ],
        curIndexSteps: 0,
        faceLivenessTakePictureArgument: FaceLivenessTakePictureArgument(
          onError: (error) {
            Map<String, String> errorDesc = {
              'face-not-found': 'Wajah tidak terdeteksi',
              'multiple-face': 'Wajah ada lebih dari satu',
            };
            CustomDialogWidget.showDialogProblem(
              title: 'Gagal Mengambil Foto',
              description: errorDesc[error] ?? 'Terjadi Kesalahan',
            );
          },
          onConfirmFile: (file) async {
            Get.close(1);
            await registerFace(file);
          },
        ),
      ),
    );
  }

  Future<void> registerFace(File file) async {
    try {
      CustomDialogWidget.showLoading();

      var croppedFile = await cropFaces(file);
      if (croppedFile == null) {
        CustomDialogWidget.closeLoading();
        return;
      }

      var response = await faceRecognitionRepository.enrollFace(
        image: croppedFile,
      );

      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        var user = await LocalDbService.getUserLocalData();
        user?.faceIdentifier = (response.meta ?? '') as String;

        await LocalDbService.setUserLocalData(user!);

        await CustomDialogWidget.showDialogSuccess(
          title: 'Success to Register Face',
          description: 'Your face is registered successfully',
          duration: 5,
        );

        Get.back();
      } else {
        CustomDialogWidget.showDialogProblem(
          title: 'Failed to Register Face',
          description: response.message ?? 'Please try again',
        );
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        title: 'Failed to Register Face',
        description: e.toString(),
      );
    }
  }
}
