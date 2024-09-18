import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/show_attendees.controller.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';
import 'package:guest_allow/shared/widgets/insight_card_widget.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';

class ShowAttendeesView extends StatelessWidget {
  const ShowAttendeesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShowAttendeesController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Attendees',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => InsightCard(
                controller: controller.tabController,
                onTabChanged: (i) {
                  controller.selectedIndex.value = i;
                  // controller.getEventParticipants(
                  //   tab:
                  //       i == 0 ? AttendeesTab.checkIn : AttendeesTab.notCheckIn,
                  //   isRefresh: true,
                  // );
                },
                title: 'Attendees',
                subtitle:
                    '${controller.totalParticipants.value} Total Attendees',
                subtitle2:
                    '(${controller.totalGuest.value} Guest, ${controller.participantsCount.value} Participants)',
                labels: [
                  '${controller.totalCheckIn.value} Check In',
                  '${controller.totalNotCheckIn.value} Not Check In',
                ],
                tabBarVisible: true,
              ),
            ),
          ),
          GetBuilder<ShowAttendeesController>(
            builder: (state) {
              return Expanded(
                flex: 1,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    _tabBarView(state, AttendeesTab.checkIn),
                    _tabBarView(state, AttendeesTab.notCheckIn),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  RefreshIndicator _tabBarView(
    ShowAttendeesController state,
    AttendeesTab tab,
  ) {
    // Select the appropriate participants state based on the tab
    final participantsState = tab == AttendeesTab.checkIn
        ? state.participantsStateCheckin
        : state.participantsStateNotCheckin;

    return RefreshIndicator(
      onRefresh: () async {
        await state.getEventParticipants(
          isRefresh: true,
          tab: tab,
        );
      },
      color: MainColor.primary,
      backgroundColor: MainColor.white,
      child: Obx(
        () =>
            participantsState.value.whenOrNull(
              loading: () => ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const CustomShimmerWidget.card(
                    height: 80,
                  );
                },
              ),
              empty: (message) => Container(
                width: 1.sw,
                alignment: Alignment.topCenter,
                child: GeneralEmptyErrorWidget(
                  titleText: 'No Attendees',
                  descText: message,
                  onRefresh: () {
                    state.getEventParticipants(
                      isRefresh: true,
                      tab: tab,
                    );
                  },
                ),
              ),
              error: (message) => Container(
                width: 1.sw,
                alignment: Alignment.topCenter,
                child: GeneralEmptyErrorWidget(
                  titleText: 'Error',
                  descText: message,
                  onRefresh: () {
                    state.getEventParticipants(
                      isRefresh: true,
                      tab: tab,
                    );
                  },
                ),
              ),
              success: (data) {
                return CustomLoadMore(
                  isFinish: (data.data ?? []).length >= (data.meta?.total ?? 0),
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                  onLoadMore: () async {
                    await state.getEventParticipants(
                      tab: tab,
                      isLoadMore: true,
                    );
                    final participantsState = tab == AttendeesTab.checkIn
                        ? state.participantsStateCheckin
                        : state.participantsStateNotCheckin;

                    if (participantsState.value.whenOrNull(
                          success: (data) => data.data?.length ?? 0,
                        ) ==
                        (data.meta?.total ?? 0)) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: ListView.separated(
                    itemCount: data.data?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          margin: index == 0
                              ? EdgeInsets.only(top: 16.w)
                              : EdgeInsets.zero,
                          child: Stack(
                            children: [
                              ListTile(
                                title: Text(data.data?[index].user?.name ?? ''),
                                subtitle: Conditional.single(
                                  context: context,
                                  conditionBuilder: (_) =>
                                      tab == AttendeesTab.checkIn,
                                  widgetBuilder: (_) => Container(
                                    margin: EdgeInsets.only(
                                      top: 4.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timelapse_sharp,
                                              color: MainColor.primary,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              DateTime.tryParse(data
                                                              .data?[index]
                                                              .arrivedAt ??
                                                          "")
                                                      ?.toHumanDateTimeShort() ??
                                                  "",
                                              style: const TextStyle(
                                                color: MainColor.primaryDarker,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // location
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: MainColor.greyTextColor,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                data.data?[index].location ??
                                                    '',
                                                style: const TextStyle(
                                                  color:
                                                      MainColor.greyTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  fallbackBuilder: (_) => Text(
                                    data.data?[index].user?.email ?? '',
                                  ),
                                ),
                                selected: false,
                                selectedTileColor:
                                    MainColor.primary.withOpacity(0.1),
                                selectedColor: MainColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    data.data?[index].user?.photo ?? "",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const CustomShimmerWidget.avatar(
                                        width: 50,
                                        height: 50,
                                        margin: 0,
                                        padding: 0,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: data.data?[index].isGuest ?? false,
                                child: Positioned(
                                  right: 12,
                                  top: 12,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
                                    decoration: BoxDecoration(
                                      color: MainColor.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Guest",
                                      style: TextStyle(
                                        color: MainColor.primary,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                );
              },
            ) ??
            const SizedBox(),
      ),
    );
  }
}
