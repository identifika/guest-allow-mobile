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
        title: 'Lokasi Tidak Aktif',
        description: 'Silahkan aktifkan lokasi anda terlebih dahulu',
        buttonOnTap: () {
          Geolocator.openLocationSettings();
        },
        textButton: 'Aktifkan Lokasi',
      );

      return;
    }

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      CustomDialogWidget.showDialogProblem(
        title: 'Lokasi Tidak Aktif',
        description: 'Silahkan aktifkan lokasi anda terlebih dahulu',
        buttonOnTap: () {
          Geolocator.openAppSettings();
        },
        textButton: 'Aktifkan Lokasi',
      );

      return;
    }
  }
}
