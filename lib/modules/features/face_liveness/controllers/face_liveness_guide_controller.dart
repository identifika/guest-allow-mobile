import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_guide_argument.dart';
import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';

class FaceLivenessGuideController extends GetxController {
  static FaceLivenessGuideController get to => Get.find();

  List<String> listStep = [];
  int curIndexStep = 0;

  List<String> listInstructions = [
    'Pastikan wajah Anda di dalam bingkai',
    'Ambil foto di tempat dengan pencahayaan yang bagus',
    'Jangan pakai kacamata atau aksesoris lainnya',
    'Fokus pada layar dan ikuti proses pengenalan wajah',
  ];

  late FaceLivenessTakePictureArgument faceLivenessTakePictureArgument;
  @override
  void onInit() {
    super.onInit();
    var resArgument = Get.arguments;
    if (resArgument == null) {
      throw (Exception(
        "Terjadi Kesalahan, apakah kamu sudah "
        "passing arguments --FaceLivenessGuideArgument-- "
        "Saat Pergi ke halaman ini ?",
      ));
    }
    if (resArgument is! FaceLivenessGuideArgument) {
      throw (Exception(
        "Terjadi Kesalahan..."
        "Hayooo, Argument Harus Pakek model --FaceLivenessGuideArgument-- ya..."
        "Jangan Pakek Argument yang lain",
      ));
    }
    listStep = resArgument.steps;
    curIndexStep = resArgument.curIndexSteps;
    faceLivenessTakePictureArgument =
        resArgument.faceLivenessTakePictureArgument;
  }

  void onTapContinue() {
    Get.toNamed(
      MainRoute.faceLivenessTakePicture,
      arguments: faceLivenessTakePictureArgument,
    );
  }
}
