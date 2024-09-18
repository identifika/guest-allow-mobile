import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/home/controllers/home.controller.dart';
import 'package:guest_allow/modules/features/main/controllers/main_controller.dart';
import 'package:guest_allow/shared/widgets/card_popular_event.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getPopularEvent();
          controller.getThisMonthEvent();
          controller.getPlaceMark();
          controller.getUser();
        },
        color: MainColor.primary,
        backgroundColor: MainColor.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              _buildHeader(controller),
              SizedBox(height: 24.h),
              _buildSearch(),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Event",
                      style: TextStyle(
                        color: MainColor.blackTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(MainRoute.viewAllEvent);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: MainColor.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Obx(
                  () => controller.popularEventState.value.when(
                    loading: () => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 12 : 0,
                            right: index == 4 ? 12 : 0,
                          ),
                          child: const CustomShimmerWidget.card(
                            width: 300,
                          ),
                        );
                      },
                    ),
                    success: (data) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var eventModel = data[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                MainRoute.detailEvent,
                                arguments: eventModel,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? 12 : 0,
                                right: index == data.length - 1 ? 12 : 0,
                              ),
                              child: CardPopularEvent(
                                eventModel: eventModel,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (message) => Center(
                      child: Text(message),
                    ),
                    idle: () => const SizedBox(),
                    empty: (message) => Container(
                      width: double.infinity,
                      height: 300,
                      padding: EdgeInsets.only(top: 24.h),
                      alignment: Alignment.topCenter,
                      child: GeneralEmptyErrorWidget(
                        titleText: message,
                        descText:
                            'Sorry, there is no event data available right now',
                        isCentered: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Event This Month",
                      style: TextStyle(
                        color: MainColor.blackTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          MainRoute.viewAllEvent,
                          arguments: controller.selectedDate,
                        );
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: MainColor.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                  () => controller.thisMonthEventState.value.when(
                    loading: () => SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const CustomShimmerWidget.card(
                            height: 100,
                          );
                        },
                      ),
                    ),
                    success: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var event = data[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                MainRoute.detailEvent,
                                arguments: event,
                              );
                            },
                            child: CardThisMonthEvent(
                              eventModel: event,
                            ),
                          );
                        },
                      );
                    },
                    error: (message) => Center(
                      child: Text(message),
                    ),
                    idle: () => const SizedBox(),
                    empty: (message) => Container(
                      width: double.infinity,
                      height: 300,
                      padding: EdgeInsets.only(top: 24.h),
                      alignment: Alignment.topCenter,
                      child: GeneralEmptyErrorWidget(
                        titleText: message,
                        descText:
                            'Sorry, there is no event data available right now',
                        isCentered: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader(HomeController state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => state.userState.value.when(
                      success: (data) => Text(
                        "Hello, ${data.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: MainColor.blackTextColor),
                      ),
                      empty: (message) => Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: MainColor.blackTextColor),
                      ),
                      loading: () => Text(
                        "Loading...",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: MainColor.blackTextColor),
                      ),
                      error: (message) => Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: MainColor.blackTextColor),
                      ),
                      idle: () => const SizedBox(),
                    ),
                  ),
                  Obx(
                    () => state.placeMarkState.value.when(
                      success: (data) => Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: MainColor.blackTextColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            data.properties?.displayName ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: MainColor.blackTextColor),
                          ),
                        ],
                      ),
                      empty: (message) => Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: MainColor.blackTextColor),
                      ),
                      loading: () => Text(
                        "Loading...",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: MainColor.blackTextColor),
                      ),
                      error: (message) => Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: MainColor.blackTextColor),
                      ),
                      idle: () => const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      MainRoute.notificationsView,
                    );
                  },
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: MainColor.blackTextColor,
                    size: 24.sp,
                  ),
                ),
              ],
            )
          ],
        ),
      );

  _buildSearch() => GestureDetector(
        onTap: () {
          MainController.to.changeIndex(1);
        },
        child: Container(
          height: 48,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 16,
                color: MainColor.blackTextColor,
              ),
              SizedBox(width: 8),
              Text(
                "Search event...",
                style: TextStyle(
                    color: MainColor.blackTextColor,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      );
}
