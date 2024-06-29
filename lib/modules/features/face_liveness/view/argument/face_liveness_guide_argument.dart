import 'package:guest_allow/modules/features/face_liveness/view/argument/face_liveness_take_picture_argument.dart';

class FaceLivenessGuideArgument {
  final List<String> steps;

  /// Cur Index Step Akan membuat step active dengan berwarna primary
  ///
  /// Misal ada 3 step, curIndex = 2, maka index 0,1,2 akan active
  ///
  /// Misal ada 3 step, curIndex = 1, maka index 0,1 akan active
  final int curIndexSteps;
  final FaceLivenessTakePictureArgument faceLivenessTakePictureArgument;

  /// ![](https://github-production-user-asset-6210df.s3.amazonaws.com/65402864/247897749-522f16b2-9e54-4f62-95d5-91946b30ba33.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230622%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230622T100700Z&X-Amz-Expires=300&X-Amz-Signature=5e0295fea98a013e172005b8957c28670785695f5ad68f0eed1908e4ca3987fe&X-Amz-SignedHeaders=host&actor_id=65402864&key_id=0&repo_id=646669594)
  FaceLivenessGuideArgument({
    required this.steps,
    required this.curIndexSteps,
    required this.faceLivenessTakePictureArgument,
  });
}
