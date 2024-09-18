import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/shared/widgets/dialog_content_general.widget.dart';
import 'package:guest_allow/shared/widgets/dialog_content_loading.widget.dart';

class CustomDialogWidget {
  static bool showLoading({
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      DialogContentLoadingWidget(
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
    );

    return true;
  }

  static bool closeLoading() {
    Get.back();
    return false;
  }

  static Future<T?> showDialogGeneral<T>({
    double margin = 40,
    double radius = 14,
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    ScrollPhysics? physics,
    int? duration,
  }) async {
    return await Get.dialog<T>(
      PopScope(
        canPop: true,
        child: Center(
          child: SingleChildScrollView(
            physics: physics,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(margin),
                padding: padding,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius.r),
                ),
                child: content ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> showDialogProblem<T>({
    VoidCallback? buttonOnTap,
    String description = 'There is a problem, please try again',
    String title = 'Upss, something went wrong',
    String textButton = 'Close',
    bool barrierDismissible = true,
    int? duration,
  }) async {
    return await showDialogGeneral<T>(
      barrierDismissible: barrierDismissible,
      content: DialogContentGeneralWidget.oneButton(
        barrierDismissible: barrierDismissible,
        onTapPositiveButton: buttonOnTap ??
            () {
              Get.back();
            },
        description: description,
        title: title,
        textPositiveButton: textButton,
        imagePath: AssetConstant.drawDialogError,
        duration: duration,
      ),
    );
  }

  static Future<T?> showDialogSuccess<T>({
    VoidCallback? buttonOnTap,
    String description = '',
    String title = 'Success',
    String textButton = 'Close',
    bool barrierDismissible = true,
    Color? descColor,
    int? duration,
  }) async {
    return await showDialogGeneral<T>(
      barrierDismissible: barrierDismissible,
      content: DialogContentGeneralWidget.oneButton(
        barrierDismissible: barrierDismissible,
        descColors: descColor,
        onTapPositiveButton: buttonOnTap ??
            () {
              Get.back();
            },
        description: description,
        title: title,
        textPositiveButton: textButton,
        imagePath: AssetConstant.drawDialogSuccess,
        duration: duration,
      ),
    );
  }

  static Future<T?> showDialogChoice<T>({
    final VoidCallback? onTapPositiveButton,
    final VoidCallback? onTapNegativeButton,
    required final String description,
    final String title = '',
    final String textPositiveButton = 'Ok',
    final String textNegativeButton = 'Close',
    final String imagePath = AssetConstant.drawDialogQuestion,
    final Widget? customButton,
    bool barrierDismissible = true,
    bool isHorizontal = true,
    Color? descColor,
  }) async {
    return await showDialogGeneral<T>(
      barrierDismissible: barrierDismissible,
      content: DialogContentGeneralWidget.twoButton(
        barrierDismissible: barrierDismissible,
        imagePath: imagePath,
        textPositiveButton: textPositiveButton,
        textNegativeButton: textNegativeButton,
        description: description,
        title: title,
        onTapPositiveButton: onTapPositiveButton,
        onTapNegativeButton: onTapNegativeButton,
        isHorizontal: isHorizontal,
        descColors: descColor,
        customButton: customButton,
      ),
    );
  }

  static void showDialogInput(
      {required String title,
      required String description,
      required String textNegativeButton,
      required String textPositiveButton,
      required TextEditingController controller,
      required void Function() onTapNegativeButton,
      required Null Function() onTapPositiveButton}) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        children: [
          Text(description),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      cancel: TextButton(
        onPressed: onTapNegativeButton,
        child: Text(textNegativeButton),
      ),
      confirm: TextButton(
        onPressed: onTapPositiveButton,
        child: Text(
          textPositiveButton,
        ),
      ),
      onConfirm: onTapPositiveButton,
      onCancel: onTapNegativeButton,
    );
  }
}
