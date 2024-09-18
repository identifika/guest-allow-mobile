import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/splash/controllers/splash.controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: MainColor.backgroundColor,
      body: Center(
        child: Image.asset(
          "assets/img/icon.png",
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
