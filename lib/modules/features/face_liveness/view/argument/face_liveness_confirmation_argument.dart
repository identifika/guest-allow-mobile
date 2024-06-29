import 'dart:io';

import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';

class FaceLivenessConfirmationArgument {
  final FaceLivenessTakePictureArgument faceLivenessArgument;
  final File file;
  const FaceLivenessConfirmationArgument({
    required this.faceLivenessArgument,
    required this.file,
  });
}
