import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaceLivenessOverlayWidget extends StatelessWidget {
  final double aspectRatio;
  const FaceLivenessOverlayWidget({super.key, required this.aspectRatio});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          width: double.infinity,
          color: Colors.black.withOpacity(0.7),
        ),
        Expanded(
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.srcOut,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(1),
                  ),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(35.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 160.h,
          width: double.infinity,
          color: Colors.black.withOpacity(0.7),
        ),
      ],
    );
  }
}
