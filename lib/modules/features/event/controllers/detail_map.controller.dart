import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class DetailMapController extends GetxController {
  late GoogleMapController googleMapController;
  late CameraPosition cameraPosition;

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void moveCamera(LatLng latLng) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 15,
        ),
      ),
    );
  }

  void setCameraPosition(CameraPosition position) {
    cameraPosition = position;
    update();
  }

  void moveCameraToUserPosition() {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void moveCameraToPosition(LatLng latLng) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 15,
        ),
      ),
    );
  }

  void goToExternalMap(double lat, double long, {String? title}) async {
    final availableMaps = await MapLauncher.installedMaps;

    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: availableMaps.length,
          itemBuilder: (context, index) {
            final map = availableMaps[index];
            return ListTile(
              title: Text(map.mapName),
              onTap: () {
                map.showMarker(
                  coords: Coords(lat, long),
                  title: title ?? 'Event Location',
                );
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }
}
