import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/auth/modules/forget_password/ui/forgot_password_view.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/controllers/sign_in.controller.dart';
import 'package:guest_allow/modules/features/event/ui/attend_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/bulk_import_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/create_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/detail_calendar_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/edit_guests.view.dart';
import 'package:guest_allow/modules/features/event/ui/edit_receptionist_guests.view.dart';
import 'package:guest_allow/modules/features/event/ui/guest_attend_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/guest_receptionist_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/receive_attendees_view.dart';
import 'package:guest_allow/modules/features/event/ui/select_users_view.dart';
import 'package:guest_allow/modules/features/event/ui/show_all_event_view.dart';
import 'package:guest_allow/modules/features/event/ui/show_attendees_view.dart';
import 'package:guest_allow/modules/features/event/ui/show_receptionist_view.dart';
import 'package:guest_allow/modules/features/face_liveness/view/ui/face_liveness_confirmation_screen.dart';
import 'package:guest_allow/modules/features/face_liveness/view/ui/face_liveness_guide_screen.dart';
import 'package:guest_allow/modules/features/face_liveness/view/ui/face_liveness_take_picture_screen.dart';
import 'package:guest_allow/modules/features/main/controllers/main_controller.dart';
import 'package:guest_allow/modules/features/event/ui/detail_event_view.dart';
import 'package:guest_allow/modules/features/main/ui/main_view.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/ui/sign_in_view.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_up/ui/sign_up_view.dart';
import 'package:guest_allow/modules/features/notifications/ui/notifications_view.dart';
import 'package:guest_allow/modules/features/profile/ui/edit_profile_view.dart';
import 'package:guest_allow/modules/features/splash/ui/views/splash_view.dart';
import 'package:guest_allow/modules/features/test/ui/view/test_view.dart';

abstract class MainPage {
  static final main = [
    /// Setup
    GetPage(
      name: MainRoute.initial,
      page: () => const SplashView(),
    ),

    GetPage(
      name: MainRoute.signIn,
      page: () => const SignInView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignInController());
      }),
    ),

    GetPage(
      name: MainRoute.signUp,
      page: () => const SignUpView(),
    ),

    GetPage(
      name: MainRoute.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: MainRoute.main,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MainController());
      }),
    ),

    GetPage(
      name: MainRoute.detailEvent,
      page: () => const DetailView(),
    ),

    GetPage(
      name: MainRoute.detailEventCalendar,
      page: () => const DetailCalendarEventView(),
    ),

    GetPage(
      name: MainRoute.viewAllEvent,
      page: () => const ShowAllEventView(),
    ),

    GetPage(
      name: MainRoute.createEvent,
      page: () => const CreateEventView(),
    ),

    GetPage(
      name: MainRoute.importEvent,
      page: () => const BulkImportEventView(),
    ),

    GetPage(
      name: MainRoute.test,
      page: () => const TestView(),
    ),

    GetPage(
      name: MainRoute.selectUser,
      page: () => const SelectUsersView(),
    ),

    GetPage(
      name: MainRoute.profileEdit,
      page: () => const EditProfileView(),
    ),

    GetPage(
      name: MainRoute.faceLivenessTakePicture,
      page: () => const FaceLivenessTakePictureScreen(),
    ),
    GetPage(
      name: MainRoute.faceLivenessConfirmation,
      page: () => const FaceLivenessConfirmationScreen(),
    ),
    GetPage(
      name: MainRoute.faceLivenessGuide,
      page: () => const FaceLivenessGuideScreen(),
    ),
    GetPage(
      name: MainRoute.attendEvent,
      page: () => const AttendEventView(),
    ),

    GetPage(
      name: MainRoute.attendEventAsGuest,
      page: () => const GuestAttendEventView(),
    ),

    GetPage(
      name: MainRoute.receiveAttendees,
      page: () => const ReceiveAttendeesView(),
    ),
    GetPage(
      name: MainRoute.receiveAttendeesAsGuest,
      page: () => const GuestReceptionistEventView(),
    ),

    GetPage(
      name: MainRoute.showAttendees,
      page: () => const ShowAttendeesView(),
    ),

    GetPage(
      name: MainRoute.showReceptionists,
      page: () => const ShowReceptionistView(),
    ),

    GetPage(
      name: MainRoute.editGuests,
      page: () => const EditGuestsView(),
    ),

    GetPage(
      name: MainRoute.editReceptionistGuests,
      page: () => const EditReceptionistGuestsView(),
    ),

    GetPage(
      name: MainRoute.notificationsView,
      page: () => const NotificationsView(),
    ),
  ];
}
