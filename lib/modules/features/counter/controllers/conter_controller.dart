import 'package:get/get.dart';

class ConterController extends GetxController {
  static ConterController get to => Get.find();

  var count = 0.obs;
  increment() => count++;
}
