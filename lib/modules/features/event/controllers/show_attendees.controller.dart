import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/models/responses/list_of_attendee.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

enum AttendeesTab {
  checkIn,
  notCheckIn,
}

class ShowAttendeesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ShowAttendeesController get to => Get.find();

  late TabController tabController = TabController(length: 2, vsync: this);

  RxInt selectedIndex = 0.obs;

  Rx<UIState<ParticipantsMeta>> participantsStateCheckin =
      const UIState<ParticipantsMeta>.idle().obs;
  Rx<UIState<ParticipantsMeta>> participantsStateNotCheckin =
      const UIState<ParticipantsMeta>.idle().obs;

  final EventRepository _eventRepository = EventRepository();

  late EventData eventData;
  RxInt totalParticipants = 0.obs;
  RxInt totalCheckIn = 0.obs;
  RxInt totalNotCheckIn = 0.obs;
  RxInt totalGuest = 0.obs;
  RxInt participantsCount = 0.obs;

  Future<void> getEventParticipants({
    required AttendeesTab tab,
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    // Determine which state to update based on the tab
    final participantsState = tab == AttendeesTab.checkIn
        ? participantsStateCheckin
        : participantsStateNotCheckin;

    if (isRefresh) {
      participantsState.value = const UIState<ParticipantsMeta>.loading();
    }

    String status = tab == AttendeesTab.checkIn ? 'attended' : 'not_attended';

    ListOfAttendeeResponse res = await _eventRepository.getEventParticipants(
      id: eventData.id ?? "",
      status: status,
      page: isLoadMore
          ? (participantsState.value.whenOrNull(
              success: (data) => (data.meta?.currentPage ?? 0) + 1,
            ))
          : 1,
      limit: 10,
    );

    if (ApiStatusHelper.isApiSuccess(res.statusCode ?? 0)) {
      _handleTotalParticipants(res);
    }

    if (isLoadMore) {
      var prevData = participantsState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.meta?.participants?.data?.isNotEmpty ?? false) {
        participantsState.value = UIState.success(
          data: (res.meta?.participants ?? ParticipantsMeta()).copyWith(
            data: [
              ...(prevData ?? []),
              ...(res.meta?.participants?.data ?? [])
            ],
          ),
        );
      } else {
        participantsState.value = UIState.success(
          data: (res.meta?.participants ?? ParticipantsMeta()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.meta?.participants?.data?.isNotEmpty ?? false) {
        participantsState.value =
            UIState.success(data: res.meta?.participants ?? ParticipantsMeta());
      } else {
        participantsState.value = const UIState<ParticipantsMeta>.empty();
      }
    }
  }

  void _handleTotalParticipants(ListOfAttendeeResponse res) {
    totalParticipants.value =
        (res.meta?.totalParticipants ?? 0) + (res.meta?.totalGuests ?? 0);
    totalCheckIn.value =
        (res.meta?.totalAttended ?? 0) + (res.meta?.totalGuestsAttended ?? 0);
    totalNotCheckIn.value = (res.meta?.totalGuestsNotAttended ?? 0) +
        (res.meta?.totalNotAttended ?? 0);
    totalGuest.value = res.meta?.totalGuests ?? 0;
    participantsCount.value = res.meta?.totalParticipants ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    eventData = Get.arguments as EventData;
    getEventParticipants(
      isRefresh: true,
      tab: AttendeesTab.checkIn,
    );
    getEventParticipants(
      isRefresh: true,
      tab: AttendeesTab.notCheckIn,
    );
  }
}
