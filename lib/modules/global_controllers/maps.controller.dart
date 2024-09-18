import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';

class MapsController extends GetxController {
  static MapsController get to => Get.find();

  late Position _userPosition;

  Position get userPosition => _userPosition;

  void setUserPosition(Position position) {
    _userPosition = position;
    update();
  }

  Future<void> getUserPosition() async {
    await askPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: Platform.isIOS
          ? LocationAccuracy.bestForNavigation
          : LocationAccuracy.best,
    );
    setUserPosition(position);
  }

  Future<void> askPermission() async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      CustomDialogWidget.showDialogProblem(
        title: 'Your location service is disabled',
        description: 'Please enable location service',
        buttonOnTap: () {
          Geolocator.openLocationSettings();
        },
        textButton: 'Enable Location',
      );

      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      await CustomDialogWidget.showDialogProblem(
        title: 'Location Permission Is Denied',
        description: 'Please permit the location permission',
        buttonOnTap: () async {
          Get.back();
          permission = await Geolocator.requestPermission();
        },
        textButton: 'Permit',
      );

      return;
    }
  }
}
