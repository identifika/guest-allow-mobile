import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/face_liveness/controllers/face_liveness_confirmation_controller.dart';
import 'package:guest_allow/modules/features/face_liveness/extensions/itteration_ext.dart';
import 'package:guest_allow/modules/features/face_liveness/view/ui/step_wizard_widget.dart';

class FaceLivenessConfirmationScreen extends StatelessWidget {
  const FaceLivenessConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(FaceLivenessConfirmationController());
    var controller = FaceLivenessConfirmationController.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konfirmasi Foto',
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
            controller.onBack();
          },
        ),
        bottom: _buildBottomAppBarWidget(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: 1.sw - 32,
              height: 1.sh / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.r),
                image: DecorationImage(
                  image: FileImage(
                    controller.resultImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              'Hasil Foto Wajah',
              style: TextStyle(
                color: Colors.black,
                fontSize: 21.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Jika kamu merasa foto ini kurang bagus kamu\ndapat mengulangi proses pengambilan gambar kembali',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 32.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.onBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.danger,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 0.w,
                      ),
                    ),
                    child: Text(
                      'Ulangi Foto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.faceLivenessArgument.onConfirmFile(
                        controller.resultImage,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 0.w,
                      ),
                    ),
                    child: Text(
                      'Konfirmasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  PreferredSize _buildBottomAppBarWidget() {
    var controller = FaceLivenessConfirmationController.to;
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
