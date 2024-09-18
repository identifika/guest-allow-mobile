import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/event.controller.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                  ),
                ],
              ),
              child: GetBuilder<EventController>(
                id: 'calendar',
                builder: (state) {
                  return TableCalendar(
                    locale: 'en_US',
                    focusedDay: state.selectedDate,
                    selectedDayPredicate: (day) {
                      return isSameDay(state.selectedDate, day);
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    availableGestures: AvailableGestures.all,
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    onDaySelected: (selectedDay, focusedDay) {
                      state.changeSelectedDate(selectedDay);
                    },
                    availableCalendarFormats: const {
                      CalendarFormat.week: 'Week',
                    },
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: MainColor.primaryDarker,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: MainColor.primaryDarker,
                      ),
                    ),
                    onPageChanged: (focusedDay) => state.setDateRange(
                      focusedDay,
                    ),
                    calendarFormat: CalendarFormat.week,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MainColor.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (context, date, events) {
                        return Obx(
                          () => state.eachDateTotalEventState.value.when(
                            success: (data) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1.sw,
                              child: Badge(
                                backgroundColor: MainColor.primary,
                                isLabelVisible: state.checkIfDateOnList(date),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    color: MainColor.blackTextColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            empty: (message) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1.sw,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: MainColor.blackTextColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            loading: () => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1.sw,
                              child: CustomShimmerWidget.card(
                                height: 16.sp,
                                width: 16.sp,
                              ),
                            ),
                            error: (message) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1.sw,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: MainColor.blackTextColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            idle: () => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1.sw,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: MainColor.blackTextColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, date, events) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MainColor.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            GetBuilder<EventController>(
              id: 'widget',
              builder: (state) {
                return Column(
                  children: [
                    ...state.widget,
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
