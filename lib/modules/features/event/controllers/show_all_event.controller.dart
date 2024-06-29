import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/home/repositories/home.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

enum AllEventType {
  popular,
  thisMonth,
}

class ShowAllEventController extends GetxController {
  static ShowAllEventController get to => Get.find();

  var args = Get.arguments;

  final HomeRepository _eventRepository = HomeRepository();

  Rx<UIState<PopularEventResponseMeta>> eventState =
      const UIState<PopularEventResponseMeta>.idle().obs;

  DateTime? selectedDate;

  AllEventType eventType = AllEventType.popular;

  RxBool isSearching = false.obs;
  TextEditingController searchController = TextEditingController();

  Future<void> getPopularEvent({
    bool isLoadMore = false,
    bool isRefresh = false,
    String? keyword,
  }) async {
    if (isRefresh) {
      eventState.value = const UIState<PopularEventResponseMeta>.loading();
    }

    GetPopularEventsResponse res;
    if (eventType == AllEventType.thisMonth) {
      var firstDate = DateTime(selectedDate!.year, selectedDate!.month, 1);
      var lastDate = DateTime(selectedDate!.year, selectedDate!.month + 1, 0);
      res = await _eventRepository.getThisMonthEvent(
        page: isLoadMore
            ? (eventState.value.whenOrNull(
                success: (data) => (data.currentPage ?? 0) + 1,
              ))
            : 1,
        limit: 5,
        startDate: firstDate,
        endDate: lastDate,
        keyword: keyword,
      );
    } else {
      res = await _eventRepository.getPopularEvent(
        page: isLoadMore
            ? (eventState.value.whenOrNull(
                success: (data) => (data.currentPage ?? 0) + 1,
              ))
            : 1,
        limit: 5,
        keyword: keyword,
      );
    }

    if (isLoadMore) {
      var prevData = eventState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.meta?.data?.isNotEmpty ?? false) {
        eventState.value = UIState.success(
            data: (res.meta ?? PopularEventResponseMeta()).copyWith(
          data: [...(prevData ?? []), ...(res.meta?.data ?? [])],
        ));
      } else {
        eventState.value = UIState.success(
          data: (res.meta ?? PopularEventResponseMeta()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.meta?.data?.isNotEmpty ?? false) {
        eventState.value =
            UIState.success(data: res.meta ?? PopularEventResponseMeta());
      } else {
        eventState.value = const UIState<PopularEventResponseMeta>.empty();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    // set date from args
    if (args != null) {
      if (args is DateTime) {
        selectedDate = args;
        eventType = AllEventType.thisMonth;
      }
    }

    getPopularEvent();
  }
}
