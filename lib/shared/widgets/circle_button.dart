import 'package:flutter/material.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final Function() onTap;
  const CircleButton({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: MainColor.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
