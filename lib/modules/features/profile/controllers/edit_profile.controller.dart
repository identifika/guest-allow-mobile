import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/profile/repositories/profile.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/drawer_content_choose_file_widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/face_recognition.service.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';

class EditProfileController extends GetxController {
  static EditProfileController get to => Get.find();

  TextEditingController nameController = TextEditingController();

  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();

  final ProfileRepository _profileRepository = ProfileRepository();

  File? selectedImage;

  UserLocalData? userLocalData;

  void enrollFace() {
    _faceRecognitionService.enrollFace();
  }

  void selectImage() async {
    var image = await showModalBottomSheet<File?>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih File',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: const DrawerContentChooseFileWidget(
                sourceFiles: [
                  SourceFileEnum.gallery,
                  SourceFileEnum.camera,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (image != null) {
      selectedImage = image;
      update(['image']);
    }
  }

  void confirmation() {
    CustomDialogWidget.showDialogChoice(
        title: 'Update Confimation',
        description: 'Are you sure you want to update your data?',
        onTapPositiveButton: () {
          Get.back();
          updateUser();
        },
        onTapNegativeButton: () {
          Get.back();
        });
  }

  Future<void> updateUser() async {
    try {
      CustomDialogWidget.showLoading();

      var response = await _profileRepository.updateUser(
        name: nameController.text,
        image: selectedImage,
      );
      CustomDialogWidget.closeLoading();
      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        log(response.meta?.name ?? "kosngog");
        await LocalDbService.db.writeTxn(() async {
          userLocalData?.name = response.meta?.name ?? "";
          userLocalData?.photo = response.meta?.photo ?? "";
          await LocalDbService.db.userLocalDatas.put(userLocalData!);
        });

        await CustomDialogWidget.showDialogSuccess(
          title: 'Update Success',
          description: 'Your data is successfully updated!',
          duration: 5,
        );

        Get.back();
      }
    } catch (e) {
      await CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: e.toString(),
      );
    }
  }

  @override
  void onInit() {
    userLocalData = LocalDbService.getUserLocalDataSync();
    nameController.text = userLocalData?.name ?? "";
    super.onInit();
  }
}
