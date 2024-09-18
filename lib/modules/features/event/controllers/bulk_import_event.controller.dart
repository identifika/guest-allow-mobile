import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/drawer_content_choose_file_widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:url_launcher/url_launcher.dart';

class BulkImportEventController extends GetxController {
  static BulkImportEventController get to => Get.find();

  final EventRepository _eventRepository = EventRepository();

  File? selectedFile;
  String? nameFile;

  void setSelectedFile(File file) {
    selectedFile = file;
    update();
  }

  void removeSelectedFile() {
    selectedFile = null;
    update();
  }

  void downloadTemplate() async {
    const url =
        'https://docs.google.com/spreadsheets/d/1nZzUGKD7s1Nr08aaKxJcoO5HTKk1h1CRtr_3HHq-Dcw/edit?usp=sharing';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool validateXlsxFile(File file) {
    if (!file.path.endsWith('.xlsx') && !file.path.endsWith('.xls')) {
      Get.snackbar(
        'Error',
        'The file must be in .xlsx or .xls format',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void selectFile() async {
    var file = await showModalBottomSheet<File?>(
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
                  SourceFileEnum.storage,
                ],
                allowedExtensionForPickFromStorage: [
                  'xls',
                  'xlsx',
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (file != null) {
      if (validateXlsxFile(file)) {
        nameFile = file.path.split('/').last;
        setSelectedFile(file);
      }
    }
  }

  void askUploadFile() {
    CustomDialogWidget.showDialogChoice(
      description: 'Apakah Anda yakin ingin mengunggah file ini?',
      onTapPositiveButton: () {
        Get.back();
        uploadFile();
      },
      onTapNegativeButton: () {
        Get.back();
      },
    );
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      Get.snackbar(
        'Error',
        'Please select a file first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      CustomDialogWidget.showLoading();

      var response = await _eventRepository.importEvent(file: selectedFile!);

      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        CustomDialogWidget.showDialogSuccess(
          description: 'File uploaded successfully',
        );
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem();
    }
  }
}
