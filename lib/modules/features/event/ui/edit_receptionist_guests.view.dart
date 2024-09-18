import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/edit_receptionist_guest.controller.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class EditReceptionistGuestsView extends StatelessWidget {
  const EditReceptionistGuestsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditReceptionistGuestsController());
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.callback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Guest Receptionist',
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
              controller.callback();
            },
          ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.dialogAddParticipant(context);
          },
          backgroundColor: MainColor.primary,
          child: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: false,
        // ignore: deprecated_member_use
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
                          controller.searchParticipant(value);
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
                        controller.searchParticipant('');
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
              GetBuilder<EditReceptionistGuestsController>(
                id: 'guests',
                builder: (state) {
                  return Expanded(
                    child: Obx(
                      () =>
                          state.guestsState.value.whenOrNull(
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
                              ),
                            ),
                            success: (data) {
                              return ListView.separated(
                                itemCount: data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      state.selectParticipant(data[index]);
                                    },
                                    child: ListTile(
                                      title: Text(data[index].name ?? ''),
                                      subtitle: Text(data[index].email ?? ''),
                                      selected: state
                                          .isSelected(data[index].id ?? ""),
                                      selectedTileColor:
                                          MainColor.primary.withOpacity(0.1),
                                      selectedColor: MainColor.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
