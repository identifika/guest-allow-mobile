import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/face_liveness/controllers/face_liveness_take_picture_controller.dart';
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
          'Face Registration',
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
        () =>
            controller.stateCamera.value.whenOrNull(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: MainColor.primary,
                ),
              ),
              success: (data) => buildCamera(context),
            ) ??
            const SizedBox(),
      ),
    );
  }

  Widget buildCamera(BuildContext context) {
    var controller = FaceLivenessTakePictureController.to;
    return Stack(
      children: [
        Stack(
          children: [_cameraLayout(controller), _livenessWIdget(controller)],
        ),
        // Countdowm
        _countdownWidget(controller),
      ],
    );
  }

  Align _countdownWidget(FaceLivenessTakePictureController controller) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(
        () => controller.stateLiveness.value.maybeWhen(
          success: (data) => Obx(
            () => controller.countDown.value > 0
                ? Container(
                    width: 1.sw,
                    height: 1.sh,
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Camera will take of your face in",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            controller.countDown.value.toString(),
                            style: TextStyle(
                              fontSize: 58.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }

  Align _livenessWIdget(FaceLivenessTakePictureController controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => controller.stateLiveness.value.maybeWhen(
          success: (data) => Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: GestureDetector(
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
          orElse: () => GetBuilder<FaceLivenessTakePictureController>(
              id: 'animation',
              builder: (state) {
                String assetPathLottie =
                    state.assetsPath[state.motionType] ?? '';
                String wording = state.wordings[state.motionType] ?? '';
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
    );
  }

  Stack _cameraLayout(FaceLivenessTakePictureController controller) {
    return Stack(
      children: [
        Transform.scale(
          alignment: Alignment.topCenter,
          scale: controller.cameraScale,
          child: CameraPreview(
            controller.cameraController,
          ),
        ),
        Transform.scale(
          alignment: Alignment.topCenter,
          scale: controller.cameraScale,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: OvalOverlay(),
          ),
        ),
        Positioned(
          bottom: 160.h,
          left: 0,
          right: 0,
          child: Text(
            "Please put your face in the oval area",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class OvalOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..blendMode = BlendMode.dstOut;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final oval = Rect.fromCenter(
      center: Offset(size.width / 2, (size.height / 2) - 120),
      width: 280.w,
      height: 360.h,
    );

    final path = Path()
      ..addRect(rect)
      ..addOval(oval)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
