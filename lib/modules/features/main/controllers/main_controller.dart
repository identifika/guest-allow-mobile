import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/event/ui/event_view.dart';
import 'package:guest_allow/modules/features/home/controllers/home.controller.dart';
import 'package:guest_allow/modules/features/home/ui/home_view.dart';
import 'package:guest_allow/modules/features/search/ui/search_view.dart';
import 'package:guest_allow/modules/features/profile/ui/profile_view.dart';

class DataOfDestinations {
  BottomNavigationBarItem item;
  String key;

  DataOfDestinations({
    required this.item,
    required this.key,
  });
}

class MainController extends GetxController {
  static MainController get to => Get.find();

  var currentIndex = 0.obs;

  void changeIndex(int index) {
    if (index == 2) {
      return;
    }
    currentIndex.value = index;
    Get.toNamed(destinations[index].key.toString(), id: 1);
  }

  List<DataOfDestinations> destinations = [
    DataOfDestinations(
      item: const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: "Home",
      ),
      key: MainRoute.home,
    ),
    DataOfDestinations(
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Search",
      ),
      key: MainRoute.search,
    ),
    DataOfDestinations(
      item: const BottomNavigationBarItem(
        icon: Icon(
          Icons.hourglass_empty,
          color: Colors.transparent,
        ),
        label: "",
      ),
      key: MainRoute.createEvent,
    ),
    DataOfDestinations(
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: "Event",
      ),
      key: MainRoute.event,
    ),
    DataOfDestinations(
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profile",
      ),
      key: MainRoute.profile,
    ),
  ];

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == MainRoute.home) {
      return GetPageRoute(
        settings: settings,
        page: () => const HomeView(),
        transition: Transition.fadeIn,
        binding: BindingsBuilder(() {
          Get.put(HomeController());
        }),
      );
    }

    if (settings.name == MainRoute.search) {
      return GetPageRoute(
        settings: settings,
        page: () => const SearchView(),
        transition: Transition.fadeIn,

        // binding: BrowseBinding(),
      );
    }

    if (settings.name == MainRoute.event) {
      return GetPageRoute(
        settings: settings,
        page: () => const EventView(),
        transition: Transition.fadeIn,

        // binding: HistoryBinding(),
      );
    }

    if (settings.name == MainRoute.profile) {
      return GetPageRoute(
        settings: settings,
        page: () => const ProfileView(),
        transition: Transition.fadeIn,

        // binding:
      );
    }

    if (settings.name == MainRoute.createEvent) {
      return null;
    }

    return null;
  }
}
