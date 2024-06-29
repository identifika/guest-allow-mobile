import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/pages/main_page.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_theme.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDbService.initialize();
  await _setTimezone();
  runApp(const MyApp());
}

Future<void> _setTimezone() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  var timezone = tz.getLocation(currentTimeZone);
  tz.setLocalLocation(timezone);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Guest Allow',
          locale: Get.deviceLocale,
          // translations: LocalString(),
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          initialRoute: MainRoute.initial,
          theme: mainTheme,
          defaultTransition: Transition.native,
          getPages: MainPage.main,
        );
      },
    );
  }
}
