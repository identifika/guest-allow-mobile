import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/splash/controllers/splash.controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
