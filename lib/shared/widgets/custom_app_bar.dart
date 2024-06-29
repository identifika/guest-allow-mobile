import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: MainColor.backgroundColor,
      ),
      backgroundColor: MainColor.backgroundColor,
      toolbarHeight: 0,
      elevation: 0,
    );
  }
}
