import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_calendar_event.controller.dart';
import 'package:guest_allow/modules/features/event/models/responses/each_date_total_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/my_joined_event.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:badges/badges.dart' as badge;

class EventController extends GetxController {
  static EventController get to => Get.find();

  final EventRepository _eventRepository = EventRepository();

  Rx<UIState<List<DatumEventTotal>>> eachDateTotalEventState =
      const UIState<List<DatumEventTotal>>.idle().obs;
  List<DatumEventTotal> eachDateTotalEvent = [];

  Rx<UIState<MetaMyJoinedEvent>> userJoinedEventState =
      const UIState<MetaMyJoinedEvent>.idle().obs;
  Rx<UIState<MetaMyJoinedEvent>> userAsReceptionistState =
      const UIState<MetaMyJoinedEvent>.idle().obs;
  Rx<UIState<MetaMyJoinedEvent>> myEventState =
      const UIState<MetaMyJoinedEvent>.idle().obs;
  // Rx<UIState<Widget>> widgetState = const UIState<Widget>.idle().obs;
  List<Widget> widget = [];

  DateTime selectedDate = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  void changeSelectedDate(DateTime date) async {
    selectedDate = date;
    await Future.wait([
      fetchUserJoinedEvent(date),
      fetchUserAsReceptionist(date),
      fetchMyEvent(date),
    ]);
    widget = buildWidgetList();
    update(['calendar', 'widget']);
  }

  Future<void> fetchUserJoinedEvent(DateTime startDate) async {
    userJoinedEventState.value = const UIState<MetaMyJoinedEvent>.loading();

    DateTime endDate = startDate.add(const Duration(days: 1));

    MyJoinedEventResponse response = await _eventRepository.getMyJoinedEvent(
      startDate: startDate,
      endDate: endDate,
      limit: 1,
    );

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      if (response.data?.data?.isNotEmpty ?? false) {
        userJoinedEventState.value = UIState.success(data: response.data!);
      } else {
        userJoinedEventState.value = const UIState.empty();
      }
    } else {
      userJoinedEventState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  Future<void> fetchUserAsReceptionist(DateTime startDate) async {
    userAsReceptionistState.value = const UIState<MetaMyJoinedEvent>.loading();

    DateTime endDate = startDate.add(const Duration(days: 1));

    MyJoinedEventResponse response = await _eventRepository.getMyJoinedEvent(
      startDate: startDate,
      endDate: endDate,
      limit: 1,
      isReceptionist: true,
    );

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      if (response.data?.data?.isNotEmpty ?? false) {
        userAsReceptionistState.value = UIState.success(data: response.data!);
      } else {
        userAsReceptionistState.value = const UIState.empty();
      }
    } else {
      userAsReceptionistState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  Future<void> fetchMyEvent(DateTime startDate) async {
    myEventState.value = const UIState<MetaMyJoinedEvent>.loading();

    DateTime endDate = startDate.add(const Duration(days: 1));

    MyJoinedEventResponse response = await _eventRepository.myCreatedEvents(
      startDate: startDate,
      endDate: endDate,
      limit: 1,
    );

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      if (response.data?.data?.isNotEmpty ?? false) {
        myEventState.value =
            UIState.success(data: response.data ?? MetaMyJoinedEvent());
      } else {
        myEventState.value = const UIState.empty();
      }
    } else {
      myEventState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  void setDateRange(DateTime date) {
    startDate = date.subtract(Duration(days: date.weekday - 1));
    endDate = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
    fetchEachDateTotalEvent();
  }

  Future<void> fetchEachDateTotalEvent() async {
    eachDateTotalEventState.value =
        const UIState<List<DatumEventTotal>>.loading();

    EachDateTotalEventResponse response =
        await _eventRepository.getEachDateTotalEvent(
      startDate: startDate,
      endDate: endDate,
    );

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      if (response.data?.isNotEmpty ?? false) {
        eachDateTotalEventState.value =
            UIState.success(data: response.data ?? []);
        eachDateTotalEvent = response.data ?? [];
      } else {
        eachDateTotalEventState.value = const UIState.empty();
      }
    } else {
      eachDateTotalEventState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  bool checkIfDateOnList(DateTime date) {
    bool isDateOnList = false;
    for (DatumEventTotal data in eachDateTotalEvent) {
      if (data.date?.day == date.day) {
        isDateOnList = true;
        break;
      }
    }
    return isDateOnList;
  }

  List<Widget> buildWidgetList() {
    List<Widget> widgetList = [];

    if (userJoinedEventState.value.isSuccess()) {
      widgetList.add(_buildUserJoinedEventWidget());
    }
    if (userAsReceptionistState.value.isSuccess()) {
      widgetList.add(_buildUserAsReceptionistWidget());
    }
    if (myEventState.value.isSuccess()) {
      widgetList.add(_buildMyEventWidget());
    }

    if (userJoinedEventState.value.isEmpty()) {
      widgetList.add(_buildUserJoinedEventWidget());
    }
    if (userAsReceptionistState.value.isEmpty()) {
      widgetList.add(_buildUserAsReceptionistWidget());
    }
    if (myEventState.value.isEmpty()) {
      widgetList.add(_buildMyEventWidget());
    }

    return widgetList;
  }

  Widget _buildUserJoinedEventWidget() {
    return Column(
      children: [
        SizedBox(
          height: 16.sp,
        ),
        // Text my event
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () =>
                    userJoinedEventState.value.whenOrNull(
                      success: (data) => badge.Badge(
                        position: badge.BadgePosition.topEnd(end: -20.w),
                        badgeContent: Text(
                          '${data.total ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        badgeStyle: const badge.BadgeStyle(
                          badgeColor: MainColor.primary,
                        ),
                        showBadge: (data.total ?? 0) > 1,
                        child: Text(
                          "My Next Event",
                          style: TextStyle(
                            color: MainColor.blackTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ) ??
                    Text(
                      "My Next Event",
                      style: TextStyle(
                        color: MainColor.blackTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
              ),
              Obx(
                () =>
                    userJoinedEventState.value.whenOrNull(
                      success: (data) => Visibility(
                        visible: (data.total ?? 0) > 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEventCalendar,
                              arguments: {
                                'date': selectedDate,
                                'type': DetailEnumType.participant,
                              },
                            );
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                              color: MainColor.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ) ??
                    const SizedBox(),
              ),
            ],
          ),
        ),
        Obx(
          () =>
              userJoinedEventState.value.whenOrNull(
                loading: () => ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomShimmerWidget.card(
                      height: 200.sp,
                    );
                  },
                ),
                empty: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: const GeneralEmptyErrorWidget(
                    titleText: 'My Next Event',
                    descText:
                        "You haven't joined any events on the selected day. Try finding and joining an event.",
                  ),
                ),
                error: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: GeneralEmptyErrorWidget(
                    titleText: 'My Next Event',
                    descText: message,
                    customUrlImage: AssetConstant.drawError,
                  ),
                ),
                success: (data) {
                  return ListView.builder(
                    itemCount: data.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var eventdata = data.data?[index].event;
                      final eventModel = EventModel.fromEventData(
                        eventdata,
                      );
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEvent,
                              arguments: {
                                'eventData': eventModel.toJson(),
                              },
                            );
                          },
                          child: CardThisMonthEvent(
                            eventModel: eventModel,
                          ),
                        ),
                      );
                    },
                  );
                },
              ) ??
              const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildUserAsReceptionistWidget() {
    return Column(
      children: [
        SizedBox(
          height: 16.sp,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () =>
                    userAsReceptionistState.value.whenOrNull(
                      success: (data) => badge.Badge(
                        position: badge.BadgePosition.topEnd(end: -20.w),
                        badgeContent: Text(
                          '${data.total ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        badgeStyle: const badge.BadgeStyle(
                          badgeColor: MainColor.primary,
                        ),
                        showBadge: (data.total ?? 0) > 1,
                        child: Text(
                          "As Receptionist",
                          style: TextStyle(
                            color: MainColor.blackTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ) ??
                    Text(
                      "As Receptionist",
                      style: TextStyle(
                        color: MainColor.blackTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
              ),
              Obx(
                () =>
                    userAsReceptionistState.value.whenOrNull(
                      success: (data) => Visibility(
                        visible: (data.total ?? 0) > 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEventCalendar,
                              arguments: {
                                'date': selectedDate,
                                'type': DetailEnumType.receptionist,
                              },
                            );
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                              color: MainColor.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ) ??
                    const SizedBox(),
              ),
            ],
          ),
        ),
        Obx(
          () =>
              userAsReceptionistState.value.whenOrNull(
                loading: () => ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomShimmerWidget.card(
                      height: 200.sp,
                    );
                  },
                ),
                empty: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: const GeneralEmptyErrorWidget(
                    titleText: 'As Receptionist',
                    descText:
                        "You haven't been assigned to any events on the selected day.",
                  ),
                ),
                error: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: GeneralEmptyErrorWidget(
                    titleText: 'As Receptionist',
                    descText: message,
                    customUrlImage: AssetConstant.drawError,
                  ),
                ),
                success: (data) {
                  return ListView.builder(
                    itemCount: data.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var eventdata = data.data?[index].event;
                      final eventModel = EventModel.fromEventData(
                        eventdata,
                      );
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEvent,
                              arguments: {
                                'eventData': eventModel.toJson(),
                              },
                            );
                          },
                          child: CardThisMonthEvent(
                            eventModel: eventModel,
                          ),
                        ),
                      );
                    },
                  );
                },
              ) ??
              const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildMyEventWidget() {
    return Column(
      children: [
        SizedBox(
          height: 16.sp,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () =>
                    myEventState.value.whenOrNull(
                      success: (data) => badge.Badge(
                        position: badge.BadgePosition.topEnd(end: -20.w),
                        badgeContent: Text(
                          '${data.total ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        badgeStyle: const badge.BadgeStyle(
                          badgeColor: MainColor.primary,
                        ),
                        showBadge: (data.total ?? 0) > 1,
                        child: Text(
                          "My Own Event",
                          style: TextStyle(
                            color: MainColor.blackTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ) ??
                    Text(
                      "My Own Event",
                      style: TextStyle(
                        color: MainColor.blackTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
              ),
              Obx(
                () =>
                    myEventState.value.whenOrNull(
                      success: (data) => Visibility(
                        visible: (data.total ?? 0) > 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEventCalendar,
                              arguments: {
                                'date': selectedDate,
                                'type': DetailEnumType.myOwnEvent,
                              },
                            );
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                              color: MainColor.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ) ??
                    const SizedBox(),
              ),
            ],
          ),
        ),
        Obx(
          () =>
              myEventState.value.whenOrNull(
                loading: () => ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomShimmerWidget.card(
                      height: 200.sp,
                    );
                  },
                ),
                empty: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: const GeneralEmptyErrorWidget(
                      titleText: 'My Own Event',
                      descText:
                          "You haven't created any events on the selected day. Start by creating a new event."),
                ),
                error: (message) => Container(
                  width: 1.sw,
                  alignment: Alignment.topCenter,
                  child: GeneralEmptyErrorWidget(
                    titleText: 'My Own Event',
                    descText: message,
                    customUrlImage: AssetConstant.drawError,
                  ),
                ),
                success: (data) {
                  return ListView.builder(
                    itemCount: data.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var eventdata = data.data?[index].event;
                      final eventModel = EventModel.fromEventData(
                        eventdata,
                      );
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              MainRoute.detailEvent,
                              arguments: {
                                'eventData': eventModel.toJson(),
                              },
                            );
                          },
                          child: CardThisMonthEvent(
                            eventModel: eventModel,
                          ),
                        ),
                      );
                    },
                  );
                },
              ) ??
              const SizedBox(),
        ),
      ],
    );
  }

  @override
  void onInit() {
    setDateRange(selectedDate);
    changeSelectedDate(selectedDate);

    super.onInit();
  }
}
