import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class StepWizardWidget extends StatelessWidget {
  final String? title;
  final bool active;

  const StepWizardWidget({
    super.key,
    this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "$title",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: double.infinity,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: active == true ? MainColor.primary : MainColor.grey,
          ),
        )
      ],
    );
  }
}
