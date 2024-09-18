import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';

class ReceptionistGuestResponse {
  EventData? event;
  ReceptionistGuest? receptionists;

  ReceptionistGuestResponse({
    this.event,
    this.receptionists,
  });

  ReceptionistGuestResponse copyWith({
    EventData? event,
    ReceptionistGuest? receptionists,
  }) =>
      ReceptionistGuestResponse(
        event: event ?? this.event,
        receptionists: receptionists ?? this.receptionists,
      );

  factory ReceptionistGuestResponse.fromJson(Map<String, dynamic> json) =>
      ReceptionistGuestResponse(
        event: json["event"] == null ? null : EventData.fromJson(json["event"]),
        receptionists: json["receptionists"] == null
            ? null
            : ReceptionistGuest.fromJson(json["receptionists"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event?.toJson(),
        "receptionists": receptionists?.toJson(),
      };
}
