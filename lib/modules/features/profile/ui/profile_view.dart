import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/features/profile/controllers/profile.controller.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Container(
                          width: 108.w,
                          height: 108.w,
                          decoration: const BoxDecoration(
                            color: MainColor.primary,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Image.network(
                              controller.user?.photo ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 64,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const CustomShimmerWidget.avatar();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller.user?.email ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainColor.blackTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(MainRoute.profileEdit);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: MainColor.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.dialogLogout();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.redAccent.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Colors.red[800],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  TabBar(
                    controller: controller.tabController,
                    onTap: (index) {
                      controller.onTabChange(index);
                    },
                    indicatorColor: MainColor.primary,
                    labelColor: MainColor.primary,
                    tabs: [
                      Tab(
                        child: Column(
                          children: [
                            Obx(
                              () =>
                                  controller.totalsState.value.whenOrNull(
                                    success: (data) {
                                      return Text(
                                        (data.joined ?? 0).toString(),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                    loading: () =>
                                        const CustomShimmerWidget.card(
                                      width: 40,
                                      height: 20,
                                    ),
                                    error: (message) => Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ) ??
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ),
                            Text(
                              "Event Joined",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: MainColor.blackTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Obx(
                              () =>
                                  controller.totalsState.value.whenOrNull(
                                    success: (data) {
                                      return Text(
                                        (data.mine ?? 0).toString(),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                    loading: () =>
                                        const CustomShimmerWidget.card(
                                      width: 40,
                                      height: 20,
                                    ),
                                    error: (message) => Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ) ??
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ),
                            Text(
                              "Event Created",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: MainColor.blackTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Obx(
                              () =>
                                  controller.totalsState.value.whenOrNull(
                                    success: (data) {
                                      return Text(
                                        (data.receptionist ?? 0).toString(),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                    loading: () =>
                                        const CustomShimmerWidget.card(
                                      width: 40,
                                      height: 20,
                                    ),
                                    error: (message) => Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ) ??
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ),
                            Text(
                              "Receptionist",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: MainColor.blackTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ), // Add this line
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              controller.getMyEvents(
                                type: 'joined',
                                isRefresh: true,
                              );
                            },
                            color: MainColor.primary,
                            backgroundColor: MainColor.white,
                            child: Obx(
                              () =>
                                  controller.joinedEventState.value.whenOrNull(
                                    loading: () => ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            top: index == 0 ? 12.h : 16.h,
                                          ),
                                          child: const CustomShimmerWidget.card(
                                            height: 100,
                                            margin: 0,
                                          ),
                                        );
                                      },
                                    ),
                                    success: (data) {
                                      return CustomLoadMore(
                                        isFinish: (data.data ?? []).length >=
                                            (data.total ?? 0),
                                        textBuilder:
                                            DefaultLoadMoreTextBuilder.english,
                                        onLoadMore: () async {
                                          await controller.getMyEvents(
                                              type: 'joined', isLoadMore: true);
                                          if (controller.joinedEventState.value
                                                  .whenOrNull(
                                                success: (data) =>
                                                    data.data?.length ?? 0,
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
                                            var eventModel =
                                                EventModel.fromEventData(
                                              data.data?[index],
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  MainRoute.detailEvent,
                                                  arguments: eventModel,
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: index == 0 ? 12.h : 0,
                                                ),
                                                child: CardThisMonthEvent(
                                                  eventModel: eventModel,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
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
                                            'You have not joined any event',
                                        descText: message,
                                        customHeightContent: 0.5.sh,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'joined',
                                          );
                                        },
                                      ),
                                    ),
                                    error: (error) => Container(
                                      width: 1.sw,
                                      alignment: Alignment.topCenter,
                                      child: GeneralEmptyErrorWidget(
                                        titleText:
                                            'There is an error when fetching your event',
                                        descText: error,
                                        customHeightContent: 0.5.sh,
                                        customUrlImage: AssetConstant.drawError,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'joined',
                                          );
                                        },
                                      ),
                                    ),
                                  ) ??
                                  const SizedBox(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              controller.getMyEvents(
                                type: 'mine',
                                isRefresh: true,
                              );
                            },
                            color: MainColor.primary,
                            backgroundColor: MainColor.white,
                            child: Obx(
                              () =>
                                  controller.mineEventState.value.whenOrNull(
                                    loading: () => ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            top: index == 0 ? 12.h : 16.h,
                                          ),
                                          child: const CustomShimmerWidget.card(
                                            height: 100,
                                            margin: 0,
                                          ),
                                        );
                                      },
                                    ),
                                    success: (data) {
                                      return CustomLoadMore(
                                        isFinish: (data.data ?? []).length >=
                                            (data.total ?? 0),
                                        textBuilder:
                                            DefaultLoadMoreTextBuilder.english,
                                        onLoadMore: () async {
                                          await controller.getMyEvents(
                                              type: 'mine', isLoadMore: true);
                                          if (controller.mineEventState.value
                                                  .whenOrNull(
                                                success: (data) =>
                                                    data.data?.length ?? 0,
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
                                            var eventModel =
                                                EventModel.fromEventData(
                                              data.data?[index],
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  MainRoute.detailEvent,
                                                  arguments: eventModel,
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: index == 0 ? 12.h : 0,
                                                ),
                                                child: CardThisMonthEvent(
                                                  eventModel: eventModel,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
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
                                            'You have not created any event',
                                        descText: message,
                                        customHeightContent: 0.5.sh,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'mine',
                                          );
                                        },
                                      ),
                                    ),
                                    error: (error) => Container(
                                      width: 1.sw,
                                      alignment: Alignment.topCenter,
                                      child: GeneralEmptyErrorWidget(
                                        titleText:
                                            'There is an error when fetching your event',
                                        descText: error,
                                        customHeightContent: 0.5.sh,
                                        customUrlImage: AssetConstant.drawError,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'mine',
                                          );
                                        },
                                      ),
                                    ),
                                  ) ??
                                  const SizedBox(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              controller.getMyEvents(
                                type: 'receptionist',
                                isRefresh: true,
                              );
                            },
                            color: MainColor.primary,
                            backgroundColor: MainColor.white,
                            child: Obx(
                              () =>
                                  controller.receptionistEventState.value
                                      .whenOrNull(
                                    loading: () => ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            top: index == 0 ? 12.h : 16.h,
                                          ),
                                          child: const CustomShimmerWidget.card(
                                            height: 100,
                                            margin: 0,
                                          ),
                                        );
                                      },
                                    ),
                                    success: (data) {
                                      return CustomLoadMore(
                                        isFinish: (data.data ?? []).length >=
                                            (data.total ?? 0),
                                        textBuilder:
                                            DefaultLoadMoreTextBuilder.english,
                                        onLoadMore: () async {
                                          await controller.getMyEvents(
                                              type: 'receptionist',
                                              isLoadMore: true);
                                          if (controller
                                                  .receptionistEventState.value
                                                  .whenOrNull(
                                                success: (data) =>
                                                    data.data?.length ?? 0,
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
                                            var eventModel =
                                                EventModel.fromEventData(
                                              data.data?[index],
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  MainRoute.detailEvent,
                                                  arguments: eventModel,
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: index == 0 ? 12.h : 0,
                                                ),
                                                child: CardThisMonthEvent(
                                                  eventModel: eventModel,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
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
                                            'You have not become a receptionist',
                                        descText: message,
                                        customHeightContent: 0.5.sh,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'receptionist',
                                          );
                                        },
                                      ),
                                    ),
                                    error: (error) => Container(
                                      width: 1.sw,
                                      alignment: Alignment.topCenter,
                                      child: GeneralEmptyErrorWidget(
                                        titleText:
                                            'There is an error when fetching your event',
                                        descText: error,
                                        customHeightContent: 0.5.sh,
                                        customUrlImage: AssetConstant.drawError,
                                        onRefresh: () {
                                          controller.getMyEvents(
                                            type: 'receptionist',
                                          );
                                        },
                                      ),
                                    ),
                                  ) ??
                                  const SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCardWidget extends StatelessWidget {
  const _ProfileCardWidget({
    required this.event,
  });

  final EventData event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          SizedBox(
            width: 72.w,
            height: 72.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                event.photo ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : const CustomShimmerWidget.card(
                            width: 64,
                            height: 64,
                          ),
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  (DateTime.tryParse(event.startDate ?? '') ?? DateTime.now())
                      .toDayMonth(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: MainColor.blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  event.location ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: MainColor.blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
