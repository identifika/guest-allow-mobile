import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/models/responses/my_joined_event.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

enum DetailEnumType {
  myOwnEvent,
  receptionist,
  participant,
}

extension DetailEnumTypeExtension on DetailEnumType {
  String get title {
    switch (this) {
      case DetailEnumType.myOwnEvent:
        return 'My Own Event';
      case DetailEnumType.receptionist:
        return 'As Receptionist';
      case DetailEnumType.participant:
        return 'Participating';
      default:
        return '';
    }
  }
}

class DetailCalendarEventController extends GetxController {
  static DetailCalendarEventController get to => Get.find();

  DetailEnumType stateType = DetailEnumType.myOwnEvent;

  var args = Get.arguments;

  final EventRepository _eventRepository = EventRepository();

  DateTime? selectedDate;

  Rx<UIState<MetaMyJoinedEvent>> eventState =
      const UIState<MetaMyJoinedEvent>.idle().obs;

  RxBool isSearching = false.obs;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  @override
  void onInit() {
    super.onInit();
    // set date from args
    if (args != null) {
      if (args is Map) {
        var newArgs = args as Map<String, dynamic>;
        if (newArgs.containsKey('date')) {
          selectedDate = newArgs['date'];
        } else {
          selectedDate = DateTime.now();
        }
        if (newArgs.containsKey('type')) {
          stateType = newArgs['type'];
        }
      }
    }

    getEventCalendar();
  }

  Future<void> getEventCalendar({
    bool isLoadMore = false,
    bool isRefresh = false,
    String? keyword,
  }) async {
    if (isRefresh) {
      eventState.value = const UIState<MetaMyJoinedEvent>.loading();
    }

    MyJoinedEventResponse res;
    var firstDate =
        DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);

    DateTime endDate = firstDate.add(const Duration(days: 1));
    if (stateType == DetailEnumType.myOwnEvent) {
      res = await _eventRepository.myCreatedEvents(
        page: isLoadMore
            ? (eventState.value.whenOrNull(
                success: (data) => (data.currentPage ?? 0) + 1,
              ))
            : 1,
        limit: 5,
        startDate: firstDate,
        endDate: endDate,
        keyword: keyword,
      );
    } else if (stateType == DetailEnumType.participant) {
      res = await _eventRepository.getMyJoinedEvent(
        page: isLoadMore
            ? (eventState.value.whenOrNull(
                success: (data) => (data.currentPage ?? 0) + 1,
              ))
            : 1,
        limit: 5,
        startDate: firstDate,
        endDate: endDate,
        keyword: keyword,
      );
    } else {
      res = await _eventRepository.getMyJoinedEvent(
        page: isLoadMore
            ? (eventState.value.whenOrNull(
                success: (data) => (data.currentPage ?? 0) + 1,
              ))
            : 1,
        limit: 5,
        isReceptionist: true,
        startDate: firstDate,
        endDate: endDate,
        keyword: keyword,
      );
    }

    if (isLoadMore) {
      var prevData = eventState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.data?.data?.isNotEmpty ?? false) {
        eventState.value = UIState.success(
            data: (res.data ?? MetaMyJoinedEvent()).copyWith(
          data: [...(prevData ?? []), ...(res.data?.data ?? [])],
        ));
      } else {
        eventState.value = UIState.success(
          data: (res.data ?? MetaMyJoinedEvent()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.data?.data?.isNotEmpty ?? false) {
        eventState.value =
            UIState.success(data: res.data ?? MetaMyJoinedEvent());
      } else {
        eventState.value = const UIState<MetaMyJoinedEvent>.empty();
      }
    }
  }
}
