import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/guest_receptionist_event.controller.dart';
import 'package:guest_allow/shared/widgets/circle_button.dart';
import 'package:lottie/lottie.dart';

class GuestReceptionistEventView extends StatelessWidget {
  const GuestReceptionistEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GuestReceptionistEventController());

    return Scaffold(
      body: Obx(
        () =>
            controller.stateCamera.value.whenOrNull(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: MainColor.primary,
                ),
              ),
              success: (data) => Obx(
                () => controller.stateCapture.value.maybeWhen(
                  success: (data) => showCapturedImage(data, context),
                  orElse: () => buildCamera(context),
                ),
              ),
            ) ??
            const SizedBox(),
      ),
    );
  }

  Widget showCapturedImage(XFile imagePath, BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(imagePath.path),
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: _buildAppBar(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCamera(BuildContext context) {
    var controller = GuestReceptionistEventController.to;
    return Stack(
      children: [
        Stack(
          children: [
            _cameraLayout(controller),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: _buildAppBar(context),
                    ),
                  ],
                ),
              ),
            ),
            _livenessWIdget(controller)
          ],
        ),
        // Countdowm
        _countdownWidget(controller),
      ],
    );
  }

  Align _countdownWidget(GuestReceptionistEventController controller) {
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

  Align _livenessWIdget(GuestReceptionistEventController controller) {
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
          orElse: () => GetBuilder<GuestReceptionistEventController>(
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

  Stack _cameraLayout(GuestReceptionistEventController controller) {
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
          scale: controller.cameraScale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.srcOut,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: (Platform.isAndroid)
                  ? EdgeInsets.symmetric(
                      horizontal: 20.w,
                    )
                  : null,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Container(
                    width: 1.sw,
                    height: 1.sh,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(1),
                      // make oval
                      borderRadius: BorderRadius.all(
                        Radius.circular(330.w),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 260.w,
                            height: 360.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              // make oval
                              borderRadius: BorderRadius.all(
                                Radius.circular(330.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildAppBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 14,
              color: MainColor.primary,
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            "Receive Event",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MainColor.white,
            ),
          ),
          CircleButton(
            icon: const Icon(
              Icons.more_horiz,
              color: MainColor.primary,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Show QR Code"),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text("Show Maps"),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      );
}
