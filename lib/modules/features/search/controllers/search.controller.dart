import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class SearchPageController extends GetxController {
  static SearchPageController get to => Get.find();

  final EventRepository _eventRepository = EventRepository();

  TextEditingController searchController = TextEditingController();

  Rx<UIState<PopularEventResponseMeta>> searchEventState =
      const UIState<PopularEventResponseMeta>.idle().obs;

  Future<void> searchEvent({
    bool isLoadMore = false,
    bool isRefresh = false,
    String? query,
  }) async {
    if (isRefresh) {
      searchEventState.value =
          const UIState<PopularEventResponseMeta>.loading();
    }

    var response = await _eventRepository.getThisMonthEvent(
      page: isLoadMore
          ? (searchEventState.value.whenOrNull(
              success: (data) => (data.currentPage ?? 0) + 1,
            ))
          : 1,
      limit: 10,
      keyword: query,
    );

    if (isLoadMore) {
      var prevData = searchEventState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (response.meta?.data?.isNotEmpty ?? false) {
        searchEventState.value = UIState.success(
            data: (response.meta ?? PopularEventResponseMeta()).copyWith(
          data: [...(prevData ?? []), ...(response.meta?.data ?? [])],
        ));
      } else {
        searchEventState.value = UIState.success(
          data: (response.meta ?? PopularEventResponseMeta()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (response.meta?.data?.isNotEmpty ?? false) {
        searchEventState.value =
            UIState.success(data: response.meta ?? PopularEventResponseMeta());
      } else {
        searchEventState.value =
            const UIState<PopularEventResponseMeta>.empty();
      }
    }
  }

  @override
  void onInit() {
    searchEvent(
      isRefresh: true,
    );
    super.onInit();
  }
}
