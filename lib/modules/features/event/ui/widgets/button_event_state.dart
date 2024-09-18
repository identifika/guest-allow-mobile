import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/detail_event.controller.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/shared/widgets/countdown_timer.widget.dart';
import 'package:timezone/timezone.dart' as tz;

class ButtonEventState extends StatelessWidget {
  const ButtonEventState({
    required this.eventModel,
    required this.type,
    required this.eventStatus,
    required this.controller,
    super.key,
  });

  final EventData eventModel;
  final EventDetailType type;
  final EventStatus eventStatus;
  final DetailEventController controller;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return GetBuilder<DetailEventController>(
      builder: (state) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Conditional.single(
              context: context,
              conditionBuilder: (context) => type == EventDetailType.guest,
              fallbackBuilder: (_) => SizedBox(
                child: ConditionalSwitch.single(
                  context: context,
                  valueBuilder: (context) => type,
                  caseBuilders: {
                    EventDetailType.owner: (context) =>
                        ConditionalSwitch.single(
                          context: context,
                          valueBuilder: (context) => eventStatus,
                          caseBuilders: {
                            EventStatus.onGoing: (context) => SizedBox(
                                  width: 1.sw,
                                  child: Conditional.single(
                                    context: context,
                                    conditionBuilder: (_) =>
                                        eventModel.type == 0,
                                    fallbackBuilder: (_) => ElevatedButton(
                                      onPressed: () {
                                        controller.receiveAttende(eventModel);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MainColor.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        maximumSize: const Size(200, 150),
                                      ),
                                      child: const Text(
                                        "Receive Attendees",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    widgetBuilder: (_) => ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                          MainRoute.showAttendees,
                                          arguments: eventModel,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MainColor.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        maximumSize: const Size(200, 150),
                                      ),
                                      child: const Text(
                                        "Show Attendees",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                            EventStatus.upcoming: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Get.toNamed(
                                        MainRoute.createEvent,
                                        arguments: eventModel,
                                      );

                                      controller
                                          .getEventDetail(eventModel.id ?? "");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: const Text(
                                      "Edit Event",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                            EventStatus.finished: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        MainRoute.showAttendees,
                                        arguments: eventModel,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: const Text(
                                      "Event is finished, Show Attendees",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                          },
                        ),
                    EventDetailType.participant: (context) =>
                        ConditionalSwitch.single(
                          context: context,
                          valueBuilder: (context) => eventStatus,
                          caseBuilders: {
                            EventStatus.onGoing: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (eventModel.type == 0) {
                                        Get.find<DetailEventController>()
                                            .attendOnlineEvent(
                                                eventModel.link ?? "",
                                                eventModel);
                                      } else {
                                        if (eventModel.myArrival == null) {
                                          if (controller.userLocalData
                                                  ?.faceIdentifier !=
                                              null) {
                                            Get.toNamed(
                                              MainRoute.attendEvent,
                                              arguments: eventModel,
                                            );
                                          } else {
                                            controller.dialogEnrollFace(
                                              type: 'attending',
                                              title: "Attend Event",
                                            );
                                          }
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: Text(
                                      eventModel.myArrival != null &&
                                              eventModel.type == 1
                                          ? "You are in this event"
                                          : "Attend Event",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                            EventStatus.upcoming: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: CountDownTimer(
                                      secondsRemaining: DateTime.tryParse(
                                                  eventModel.startDate ?? "")
                                              ?.difference(DateTime.now())
                                              .inSeconds ??
                                          0,
                                      whenTimeExpires: () {
                                        controller.getEventDetail(
                                            eventModel.id ?? "");
                                      },
                                      countDownTimerStyle: const TextStyle(
                                        fontSize: 16,
                                        color: MainColor.blackTextColor,
                                      ),
                                      text: "Event starts in",
                                    ),
                                  ),
                                ),
                            EventStatus.finished: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: const Text(
                                      "Event is finished",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                          },
                        ),
                    EventDetailType.receptionist: (context) =>
                        ConditionalSwitch.single(
                          context: context,
                          valueBuilder: (context) => eventStatus,
                          caseBuilders: {
                            EventStatus.onGoing: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.receiveAttende(eventModel);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: const Text(
                                      "Receive Attendees",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                            // count down
                            EventStatus.upcoming: (context) => SizedBox(
                                  // // count down
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: CountDownTimer(
                                      secondsRemaining: DateTime.tryParse(
                                                  eventModel.startDate ?? "")
                                              ?.difference(DateTime.now())
                                              .inSeconds ??
                                          0,
                                      whenTimeExpires: () {
                                        controller.getEventDetail(
                                            eventModel.id ?? "");
                                      },
                                      countDownTimerStyle: const TextStyle(
                                        fontSize: 16,
                                        color: MainColor.blackTextColor,
                                      ),
                                      text: "Event starts in",
                                    ),
                                  ),
                                ),
                            EventStatus.finished: (context) => SizedBox(
                                  width: 1.sw,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MainColor.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      maximumSize: const Size(200, 150),
                                    ),
                                    child: const Text(
                                      "Event is finished",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                          },
                        ),
                  },
                ),
              ),
              widgetBuilder: (_) => ConditionalSwitch.single(
                context: context,
                valueBuilder: (context) => eventStatus,
                caseBuilders: {
                  EventStatus.onGoing: (context) => SizedBox(
                        width: 1.sw,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.find<DetailEventController>().dialogJoinEvent(
                              eventModel.id ?? "",
                              eventModel.title ?? "",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColor.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            maximumSize: const Size(200, 150),
                          ),
                          child: const Text(
                            "Join Event",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                  EventStatus.upcoming: (context) => SizedBox(
                        width: 1.sw,
                        child: ElevatedButton(
                          onPressed: now.isAfter(tz.TZDateTime.from(
                            DateTime.tryParse(eventModel.startDate ?? "") ??
                                DateTime.now(),
                            tz.getLocation(eventModel.timeZone ?? ''),
                          ).toLocal())
                              ? null
                              : () {
                                  Get.find<DetailEventController>()
                                      .dialogJoinEvent(
                                    eventModel.id ?? "",
                                    eventModel.title ?? "",
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColor.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            maximumSize: const Size(200, 150),
                          ),
                          child: const Text(
                            "Join Event",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                  EventStatus.finished: (context) => SizedBox(
                        width: 1.sw,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColor.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            maximumSize: const Size(200, 150),
                          ),
                          child: const Text(
                            "Event is finished",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
