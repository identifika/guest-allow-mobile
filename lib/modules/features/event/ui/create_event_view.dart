import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/create_event.controller.dart';

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateEventController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          controller.isEditing.value
                              ? "Edit Event"
                              : "Create Event",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: MainColor.greyTextColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: UnderlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.transparent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.primaryDarker,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.primaryDarker,
                        ),
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    onTap: () {
                      try {
                        controller.selectStartDate();
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    readOnly: true,
                    controller: controller.startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date and Time',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: UnderlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.transparent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.primary,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.blackTextColor,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: MainColor.blackTextColor,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: MainColor.primaryDarker,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    onTap: () {
                      try {
                        controller.selectEndDate();
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    controller: controller.endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Date and Time',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: UnderlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.transparent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.primary,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MainColor.blackTextColor,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: MainColor.blackTextColor,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: MainColor.primaryDarker,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Text(
                          "Event Status",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: MainColor.blackTextColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  controller.selectedEventStatus.value = 0;
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue:
                                          controller.selectedEventStatus.value,
                                      onChanged: (value) {
                                        controller.selectedEventStatus.value =
                                            0;
                                      },
                                      activeColor: MainColor.primary,
                                    ),
                                    Text(
                                      "Online",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: MainColor.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  controller.selectedEventStatus.value = 1;
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue:
                                          controller.selectedEventStatus.value,
                                      onChanged: (value) {
                                        controller.selectedEventStatus.value =
                                            1;
                                      },
                                      activeColor: MainColor.primary,
                                    ),
                                    Text(
                                      "Offline",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: MainColor.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => controller.selectedEventStatus.value == 0
                        ? Column(
                            children: [
                              SizedBox(
                                height: 16.h,
                              ),
                              TextFormField(
                                controller: controller.linkController,
                                decoration: const InputDecoration(
                                  labelText: 'Link',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  border: UnderlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: Colors.transparent,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MainColor.primaryDarker,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => controller.selectedEventStatus.value == 1
                        ? Column(
                            children: [
                              SizedBox(
                                height: 16.h,
                              ),
                              TextFormField(
                                onTap: () {
                                  controller.showMap();
                                },
                                controller: controller.locationController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  border: UnderlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: Colors.transparent,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MainColor.primary,
                                    ),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MainColor.blackTextColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: MainColor.blackTextColor,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.location_on,
                                    color: MainColor.primaryDarker,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              // radius
                              TextFormField(
                                controller: controller.radiusController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Radius (m)',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  border: UnderlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: Colors.transparent,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MainColor.primaryDarker,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  // radio button for event type (public or private)
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Text(
                          "Event Type",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: MainColor.blackTextColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  controller.selectedEventType.value = 1;
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue:
                                          controller.selectedEventType.value,
                                      onChanged: (value) {
                                        controller.selectedEventType.value = 1;
                                      },
                                      activeColor: MainColor.primary,
                                    ),
                                    Text(
                                      "Public",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: MainColor.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  controller.selectedEventType.value = 0;
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue:
                                          controller.selectedEventType.value,
                                      onChanged: (value) {
                                        controller.selectedEventType.value = 0;
                                      },
                                      activeColor: MainColor.primary,
                                    ),
                                    Text(
                                      "Private",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: MainColor.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  GetBuilder<CreateEventController>(
                    id: 'participants',
                    builder: (state) {
                      return Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            state.selectedParticipants.isNotEmpty,
                        widgetBuilder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Participants",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: MainColor.blackTextColor,
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: state.selectedParticipants
                                      .map(
                                        (e) => Visibility(
                                          child: Chip(
                                            backgroundColor: MainColor.primary,
                                            label: Text(
                                              e.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              state.removeParticipant(
                                                  e.id ?? "");
                                            },
                                          ),
                                        ),
                                      )
                                      .take(3)
                                      .toList() +
                                  [
                                    Visibility(
                                      visible:
                                          state.selectedParticipants.length > 3,
                                      child: Chip(
                                        backgroundColor: MainColor.primary,
                                        label: Text(
                                          "+${state.selectedParticipants.length - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      child: GestureDetector(
                                        onTap: () {
                                          state.selectParticipants();
                                        },
                                        child: Chip(
                                          label: const Text(
                                            "Add Participants",
                                          ),
                                          backgroundColor: Colors.grey[200],
                                          deleteIcon: Container(
                                            width: 24.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[300],
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: MainColor.primary,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                          onDeleted: () {
                                            state.selectParticipants();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
                        fallbackBuilder: (context) => TextFormField(
                          onTap: () {
                            controller.selectParticipants();
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Add Participants',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: UnderlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.transparent,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MainColor.primaryDarker,
                              ),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MainColor.blackTextColor,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: MainColor.blackTextColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  GetBuilder<CreateEventController>(
                    id: 'guests',
                    builder: (state) {
                      return Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            state.selectedGuests.isNotEmpty,
                        widgetBuilder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Tooltip(
                              message:
                                  "Guests are the people who are invited to the event without having access to the application. You can manage the guests by adding or removing them by click the 'Add Guests' button.",
                              triggerMode: TooltipTriggerMode.tap,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Guests",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: MainColor.blackTextColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  // Icon exclamtion
                                  const Icon(
                                    Icons.info,
                                    color: MainColor.primary,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: state.selectedGuests
                                      .map(
                                        (e) => Visibility(
                                          child: Chip(
                                            backgroundColor: MainColor.primary,
                                            label: Text(
                                              e.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              state.removeGuest(e.id ?? "");
                                            },
                                          ),
                                        ),
                                      )
                                      .take(3)
                                      .toList() +
                                  [
                                    Visibility(
                                      visible: state.selectedGuests.length > 3,
                                      child: Chip(
                                        backgroundColor: MainColor.primary,
                                        label: Text(
                                          "+${state.selectedGuests.length - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      child: GestureDetector(
                                        onTap: () {
                                          state.selectGuests();
                                        },
                                        child: Chip(
                                          label: const Text(
                                            "Add Guests",
                                          ),
                                          backgroundColor: Colors.grey[200],
                                          deleteIcon: Container(
                                            width: 24.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[300],
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: MainColor.primary,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                          onDeleted: () {
                                            state.selectGuests();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
                        fallbackBuilder: (context) => Obx(
                          () => Visibility(
                            visible: controller.showAddGuest.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MainColor.primaryDarker,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      state.selectGuests();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info,
                                          color: MainColor.primary,
                                          size: 16.sp,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Didn't see the users you're looking for? Try add guest",
                                          style: TextStyle(
                                            color: MainColor.primary,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: 16.h,
                  ),

                  GetBuilder<CreateEventController>(
                    id: 'receptionists',
                    builder: (state) {
                      return Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            state.selectedReceptionists.isNotEmpty,
                        widgetBuilder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receptionist",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: MainColor.blackTextColor,
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: state.selectedReceptionists
                                      .map(
                                        (e) => Visibility(
                                          child: Chip(
                                            backgroundColor: MainColor.primary,
                                            label: Text(
                                              e.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              state.removeReceptionist(
                                                  e.id ?? "");
                                            },
                                          ),
                                        ),
                                      )
                                      .take(3)
                                      .toList() +
                                  [
                                    Visibility(
                                      visible:
                                          state.selectedReceptionists.length >
                                              3,
                                      child: Chip(
                                        backgroundColor: MainColor.primary,
                                        label: Text(
                                          "+${state.selectedReceptionists.length - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      child: GestureDetector(
                                        onTap: () {
                                          state.selectReceptionists();
                                        },
                                        child: Chip(
                                          label: const Text(
                                            "Add Receptionist",
                                          ),
                                          backgroundColor: Colors.grey[200],
                                          deleteIcon: Container(
                                            width: 24.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[300],
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: MainColor.primary,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                          onDeleted: () {
                                            state.selectReceptionists();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
                        fallbackBuilder: (context) => TextFormField(
                          onTap: () {
                            controller.selectReceptionists();
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Add Receptionist',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: UnderlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.transparent,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MainColor.primaryDarker,
                              ),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MainColor.blackTextColor,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: MainColor.blackTextColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  GetBuilder<CreateEventController>(
                    id: 'receptionists_guests',
                    builder: (state) {
                      return Conditional.single(
                        context: context,
                        conditionBuilder: (context) =>
                            state.selectedReceptionistGuests.isNotEmpty,
                        widgetBuilder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Tooltip(
                              message:
                                  "Guest Receptionist are essential personnel assigned to assist with event management. While they may not have access to the application, you can manage receptionists by adding or removing them using the 'Add Guest Receptionist' button.",
                              triggerMode: TooltipTriggerMode.tap,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Guest Receptionist",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: MainColor.blackTextColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  // Icon exclamtion
                                  const Icon(
                                    Icons.info,
                                    color: MainColor.primary,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: state.selectedReceptionistGuests
                                      .map(
                                        (e) => Visibility(
                                          child: Chip(
                                            backgroundColor: MainColor.primary,
                                            label: Text(
                                              e.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              state.removeReceptionistGuest(
                                                  e.id ?? "");
                                            },
                                          ),
                                        ),
                                      )
                                      .take(3)
                                      .toList() +
                                  [
                                    Visibility(
                                      visible: state.selectedReceptionistGuests
                                              .length >
                                          3,
                                      child: Chip(
                                        backgroundColor: MainColor.primary,
                                        label: Text(
                                          "+${state.selectedReceptionistGuests.length - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      child: GestureDetector(
                                        onTap: () {
                                          state.selectReceptionistGuests();
                                        },
                                        child: Chip(
                                          label: const Text(
                                            "Add Guest Receptionist",
                                          ),
                                          backgroundColor: Colors.grey[200],
                                          deleteIcon: Container(
                                            width: 24.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[300],
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: MainColor.primary,
                                                size: 16.sp,
                                              ),
                                            ),
                                          ),
                                          onDeleted: () {
                                            state.selectReceptionistGuests();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
                        fallbackBuilder: (context) => Obx(
                          () => Visibility(
                            visible: controller.showAddReceptionist.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MainColor.primaryDarker,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      state.selectReceptionistGuests();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info,
                                          color: MainColor.primary,
                                          size: 16.sp,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Didn't see the users you're looking for? Try add guest receptionist",
                                            style: TextStyle(
                                              color: MainColor.primary,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  // photo upload
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: GetBuilder<CreateEventController>(
                      id: 'image',
                      builder: (state) {
                        return Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              state.selectedImage != null,
                          widgetBuilder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Photo",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: MainColor.blackTextColor,
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    child: Image.file(
                                      state.selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          state.removeImage();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: MainColor.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          fallbackBuilder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Photo",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: MainColor.blackTextColor,
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selectImage();
                                },
                                child: Container(
                                  height: 140.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        controller.selectImage();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: MainColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // button create event
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.createEvent();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          controller.isEditing.value
                              ? "Update Event"
                              : "Create Event",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
