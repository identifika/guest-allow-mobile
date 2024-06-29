import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/main/controllers/main_controller.dart';
import 'package:guest_allow/modules/features/main/ui/components/home_nav_bar.dart';
import 'package:guest_allow/shared/widgets/custom_app_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final controller = Get.put(MainController());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(0, 0),
        child: CustomAppBar(),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(MainRoute.createEvent);
          },
          backgroundColor: MainColor.primary,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: MainColor.backgroundColor,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        child: Obx(
          () => HomeNavbar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.changeIndex(index);
            },
            destination: controller.destinations.map((x) => x.item).toList(),
          ),
        ),
      ),
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: MainRoute.home,
        onGenerateRoute: controller.onGenerateRoute,
      ),
    );
  }
}
