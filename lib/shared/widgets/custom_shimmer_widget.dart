import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum CustomShimmerType {
  avatar,
  card,
}

class CustomShimmerWidget extends StatelessWidget {
  final CustomShimmerType type;
  final double width;
  final double height;
  final double borderRadius;
  final double padding;
  final double margin;

  const CustomShimmerWidget.avatar({
    super.key,
    this.width = 100,
    this.height = 100,
    this.borderRadius = 10,
    this.padding = 10,
    this.margin = 10,
  }) : type = CustomShimmerType.avatar;

  const CustomShimmerWidget.card({
    super.key,
    this.width = 200,
    this.height = 200,
    this.borderRadius = 10,
    this.padding = 10,
    this.margin = 10,
  }) : type = CustomShimmerType.card;

  const CustomShimmerWidget({
    super.key,
    required this.type,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.padding,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
