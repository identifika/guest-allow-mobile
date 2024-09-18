import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/features/notifications/controllers/notifications.controller.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(NotificationsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
      body: RefreshIndicator(
        onRefresh: () async {
          await state.getListNotif(
            isRefresh: true,
          );
        },
        color: MainColor.primary,
        backgroundColor: MainColor.white,
        child: Obx(
          () =>
              state.stateNotifList.value.whenOrNull(
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
                    titleText: 'No Notifications',
                    descText: message,
                    onRefresh: () {
                      state.getListNotif(
                        isRefresh: true,
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
                      state.getListNotif(
                        isRefresh: true,
                      );
                    },
                  ),
                ),
                success: (data) => CustomLoadMore(
                  isFinish: (data.data ?? []).length >= (data.total ?? 0),
                  textBuilder: DefaultLoadMoreTextBuilder.english,
                  onLoadMore: () async {
                    await state.getListNotif(
                      isLoadMore: true,
                    );
                    if (state.stateNotifList.value.whenOrNull(
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
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          var eventModel = EventModel.fromEventData(
                            data.data?[index].data?.event,
                          );
                          state.readNotif(data.data?[index].id ?? "");

                          await Get.toNamed(
                            MainRoute.detailEvent,
                            arguments: {
                              'eventData': eventModel.toJson(),
                            },
                          );
                          state.getListNotif();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          margin: index == 0
                              ? EdgeInsets.only(top: 16.w)
                              : EdgeInsets.zero,
                          child: Stack(
                            children: [
                              ListTile(
                                title:
                                    Text(data.data?[index].data?.message ?? ''),
                                subtitle: Text(
                                  data.data?[index].data?.event?.createdBy
                                          ?.name ??
                                      '',
                                ),
                                selected: false,
                                selectedTileColor:
                                    MainColor.primary.withOpacity(0.1),
                                selectedColor: MainColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tileColor: data.data?[index].readAt == null
                                    ? MainColor.primary.withOpacity(
                                        0.1,
                                      )
                                    : null,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    data.data?[index].data?.event?.photo ?? "",
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: MainColor.lightGrey,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: MainColor.greyTextColor,
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const CustomShimmerWidget.avatar(
                                        width: 80,
                                        height: 80,
                                        padding: 0,
                                        margin: 0,
                                      );
                                    },
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
                ),
              ) ??
              const SizedBox(),
        ),
      ),
    );
  }
}
