import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/shared/widgets/stack_participant.dart';
import 'package:guest_allow/utils/extensions/date.extension.dart';
import 'package:shimmer/shimmer.dart';

class MyTicketCard extends StatelessWidget {
  const MyTicketCard({super.key, required this.eventData});
  final EventData eventData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      child: Column(
        children: [
          SizedBox(
            height: 120.0,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: 120.0,
                  width: 1.sw,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: Image.network(
                      eventData.photo ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.grey[300],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: eventData.participantsCount != null &&
                      eventData.participantsCount! > 0,
                  child: Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.0.r),
                      width: 0.5.sw,
                      height: 40.0.r,
                      decoration: BoxDecoration(
                        color: MainColor.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                        ),
                      ),
                      child: StackParticipant(
                        width: 20,
                        height: 20,
                        fontSize: 12,
                        positionText: (eventData.participantsCount ?? 0) > 5
                            ? 95
                            : ((eventData.participantsCount ?? 0) * 14.0) + 12,
                        createdBy: eventData.participants,
                        totalParticipant: eventData.participantsCount,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0.r,
              vertical: 8.0.r,
            ),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTime.tryParse(
                            eventData.startDate ?? '',
                          )?.toHumanDateTimeWithoutHour() ??
                          '',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: MainColor.greyTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 1.sw - 80.w,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              eventData.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 16.0.r,
                                  color: MainColor.greyTextColor,
                                ),
                                SizedBox(width: 4.0.r),
                                Text(
                                  DateTime.tryParse(
                                        eventData.startDate ?? '',
                                      )?.toHumanTime() ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: MainColor.greyTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          eventData.location ?? '',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: MainColor.greyTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
