import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_map.controller.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.eventModel,
    required this.position,
  });

  final EventData eventModel;
  final Position position;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GetBuilder<DetailMapController>(
        init: DetailMapController(),
        builder: (state) {
          CameraPosition cameraPosition = CameraPosition(
            target: LatLng(
              eventModel.latitude == null
                  ? position.latitude
                  : double.parse(eventModel.latitude ?? "0.0"),
              eventModel.longitude == null
                  ? position.longitude
                  : double.parse(eventModel.longitude ?? "0.0"),
            ),
            zoom: 15,
          );
          state.setCameraPosition(
            cameraPosition,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 0.25.sh,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (controller) {
                      state.googleMapController = controller;
                    },
                    myLocationEnabled: true,
                    circles: {
                      Circle(
                        circleId: const CircleId("eventLocation"),
                        center: LatLng(
                          double.parse(eventModel.latitude ?? "0.0"),
                          double.parse(eventModel.longitude ?? "0.0"),
                        ),
                        // radius: int to double
                        radius: eventModel.radius?.toDouble() ?? 0.0,
                        fillColor: Colors.blue.withOpacity(0.1),
                        strokeColor: Colors.blue,
                        strokeWidth: 1,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("eventLocation"),
                        position: LatLng(
                          double.parse(eventModel.latitude ?? "0.0"),
                          double.parse(eventModel.longitude ?? "0.0"),
                        ),
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                eventModel.location ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 1.sw,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    state.goToExternalMap(
                      eventModel.latitude == null
                          ? position.latitude
                          : double.parse(eventModel.latitude ?? "0.0"),
                      eventModel.longitude == null
                          ? position.longitude
                          : double.parse(eventModel.longitude ?? "0.0"),
                      title: eventModel.title,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Show in Map",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
