import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';

class SplashController extends GetxController {
  Future<void> checkAuth() async {
    // Check if user is authenticated
    // If authenticated, navigate to home page
    // If not authenticated, navigate to sign in page
    var userData = await LocalDbService.getUserLocalData();

    if (userData != null) {
      Future.delayed(
        const Duration(seconds: 2),
        () => Get.offAllNamed(MainRoute.main),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => Get.offAllNamed(MainRoute.signIn),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }
}
