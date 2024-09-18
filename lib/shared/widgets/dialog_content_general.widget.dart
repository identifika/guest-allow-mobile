import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class DialogContentGeneralWidget extends StatefulWidget {
  final VoidCallback? onTapPositiveButton;
  final VoidCallback? onTapNegativeButton;
  final String description;
  final String title;
  final String textPositiveButton;
  final String textNegativeButton;
  final String imagePath;
  final bool barrierDismissible;
  final String type;
  final bool isHorizontal;
  final Color? descColors;
  final int? duration;
  final Widget? customButton;

  const DialogContentGeneralWidget.oneButton({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
    this.onTapPositiveButton,
    required this.textPositiveButton,
    required this.barrierDismissible,
    this.descColors,
    this.duration,
    this.customButton,
  })  : type = 'one-button',
        isHorizontal = true,
        textNegativeButton = '',
        onTapNegativeButton = null;

  const DialogContentGeneralWidget.twoButton({
    super.key,
    required this.imagePath,
    required this.description,
    required this.title,
    this.onTapPositiveButton,
    this.onTapNegativeButton,
    required this.textPositiveButton,
    required this.textNegativeButton,
    required this.barrierDismissible,
    this.isHorizontal = true,
    this.descColors,
    this.duration,
    this.customButton,
  }) : type = 'two-button';

  @override
  State<DialogContentGeneralWidget> createState() =>
      _DialogContentGeneralWidgetState();
}

class _DialogContentGeneralWidgetState
    extends State<DialogContentGeneralWidget> {
  bool isCountdown = false;
  int countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.duration != null) {
      isCountdown = true;
      countdown = widget.duration!;
      startCountdown();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void startCountdown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown == 0) {
          timer.cancel();
          Get.back();
        } else {
          setState(() {
            countdown--;
          });
        }

        if (Get.isDialogOpen == false) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.barrierDismissible,
      child: Column(
        children: [
          Visibility(
            visible: widget.imagePath.isNotEmpty,
            child: Image.asset(
              widget.imagePath,
              height: 128.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Visibility(
            visible: widget.title.isNotEmpty,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Visibility(
            visible: widget.description.isNotEmpty,
            child: Builder(builder: (_) {
              final leng = widget.description.split(" ").length;

              return Text(
                widget.description,
                style: TextStyle(
                  fontSize: leng >= 20 ? 14.sp : 16.sp,
                  color: widget.descColors ?? Colors.black87,
                ),
                textAlign: TextAlign.center,
              );
            }),
          ),
          SizedBox(
            height: 12.h,
          ),
          Visibility(
            visible: widget.type == 'two-button',
            replacement: GestureDetector(
              onTap: widget.onTapPositiveButton,
              child: Container(
                width: 1.sw,
                height: 48,
                decoration: BoxDecoration(
                  color: MainColor.primary,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) => isCountdown,
                    widgetBuilder: (BuildContext context) => Text(
                      '${widget.textPositiveButton} (${countdown.toString()})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    fallbackBuilder: (BuildContext context) => Text(
                      widget.textPositiveButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: widget.isHorizontal
                ? Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onTapPositiveButton,
                          child: Container(
                            width: 1.sw,
                            height: 48,
                            decoration: BoxDecoration(
                              color: MainColor.primary,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Center(
                              child: Text(
                                widget.textPositiveButton,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onTapNegativeButton,
                          child: Container(
                            width: 1.sw,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: MainColor.primary,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.textNegativeButton,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: MainColor.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: widget.onTapPositiveButton,
                        child: Container(
                          width: 1.sw,
                          height: 48,
                          decoration: BoxDecoration(
                            color: MainColor.primary,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Center(
                            child: Text(
                              widget.textPositiveButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      GestureDetector(
                        onTap: widget.onTapNegativeButton,
                        child: Container(
                          width: 1.sw,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: MainColor.primary,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.textNegativeButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MainColor.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (widget.customButton != null)
            Column(
              children: [
                SizedBox(
                  height: 12.h,
                ),
                widget.customButton ?? const SizedBox(),
              ],
            ),
        ],
      ),
    );
  }
}
