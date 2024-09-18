import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/face_liveness/controllers/face_liveness_guide_controller.dart';
import 'package:guest_allow/modules/features/face_liveness/extensions/itteration_ext.dart';
import 'package:guest_allow/modules/features/face_liveness/view/ui/step_wizard_widget.dart';

class FaceLivenessGuideScreen extends StatelessWidget {
  const FaceLivenessGuideScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(FaceLivenessGuideController());
    var controller = FaceLivenessGuideController.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enroll Face',
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
        bottom: _buildBottomAppBarWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    AssetConstant.tutorial,
                    height: 0.48.sh,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  'Face Registration For Facial Recognition Features',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                  ),
                  child: Text(
                    'Make sure your face is visible in the frame and follow the facial recognition process',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x14111111),
              offset: Offset(0, -2),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
          color: Color(0xffffffff),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 30.h),
              child: ElevatedButton(
                onPressed: () {
                  controller.onTapContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.primary,
                  minimumSize: Size(1.sw, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// * Build Step Yang ada dibawah app bar
  PreferredSize _buildBottomAppBarWidget() {
    var controller = FaceLivenessGuideController.to;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 16.w,
        ),
        child: Row(
            children: controller.listStep
                .extMapIndexed(
                  (e, i) => Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: StepWizardWidget(
                            active: i <= controller.curIndexStep,
                            title: e,
                          ),
                        ),
                        SizedBox(
                          width: (i == controller.listStep.length) ? 0 : 10.w,
                        ),
                      ],
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }
}
