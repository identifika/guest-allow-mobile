import 'dart:io';

import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_confirmation_argument.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';

class FaceLivenessConfirmationController extends GetxController {
  static FaceLivenessConfirmationController get to => Get.find();
  late FaceLivenessTakePictureArgument faceLivenessArgument;
  late File resultImage;

  @override
  void onInit() {
    var argument = Get.arguments;
    if (argument == null) {
      throw (Exception(
        'Terjadi Kesalahan, apakah kamu sudah '
        'passing arguments "FaceLivenessConfirmationArgument"\n'
        'Saat Pergi ke halaman ini ?\n',
      ));
    }

    if (argument is! FaceLivenessConfirmationArgument) {
      throw (Exception(
        'Terjadi Kesalahan...\n'
        'Hayooo, Argument Harus Pakek model "FaceLivenessConfirmationArgument" ya...\n'
        'Jangan Pakek Argument yang lain ?\n',
      ));
    }
    faceLivenessArgument = argument.faceLivenessArgument;
    resultImage = argument.file;
    super.onInit();
  }

  void onBack() {
    Get.offNamed(
      MainRoute.faceLivenessTakePicture,
      arguments: faceLivenessArgument,
    );
  }
}
