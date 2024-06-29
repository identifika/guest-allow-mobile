import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/shared/widgets/stack_participant.dart';

class CardPopularEvent extends StatelessWidget {
  final EventModel eventModel;

  const CardPopularEvent({required this.eventModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 250,
      decoration: BoxDecoration(
        color: MainColor.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          _buildCardImage(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 24,
                  child: StackParticipant(
                    fontSize: 12,
                    width: 20,
                    height: 20,
                    positionText: (eventModel.totalParticipant ?? 0) > 5
                        ? 95
                        : ((eventModel.totalParticipant ?? 0) * 12.0) + 16,
                    createdBy: eventModel.participants,
                    totalParticipant: eventModel.participants?.length ?? 0,
                  ),
                ),
                const SizedBox(height: 6),
                Conditional.single(
                  context: context,
                  conditionBuilder: (BuildContext context) =>
                      !(eventModel.isOnline),
                  fallbackBuilder: (context) => const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.link,
                          size: 14,
                          color: MainColor.greyTextColor,
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Online",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: MainColor.greyTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  widgetBuilder: (context) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: MainColor.greyTextColor,
                        ),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCardImage() => Container(
        width: 280,
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                eventModel.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: MainColor.greyTextColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.error,
                      color: MainColor.greyTextColor,
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
              )
            ],
          ),
        ),
      );
}
