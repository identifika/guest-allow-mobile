import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/face_liveness/controllers/face_liveness_take_picture_controller.dart';
import 'package:guest_allow/modules/features/face_liveness/view/components/face_liveness_overlay_widget.dart';
import 'package:guest_allow/utils/enums/ui_state.enum.dart';
import 'package:lottie/lottie.dart';

class FaceLivenessTakePictureScreen extends StatelessWidget {
  const FaceLivenessTakePictureScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(FaceLivenessTakePictureController());
    var controller = FaceLivenessTakePictureController.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftarkan Wajah',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () => ConditionalSwitch.single(
          context: context,
          valueBuilder: (context) => controller.stateCamera.value,
          caseBuilders: {
            UIStateFaceEnum.loading: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
            UIStateFaceEnum.success: (context) => _buildCamera(context),
          },
          fallbackBuilder: (context) => const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildCamera(BuildContext context) {
    var controller = FaceLivenessTakePictureController.to;
    return Stack(
      children: [
        Transform.scale(
          alignment: Alignment.topCenter,
          scale: controller.scaleCamera,
          child: CameraPreview(
            controller.cameraController,
          ),
        ),
        const FaceLivenessOverlayWidget(
          aspectRatio: 9 / 16,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Obx(
            () => ConditionalSwitch.single(
              context: context,
              valueBuilder: (context) => controller.stateLiveness.value,
              caseBuilders: {
                UIStateFaceEnum.success: (context) => Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: GestureDetector(
                        onTap: controller.onTapTakePicture,
                        child: Container(
                          height: 100.h,
                          width: 100.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 4),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 80.h,
                            width: 80.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
              },
              fallbackBuilder: (context) =>
                  GetBuilder<FaceLivenessTakePictureController>(
                      id: 'animation',
                      builder: (state) {
                        String assetPathLottie =
                            state.assetsPath[state.selectedMotion] ?? '';
                        String wording =
                            state.wordings[state.selectedMotion] ?? '';
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LottieBuilder.asset(
                              assetPathLottie,
                              height: 100.h,
                            ),
                            Text(
                              wording,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                          ],
                        );
                      }),
            ),
          ),
        )
      ],
    );
  }
}
