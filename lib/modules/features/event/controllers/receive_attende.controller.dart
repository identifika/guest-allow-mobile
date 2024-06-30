import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';

class ReceiveAttendeController extends GetxController {
  static ReceiveAttendeController get to => Get.find();
  final EventRepository _eventRepository = EventRepository();
}
