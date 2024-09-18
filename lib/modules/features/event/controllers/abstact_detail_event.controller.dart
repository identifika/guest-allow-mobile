import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/global_repositories/maps.repository.dart';
import 'package:guest_allow/utils/services/face_recognition.service.dart';

abstract class AbstractDetailEventController extends GetxController {
  final EventRepository eventRepository = EventRepository();
  final FaceRecognitionService faceRecognitionService =
      FaceRecognitionService();
  final MapsRepository mapsRepository = MapsRepository();

  AbstractDetailEventController();

  Future<void> getDetailEvent(String id);
  Future<void> joinEvent(String id);
  Future<void> leaveEvent(String id);
  Future<void> attendEvent(String id);
  Future<void> receiveAttendee(String id);
}
