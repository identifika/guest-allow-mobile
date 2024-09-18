import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/event/controllers/edit_guest.controller.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/general_empty_error.widget.dart';

class EditGuestsView extends StatelessWidget {
  const EditGuestsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditGuestsController());
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.callback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Guests',
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
              GetBuilder<EditGuestsController>(
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
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 0.12.sh,
                                  ),
                                  GeneralEmptyErrorWidget(
                                    titleText:
                                        state.searchController.text.isEmpty
                                            ? 'No Guests Added'
                                            : 'No Guests Found',
                                    descText: state
                                            .searchController.text.isEmpty
                                        ? 'You haven\'t added any guests yet. Try inviting some guests.'
                                        : 'No guest found with keyword "${state.searchController.text}"',
                                    customUrlImage:
                                        AssetConstant.drawNoSearchResult,
                                    additionalWidgetBellowTextDesc: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller
                                              .dialogAddParticipant(context);
                                        },
                                        child: Container(
                                          width: 0.5.sw,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: MainColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(24.r),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Add Guest",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Conditional.single(
                                          context: context,
                                          conditionBuilder: (_) =>
                                              data[index].image != null,
                                          widgetBuilder: (_) => Image.file(
                                            data[index].image!,
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
                                          ),
                                          fallbackBuilder: (_) => Image.network(
                                            data[index].profilePhoto ?? '',
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
