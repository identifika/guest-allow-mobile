import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';
import 'package:guest_allow/shared/widgets/stack_participant.dart';

class CardThisMonthEvent extends StatelessWidget {
  final EventModel eventModel;
  final bool showIsImported;

  const CardThisMonthEvent({
    required this.eventModel,
    this.showIsImported = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  eventModel.image,
                  fit: BoxFit.cover,
                  width: 80,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: MainColor.lightGrey,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: MainColor.greyTextColor,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const CustomShimmerWidget.avatar(
                      width: 80,
                      height: 80,
                      padding: 0,
                      margin: 0,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    ...Conditional.list(
                      context: context,
                      conditionBuilder: (BuildContext context) =>
                          eventModel.totalParticipant != null &&
                          eventModel.totalParticipant! > 0 &&
                          eventModel.participants != null,
                      widgetBuilder: (context) => <Widget>[
                        const SizedBox(height: 4),
                        _locationWidget(context)
                      ],
                      fallbackBuilder: (context) => [
                        const SizedBox(height: 4),
                        Text(
                          eventModel.description,
                          maxLines: 2,
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: MainColor.greyTextColor,
                          ),
                        ),
                      ],
                    ),
                    ...Conditional.list(
                      context: context,
                      conditionBuilder: (BuildContext context) =>
                          eventModel.totalParticipant != null &&
                          eventModel.totalParticipant! > 0 &&
                          eventModel.participants != null,
                      widgetBuilder: (context) => <Widget>[
                        const SizedBox(height: 4),
                        Expanded(
                          child: StackParticipant(
                            width: 18,
                            height: 18,
                            fontSize: 10,
                            positionText: (eventModel.totalParticipant ?? 0) > 5
                                ? 80
                                : ((eventModel.totalParticipant ?? 0) * 12.0) +
                                    12,
                            createdBy: eventModel.participants,
                            totalParticipant:
                                (eventModel.totalParticipant ?? 0) > 5
                                    ? eventModel.totalParticipant! - 5
                                    : null,
                          ),
                        ),
                      ],
                      fallbackBuilder: (context) => [
                        const SizedBox(height: 4),
                        _locationWidget(context),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.w,
              ), // Add this line
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: MainColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      eventModel.date.split(" ")[0],
                      style: const TextStyle(
                        color: MainColor.primary,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      eventModel.date.split(" ")[1],
                      style: const TextStyle(
                        color: MainColor.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showIsImported && eventModel.isImported)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
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
            ),
        ],
      ),
    );
  }

  Widget _locationWidget(BuildContext context) {
    return Conditional.single(
      context: context,
      conditionBuilder: (BuildContext context) => !(eventModel.isOnline),
      widgetBuilder: (context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: MainColor.greyTextColor,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              eventModel.location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: MainColor.greyTextColor,
              ),
            ),
          )
        ],
      ),
      fallbackBuilder: (context) => const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_outlined,
            color: MainColor.greyTextColor,
            size: 14,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              "Online",
              style: TextStyle(
                fontSize: 12,
                color: MainColor.greyTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
