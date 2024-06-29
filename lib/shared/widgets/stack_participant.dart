import 'package:flutter/material.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';

class StackParticipant extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;
  final double positionText;
  final List<UserModel>? createdBy;
  final int? totalParticipant;

  const StackParticipant({
    required this.fontSize,
    required this.width,
    required this.height,
    required this.positionText,
    this.createdBy,
    this.totalParticipant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: createdBy?.isNotEmpty ?? false,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          for (int i = 0; i < (createdBy ?? []).length; i++)
            Positioned(
              left: i * 14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  createdBy?[i].photo ?? "",
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: MainColor.greyTextColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: MainColor.white,
                          size: width / 1.5,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: MainColor.greyTextColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Positioned(
            left: positionText,
            child: Text(
              "+$totalParticipant participant",
              style: TextStyle(
                color: MainColor.primary,
                fontSize: fontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
