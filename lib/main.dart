import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/pages/main_page.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_theme.dart';
import 'package:guest_allow/utils/services/deeplink.service.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/services/notification.service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDbService.initialize();

  NotificationService();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _setTimezone();
  await initEnvirontment();
  await _initDeepLink();

  runApp(const MyApp());
}

Future<void> _initDeepLink() async {
  var deepLinkService = DeepLinkService();
  await deepLinkService.init();
}

Future<void> initEnvirontment() async {
  await dotenv.load(fileName: ".env");
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
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
