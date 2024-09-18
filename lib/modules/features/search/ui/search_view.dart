import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/modules/features/search/controllers/search.controller.dart';
import 'package:guest_allow/shared/customs/custom_loadmore.widget.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: MainColor.blackTextColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search event',
                          hintStyle: const TextStyle(
                            color: MainColor.greyTextColor,
                            fontSize: 14,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.searchEvent(
                                query: '',
                              );
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: MainColor.greyTextColor,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          controller.searchEvent(
                            query: value,
                            isRefresh: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.searchEvent(
                      isRefresh: true,
                      query: controller.searchController.text,
                    );
                  },
                  color: MainColor.primary,
                  backgroundColor: MainColor.white,
                  child: Obx(
                    () =>
                        controller.searchEventState.value.whenOrNull(
                          loading: () => ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const CustomShimmerWidget.card(
                                height: 150,
                              );
                            },
                          ),
                          empty: (message) => Container(
                            width: 1.sw,
                            height: 1.sh,
                            alignment: Alignment.topCenter,
                            child: GeneralEmptyErrorWidget(
                              titleText:
                                  controller.searchController.text.isEmpty
                                      ? 'Search Event'
                                      : 'No Event Found',
                              descText: controller.searchController.text.isEmpty
                                  ? 'Search your favorite event'
                                  : 'No event found with keyword "${controller.searchController.text}"',
                              customUrlImage: AssetConstant.drawNoSearchResult,
                              onRefresh: () {
                                controller.searchEvent(
                                  query: controller.searchController.text,
                                );
                              },
                            ),
                          ),
                          success: (data) {
                            return CustomLoadMore(
                              isFinish:
                                  (data.data ?? []).length >= (data.total ?? 0),
                              textBuilder: DefaultLoadMoreTextBuilder.english,
                              onLoadMore: () async {
                                await controller.searchEvent(
                                  isLoadMore: true,
                                  query: controller.searchController.text,
                                );
                                if ((controller.searchEventState.value
                                            .whenOrNull(
                                          success: (data) =>
                                              data.data?.length ?? 0,
                                        ) ??
                                        0) >=
                                    (data.total ?? 0)) {
                                  log('data.total: ${data.total}');
                                  return false;
                                } else {
                                  log('data.total: ${data.total}');
                                  return true;
                                }
                              },
                              child: ListView.separated(
                                itemCount: data.data?.length ?? 0,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 4,
                                ),
                                itemBuilder: (context, index) {
                                  final eventModel = EventModel.fromEventData(
                                    data.data?[index],
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        MainRoute.detailEvent,
                                        arguments: eventModel,
                                      );
                                    },
                                    child: CardThisMonthEvent(
                                      eventModel: eventModel,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ) ??
                        const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
