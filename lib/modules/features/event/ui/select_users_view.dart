import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/select_users.controller.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class SelectUsersView extends StatelessWidget {
  const SelectUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectUsersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Users'),
        actions: [
          IconButton(
            onPressed: () {
              controller.callback();
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
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
                    Icons.search,
                    color: MainColor.primary,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onSubmitted: (value) {
                        controller.getRegisteredUsers(
                          isRefresh: true,
                          keyword: value,
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.searchController.clear();
                      controller.getRegisteredUsers(
                        isRefresh: true,
                      );
                    },
                    child: const Icon(
                      Icons.close,
                      color: MainColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GetBuilder<SelectUsersController>(
              id: 'users',
              builder: (state) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      state.getRegisteredUsers(
                        isRefresh: true,
                      );
                    },
                    child: Obx(
                      () =>
                          state.usersState.value.whenOrNull(
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
                              alignment: Alignment.topCenter,
                              child: GeneralEmptyErrorWidget(
                                titleText: state.searchController.text.isEmpty
                                    ? 'Search User'
                                    : 'No User Found',
                                descText: state.searchController.text.isEmpty
                                    ? 'Search your favorite user'
                                    : 'No user found with keyword "${state.searchController.text}"',
                                customUrlImage:
                                    AssetConstant.drawNoSearchResult,
                                onRefresh: () {
                                  state.getRegisteredUsers(
                                    keyword: state.searchController.text,
                                  );
                                },
                              ),
                            ),
                            success: (data) {
                              return ListView.separated(
                                itemCount: data.data?.length ?? 0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      state.selectUser(
                                          data.data?[index].id ?? "");
                                    },
                                    child: ListTile(
                                      title: Text(data.data?[index].name ?? ''),
                                      subtitle:
                                          Text(data.data?[index].email ?? ''),
                                      selected: state.isSelected(
                                          data.data?[index].id ?? ""),
                                      selectedTileColor:
                                          MainColor.primary.withOpacity(0.1),
                                      selectedColor: MainColor.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          data.data?[index].photo ?? '',
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
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const CustomShimmerWidget
                                                .avatar(
                                              width: 50,
                                              height: 50,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                              );
                            },
                          ) ??
                          Container(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
