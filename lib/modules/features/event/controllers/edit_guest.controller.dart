import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/base_controllers/base_edit_guest.controller.dart';
import 'package:guest_allow/modules/features/event/models/requests/invite_new_guest.request.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/drawer_content_choose_file_widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';
import 'package:uuid/uuid.dart';

class EditGuestsController extends BaseEditParticipantsController<Guest> {
  static EditGuestsController get to => Get.find();

  final EventRepository _eventRepository = EventRepository();
  Rx<UIState<List<Guest>>> guestsState = const UIState<List<Guest>>.idle().obs;

  List<Guest> selectedGuests = [];
  List<Guest> guests = [];
  List<String> idSelectedGuests = [];

  RxBool notifyEmail = false.obs;
  RxBool showNotifyEmailForm = false.obs;
  RxBool isCreate = false.obs;

  @override
  void callback() async {
    Get.back(result: selectedGuests);
  }

  @override
  bool hasEditedData(
      List<Guest> participants, List<Guest> selectedParticipants) {
    guests.sort((a, b) => (a.id ?? "").compareTo((b.id ?? "")));
    selectedGuests.sort((a, b) => (a.id ?? "").compareTo((b.id ?? "")));

    if (guests.length != selectedGuests.length) {
      return true;
    }

    for (int i = 0; i < guests.length; i++) {
      if (guests[i] != selectedGuests[i]) {
        return true;
      }
    }

    return false;
  }

  @override
  bool isSelected(String participantId) {
    return idSelectedGuests.contains(participantId);
  }

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if (args is Map<String, dynamic>) {
      args = args;
      if (args['selectedGuests'] != null) {
        selectedGuests = (args['selectedGuests'] as List<Guest>).toList();
        if (selectedGuests.isNotEmpty) {
          guests = selectedGuests.toList();
          for (var guest in selectedGuests) {
            idSelectedGuests.add(guest.id ?? '');
          }
          guestsState.value = UIState.success(data: guests);
        } else {
          guestsState.value = const UIState.empty();
        }
      }
      if (args['eventId'] != null) {
        eventId = args['eventId'];
      }
      if (args['isCreate'] != null) {
        isCreate.value = args['isCreate'];
      }
    }

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        if (GetUtils.isEmail(emailController.text)) {
          showNotifyEmailForm.value = true;
        } else {
          showNotifyEmailForm.value = false;
        }
      } else {
        showNotifyEmailForm.value = false;
      }
    });
  }

  @override
  Future<void> addNewParticipant() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Name cannot be empty",
      );
      return;
    }

    if (imageFile == null) {
      Get.snackbar(
        "Error",
        "Please select a photo",
      );
      return;
    }

    if (isCreate.value) {
      var uuid = const Uuid();
      Guest guest = Guest(
        id: uuid.v4(),
        name: nameController.text,
        email: emailController.text,
        image: File(imageFile!.path),
        notifiedByEmail: notifyEmail.value,
      );

      guests.add(guest);
      selectedGuests.add(guest);
      idSelectedGuests.add(guest.id ?? '');
      guestsState.value = UIState.success(data: guests);
    } else {
      await _addToDatabase();
    }

    nameController.text = '';
    emailController.text = '';
    imageFile = null;
    notifyEmail.value = false;
    update(['guests']);
  }

  Future<void> _addToDatabase() async {
    try {
      InviteNewGuestRequest data = InviteNewGuestRequest(
        name: nameController.text,
        email: emailController.text,
        file: File(imageFile!.path),
        eventId: eventId,
        sendEmail: notifyEmail.value,
      );

      CustomDialogWidget.showLoading();

      var response = await _eventRepository.inviteGuest(
        data: data,
      );
      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
        Guest guest = response.meta ?? Guest();
        guests.add(guest);
        selectedGuests.add(guest);
        idSelectedGuests.add(guest.id ?? '');
        guestsState.value = UIState.success(data: guests);
        update(['guests']);
        Get.close(1);
      } else {
        CustomDialogWidget.showDialogProblem(
          description: response.message ?? 'Failed to add guest',
        );
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        description: 'Failed to add guest',
      );
    }
  }

  @override
  Future<void> deleteParticipant(String participantId) async {
    try {
      CustomDialogWidget.showLoading();

      var response = await _eventRepository.deleteGuest(
          eventId: eventId, guestId: participantId);
      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode ?? 0)) {
        guests.removeWhere((element) => element.id == participantId);
        selectedGuests.removeWhere((element) => element.id == participantId);
        idSelectedGuests.remove(participantId);
        guestsState.value = UIState.success(data: guests);
        update(['guests']);
      } else {
        log(response.message ?? '');
        CustomDialogWidget.showDialogProblem(
          description: response.message ?? 'Failed to delete guest',
        );
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        description: 'Failed to delete guest',
      );
    }
  }

  @override
  void dialogAddParticipant(BuildContext context) {
    Get.bottomSheet(
      GetBuilder<EditGuestsController>(
        id: 'dialog_add_guest',
        builder: (state) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: MainColor.grey,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Add Guest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: const TextStyle(
                      color: MainColor.black,
                      fontSize: 16,
                    ),
                    fillColor: MainColor.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: MainColor.black,
                      fontSize: 16,
                    ),
                    fillColor: MainColor.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // select photo
                TextField(
                  controller: photoController,
                  onTap: () {
                    selectFile();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Photo",
                    hintStyle: const TextStyle(
                      color: MainColor.black,
                      fontSize: 16,
                    ),
                    fillColor: MainColor.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.link,
                      color: MainColor.primary,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MainColor.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: showNotifyEmailForm.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          'Notify Receptionist by Email:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: RadioListTile<bool>(
                                title: const Text('Yes'),
                                value: true,
                                contentPadding: EdgeInsets.zero,
                                groupValue: notifyEmail.value,
                                activeColor: MainColor.primary,
                                onChanged: (value) {
                                  notifyEmail.value = value!;
                                  update(['dialog_add_guest']);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: RadioListTile<bool>(
                                title: const Text('No'),
                                value: false,
                                contentPadding: EdgeInsets.zero,
                                groupValue: notifyEmail.value,
                                activeColor: MainColor.primary,
                                onChanged: (value) {
                                  notifyEmail.value = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addNewParticipant();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.primary,
                    ),
                    child: const Text('Invite Guest',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          );
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void selectFile() async {
    var file = await showModalBottomSheet<File?>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih File',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: const DrawerContentChooseFileWidget(
                sourceFiles: [
                  SourceFileEnum.gallery,
                  SourceFileEnum.camera,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (file != null) {
      imageFile = XFile(file.path);
      var filename = file.path.split('/').last;
      photoController.text = filename;
      update(['guests']);
    }
  }

  @override
  void searchParticipant(String keyword) {
    if (keyword.isEmpty) {
      if (guests.isEmpty) {
        guestsState.value = const UIState.empty();
        return;
      }
      guestsState.value = UIState.success(data: guests);
    } else {
      guestsState.value = const UIState.loading();
      List<Guest> filteredGuests = guests
          .where((element) =>
              element.name?.toLowerCase().contains(keyword.toLowerCase()) ??
              false)
          .toList();
      if (filteredGuests.isEmpty) {
        guestsState.value = const UIState.empty();
        return;
      }
      guestsState.value = UIState.success(data: filteredGuests);
    }
  }

  @override
  void selectParticipant(Guest data) {
    if (isSelected(data.id ?? '')) {
      CustomDialogWidget.showDialogChoice(
        title: 'Remove Guest',
        description:
            'Do you want to remove this guest? This action cannot be undone.',
        onTapPositiveButton: () {
          Get.back();
          deleteParticipant(data.id ?? '');
        },
        onTapNegativeButton: () {
          Get.back();
        },
      );
    } else {
      selectedGuests.add(data);
      idSelectedGuests.add(data.id ?? '');
    }
    update(['guests']);
  }
}
