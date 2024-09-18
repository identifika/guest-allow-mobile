import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_calendar_event.controller.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class DetailCalendarEventView extends StatelessWidget {
  const DetailCalendarEventView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(DetailCalendarEventController());
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<DetailCalendarEventController>(
          id: 'search',
          builder: (controller) {
            return controller.isSearching.isTrue
                ? TextField(
                    controller: controller.searchController,
                    focusNode: controller.searchFocus,
                    onSubmitted: (value) {
                      controller.getEventCalendar(
                        isRefresh: true,
                        keyword: value,
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    controller.stateType.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  );
          },
        ),
        actions: [
          GetBuilder<DetailCalendarEventController>(
            id: 'search',
            builder: (controller) {
              return Conditional.single(
                context: context,
                conditionBuilder: (context) => controller.isSearching.isTrue,
                widgetBuilder: (context) => IconButton(
                  onPressed: () {
                    controller.isSearching.value = false;
                    controller.searchController.clear();
                    controller.getEventCalendar(
                      isRefresh: true,
                    );
                    controller.update(['search']);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
                fallbackBuilder: (context) => IconButton(
                  onPressed: () {
                    controller.isSearching.value = true;

                    controller.update(['search']);
                    FocusScope.of(context).requestFocus(controller.searchFocus);

                    // focus search
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getEventCalendar(
              isRefresh: true,
              keyword: controller.searchController.text,
            );
          },
          color: MainColor.primary,
          backgroundColor: MainColor.white,
          child: Obx(
            () =>
                controller.eventState.value.whenOrNull(
                  loading: () => ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const CustomShimmerWidget.card(
                        height: 100,
                      );
                    },
                  ),
                  success: (data) {
                    return CustomLoadMore(
                      isFinish: (data.data ?? []).length >= (data.total ?? 0),
                      textBuilder: DefaultLoadMoreTextBuilder.english,
                      onLoadMore: () async {
                        await controller.getEventCalendar(
                          isLoadMore: true,
                          keyword: controller.searchController.text,
                        );
                        if (controller.eventState.value.whenOrNull(
                              success: (data) => data.data?.length ?? 0,
                            ) ==
                            (data.total ?? 0)) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      child: ListView.separated(
                        itemCount: data.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var eventModel = EventModel.fromEventData(
                            data.data?[index].event,
                          );
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                MainRoute.detailEvent,
                                arguments: {
                                  'eventData':
                                      data.data?[index].event?.toJson(),
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 12 : 0,
                              ),
                              child: CardThisMonthEvent(
                                eventModel: eventModel,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 0,
                        ),
                      ),
                    );
                  },
                  empty: (message) => Container(
                    width: 1.sw,
                    alignment: Alignment.topCenter,
                    child: GeneralEmptyErrorWidget(
                      titleText:
                          'Sorry, there is no event data available right now',
                      descText: message,
                      onRefresh: () {
                        controller.getEventCalendar(
                          isRefresh: true,
                          keyword: controller.searchController.text,
                        );
                      },
                    ),
                  ),
                  error: (error) => Center(
                    child: Text(error.toString()),
                  ),
                ) ??
                const SizedBox(),
          ),
        ),
      ),
    );
  }
}
