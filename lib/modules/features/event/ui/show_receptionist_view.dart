import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/show_receptionist.controller.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';
import 'package:guest_allow/shared/widgets/insight_card_widget.dart';

class ShowReceptionistView extends StatelessWidget {
  const ShowReceptionistView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShowReceptionistController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Receptionist',
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
              () => InsightCard.simple(
                title: 'Receptionist',
                subtitle:
                    '${controller.totalReceptionist.value} Total Receptionist',
                subtitle2:
                    '(${controller.totalGuest.value} Guest, ${controller.totalUser.value} User)',
                labels: const [],
                tabBarVisible: true,
              ),
            ),
          ),
          GetBuilder<ShowReceptionistController>(
            builder: (state) {
              return Expanded(
                flex: 1,
                child: _tabBarView(state),
              );
            },
          ),
        ],
      ),
    );
  }

  RefreshIndicator _tabBarView(
    ShowReceptionistController state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await state.getEventReceptionists(
          isRefresh: true,
        );
      },
      color: MainColor.primary,
      backgroundColor: MainColor.white,
      child: Obx(
        () =>
            state.receptionistState.value.whenOrNull(
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
                  titleText: 'No Participants',
                  descText: message,
                  onRefresh: () {
                    state.getEventReceptionists(
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
                    state.getEventReceptionists(
                      isRefresh: true,
                    );
                  },
                ),
              ),
              success: (data) => CustomLoadMore(
                isFinish: (data.data ?? []).length >= (data.meta?.total ?? 0),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                onLoadMore: () async {
                  await state.getEventReceptionists(
                    isLoadMore: true,
                  );
                  if (state.receptionistState.value.whenOrNull(
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
                              subtitle: Text(
                                data.data?[index].user?.email ?? '',
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
                                  errorBuilder: (context, error, stackTrace) =>
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
              ),
            ) ??
            const SizedBox(),
      ),
    );
  }
}
