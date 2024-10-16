import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/event/ui/widgets/button_event_state.dart';
import 'package:guest_allow/modules/features/event/ui/widgets/map_widget.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:readmore/readmore.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_event.controller.dart';
import 'package:guest_allow/shared/widgets/circle_button.dart';
import 'package:guest_allow/shared/widgets/custom_app_bar.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/stack_participant.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';
import 'package:timezone/timezone.dart' as tz;

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(DetailEventController());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(0, 0),
        child: CustomAppBar(),
      ),
      backgroundColor: MainColor.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              children: [
                GetBuilder<DetailEventController>(
                  builder: (state) {
                    return Obx(
                      () => controller.eventDetailState.value.when(
                        loading: () => CustomShimmerWidget.card(
                          height: 0.4.sh,
                          width: 1.sw,
                        ),
                        success: (eventModel) => InkWell(
                          onTap: () {
                            CustomDialogWidget.showDialogSuccess();
                          },
                          child: SizedBox(
                            width: 1.sw,
                            height: 0.4.sh,
                            child: ClipRRect(
                              child: Image.network(
                                eventModel!.photo ?? "",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return CustomShimmerWidget.card(
                                    height: 280,
                                    width: 1.sw,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    color: MainColor.greyTextColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        error: (message) => Center(
                          child: Text(message),
                        ),
                        empty: (message) => Center(
                          child: Text(message),
                        ),
                        idle: () => const SizedBox(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.translucent,
                    child: Container(height: 0.3.sh),
                  ),
                  GetBuilder<DetailEventController>(
                    builder: (state) {
                      return Obx(
                        () => controller.eventDetailState.value.when(
                          loading: () => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 100,
                            ),
                            child: CustomShimmerWidget.card(
                              height: 0.3.sh,
                              width: 1.sw,
                            ),
                          ),
                          success: (eventModel) => _buildDescription(
                            context,
                            eventModel!,
                            state.eventDetailType,
                            state.eventStatus,
                          ),
                          error: (message) => Center(
                            child: Text(message),
                          ),
                          empty: (message) => Center(
                            child: Text(message),
                          ),
                          idle: () => const SizedBox(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<DetailEventController>(
              builder: (state) {
                return Obx(
                  () => controller.eventDetailState.value.when(
                    loading: () => CustomShimmerWidget.card(
                      height: 60,
                      width: 1.sw,
                      padding: 0,
                      margin: 0,
                    ),
                    success: (eventModel) => ButtonEventState(
                      eventModel: eventModel!,
                      type: state.eventDetailType,
                      eventStatus: state.eventStatus,
                      controller: state,
                    ),
                    error: (message) => Center(
                      child: Text(message),
                    ),
                    empty: (message) => Center(
                      child: Text(message),
                    ),
                    idle: () => const SizedBox(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    EventDetailType type,
    EventStatus eventStatus,
    EventData eventModel,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: MainColor.primary,
              size: 18,
            ),
            onTap: () {
              Get.back();
            },
          ),
          Visibility(
            visible: type == EventDetailType.owner,
            child: CircleButton(
              icon: const Icon(
                Icons.more_horiz,
                color: MainColor.primary,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return _modalBottomSheet(
                      context,
                      type,
                      eventStatus,
                      eventModel,
                    );
                  },
                );
              },
            ),
          )
        ],
      );

  Container _modalBottomSheet(
    BuildContext context,
    EventDetailType type,
    EventStatus eventStatus,
    EventData eventModel,
  ) {
    var controller = Get.find<DetailEventController>();
    return Container(
      width: 1.sw,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          ConditionalSwitch.single(
            context: context,
            valueBuilder: (context) => type,
            caseBuilders: {
              EventDetailType.owner: (context) => Column(
                    children: [
                      ...ConditionalSwitch.list(
                        context: context,
                        valueBuilder: (context) => eventStatus,
                        caseBuilders: {
                          EventStatus.onGoing: (context) => [
                                _viewAttendeesListTile(eventModel),
                                _viewReceptionistListTile(eventModel),
                                _receiveAttendeesTile(eventModel, controller),
                                _editEventListTile(eventModel, controller),
                                _deleteEventListTile(controller, eventModel),
                              ],
                          EventStatus.upcoming: (context) => [
                                _viewAttendeesListTile(eventModel),
                                _viewReceptionistListTile(eventModel),
                                _editEventListTile(eventModel, controller),
                                _deleteEventListTile(controller, eventModel),
                              ],
                          EventStatus.finished: (context) => [
                                _viewAttendeesListTile(eventModel),
                                _viewReceptionistListTile(eventModel),
                                _recreateEventListTile(controller, eventModel),
                                _deleteEventListTile(controller, eventModel),
                              ],
                        },
                      ),
                    ],
                  ),
              // EventDetailType.receptionist: (context) => Column(
              //       children: [
              //         ...ConditionalSwitch.list(
              //           context: context,
              //           valueBuilder: (context) => eventStatus,
              //           caseBuilders: {
              //             EventStatus.onGoing: (context) => [
              //                   _receiveAttendeesTile(eventModel, controller),
              //                 ],
              //             // EventStatus.upcoming: (context) => [
              //             //       _viewAttendeesListTile(eventModel),
              //             //     ],
              //             // EventStatus.finished: (context) => [
              //             //       _viewAttendeesListTile(eventModel),
              //             //     ],
              //           },
              //         ),
              //       ],
              //     ),
            },
          ),
        ],
      ),
    );
  }

  ListTile _recreateEventListTile(
      DetailEventController controller, EventData eventModel) {
    return ListTile(
      onTap: () {
        controller.recreateEvent(eventModel);
      },
      title: const Text("Recreate Event"),
    );
  }

  ListTile _deleteEventListTile(
      DetailEventController controller, EventData eventModel) {
    return ListTile(
      onTap: () {
        controller.deleteEventConfirmation(eventModel.id ?? "");
      },
      title: const Text("Cancel Event"),
    );
  }

  ListTile _editEventListTile(
      EventData eventModel, DetailEventController controller) {
    return ListTile(
      onTap: () async {
        await Get.toNamed(
          MainRoute.createEvent,
          arguments: eventModel,
        );
        controller.getEventDetail(eventModel.id ?? "");
      },
      title: const Text("Edit Event"),
    );
  }

  ListTile _viewReceptionistListTile(EventData eventModel) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          MainRoute.showReceptionists,
          arguments: eventModel,
        );
      },
      title: const Text("View Receptionist"),
    );
  }

  Visibility _receiveAttendeesTile(
      EventData eventModel, DetailEventController controller) {
    return Visibility(
      visible: eventModel.type == 1,
      child: ListTile(
        onTap: () {
          controller.receiveAttende(eventModel);
        },
        title: const Text("Receive Attendees"),
      ),
    );
  }

  ListTile _viewAttendeesListTile(EventData eventModel) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          MainRoute.showAttendees,
          arguments: eventModel,
        );
      },
      title: const Text("View Attendees"),
    );
  }

  _buildDescription(
    BuildContext context,
    EventData eventModel,
    EventDetailType type,
    EventStatus eventStatus,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(
              context,
              type,
              eventStatus,
              eventModel,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventModel.title ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            Conditional.single(
                              context: context,
                              conditionBuilder: (context) =>
                                  eventModel.type == 1,
                              widgetBuilder: (context) => _LocationWidget(
                                eventModel: eventModel,
                              ),
                              fallbackBuilder: (context) => Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: MainColor.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.videocam_outlined,
                                      color: MainColor.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Online Event",
                                          style: TextStyle(
                                            color: MainColor.greyTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // copy link
                                        Visibility(
                                          visible: eventModel.link != null &&
                                              (type == EventDetailType.owner ||
                                                  type ==
                                                      EventDetailType
                                                          .participant ||
                                                  type ==
                                                      EventDetailType
                                                          .receptionist) &&
                                              eventModel.link!.isNotEmpty &&
                                              (eventStatus ==
                                                  EventStatus.onGoing),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.find<DetailEventController>()
                                                  .copyToClipboard(
                                                      eventModel.link ?? "");
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.link,
                                                  color:
                                                      MainColor.greyTextColor,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  eventModel.link ?? "",
                                                  style: const TextStyle(
                                                    color:
                                                        MainColor.greyTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: MainColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: MainColor.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              DateTime.tryParse(eventModel.startDate ?? "")
                                  ?.isSameDay(
                                DateTime.tryParse(eventModel.endDate ?? ""),
                              ) ??
                              false,
                          widgetBuilder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tz.TZDateTime.from(
                                  DateTime.tryParse(
                                          eventModel.startDate ?? "") ??
                                      DateTime.now(),
                                  tz.getLocation(eventModel.timeZone ?? ''),
                                ).toLocal().toHumanDateLongNoDay(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${tz.TZDateTime.from(DateTime.tryParse(eventModel.startDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanDateShortWithHour()} - ${tz.TZDateTime.from(DateTime.tryParse(eventModel.endDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanHour()}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: MainColor.greyTextColor,
                                ),
                              ),
                            ],
                          ),
                          fallbackBuilder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${tz.TZDateTime.from(DateTime.tryParse(eventModel.startDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanDateLongNoDay()} - ${tz.TZDateTime.from(DateTime.tryParse(eventModel.endDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanDateLongNoDay()}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${tz.TZDateTime.from(DateTime.tryParse(eventModel.startDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanDateShortWithHour()} - ${tz.TZDateTime.from(DateTime.tryParse(eventModel.endDate ?? "") ?? DateTime.now(), tz.getLocation(eventModel.timeZone ?? '')).toLocal().toHumanDateShortWithHour()}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: MainColor.greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // creator info
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: MainColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            eventModel.createdBy?.photo ?? "",
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CustomShimmerWidget.avatar(
                                width: 50,
                                height: 50,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: MainColor.primary,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventModel.createdBy?.name ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Organizer",
                              style: TextStyle(
                                fontSize: 14,
                                color: MainColor.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (type == EventDetailType.owner &&
                          eventModel.isImported == 1) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                              color: MainColor.info,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Text(
                            "Imported",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "About Event",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ReadMoreText(
                    eventModel.description ?? "",
                    trimLines: 5,
                    colorClickableText: MainColor.primary,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Read more',
                    trimExpandedText: ' Show less',
                    style: const TextStyle(
                      fontSize: 14,
                      color: MainColor.greyTextColor,
                    ),
                  ),
                  ...Conditional.list(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        eventModel.participants != null &&
                        eventModel.participants!.isNotEmpty,
                    widgetBuilder: (context) => [
                      const SizedBox(height: 24),
                      const Text(
                        "Participants",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 24,
                        child: StackParticipant(
                          createdBy: (eventModel.participants ?? []).length > 5
                              ? (eventModel.participants ?? [])
                                  .getRange(0, 5)
                                  .toList()
                              : eventModel.participants ?? [],
                          fontSize: 12,
                          width: 20,
                          height: 20,
                          positionText:
                              (eventModel.participants ?? []).length > 5
                                  ? (((eventModel.participants ?? [])
                                                  .getRange(0, 5)
                                                  .toList())
                                              .length *
                                          12.0) +
                                      18
                                  : null,
                          totalParticipant:
                              (eventModel.participants?.length ?? 0) - 5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      );
}

class _LocationWidget extends StatelessWidget {
  const _LocationWidget({
    required this.eventModel,
  });

  final EventData eventModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          enableDrag: false,
          isScrollControlled: true,
          builder: (context) {
            return GetBuilder<DetailEventController>(
              init: Get.find<DetailEventController>()..getCurrentLocation(),
              builder: (eventController) {
                return Container(
                  height: 0.5.sh,
                  width: 1.sw,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Obx(
                    () {
                      return eventController.userPosition.value.whenOrNull(
                            loading: () => CustomShimmerWidget.card(
                              height: 0.25.sh,
                              width: 1.sw,
                            ),
                            success: (position) {
                              return MapWidget(
                                eventModel: eventModel,
                                position: position,
                              );
                            },
                            error: (message) => Center(
                              child: Text(message),
                            ),
                          ) ??
                          const SizedBox();
                    },
                  ),
                );
              },
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MainColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: MainColor.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              eventModel.location ?? "",
              style: const TextStyle(color: MainColor.greyTextColor),
            ),
          )
        ],
      ),
    );
  }
}
