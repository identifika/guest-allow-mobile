import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/profile/controllers/edit_profile.controller.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: GetBuilder<EditProfileController>(
                        id: 'image',
                        builder: (state) {
                          return Conditional.single(
                            context: context,
                            conditionBuilder: (_) =>
                                state.selectedImage != null,
                            widgetBuilder: (_) => Image.file(
                              state.selectedImage!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: MainColor.lightGrey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: MainColor.greyTextColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            fallbackBuilder: (_) => Image.network(
                              controller.userLocalData?.photo ?? "",
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
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
                                  width: 100,
                                  height: 100,
                                  padding: 0,
                                  margin: 0,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          controller.selectImage();
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50,
                            ),
                            color: MainColor.primary,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.confirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: MainColor.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.enrollFace();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Update Registered Face",
                  style: TextStyle(
                    color: MainColor.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
