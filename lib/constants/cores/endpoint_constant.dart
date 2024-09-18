class EndpointConstant {
  EndpointConstant._();

  static const String baseUrl = "https://absensi.ramadani.site/api";
  static const String faceBaseUrl = "https://api.ramadani.site";

  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String forgotPassword = "/auth/forgot-password";

  static const String getPopularEvent = "/events/popular";
  static const String event = "/events";
  static const String myEvents = "/events/my";
  static const String eventImport = "/events/import";
  static const String accessAsReceptionist = "/events/receptionist";
  static String editEvent(String id) => "/events/$id/update";
  static String deleteEvent(String id) => "/events/$id/delete";
  static String eventDetail(String id) => "/events/$id";
  static String joinEvent(String id) => "/events/$id/join";
  static String leaveEvent(String id) => "/events/$id/leave";
  static String attendEvent(String id) => "/events/$id/check-in";
  static String guestAttendEvent(String id) => "/events/$id/check-in-guest";
  static String receiveAttende(String id) => "/events/$id/receive-attendee";
  static String getEventParticipants(String id) => "/events/$id/participants";
  static String getEventReceptionists(String id) => "/events/$id/receptionists";
  static String addGuest(String id) => "/events/$id/add-guests";
  static String getEventByUniqueCode(String uniqueCode) =>
      "/events/unique-code/$uniqueCode";
  static String receiveGuest(String eventId) =>
      "/events/receive-guest/$eventId";
  static String inviteGuests(String eventId) =>
      "/events/$eventId/invite-guests";
  static String deleteGuest(String eventId, String guestId) =>
      "/events/$eventId/delete-guest/$guestId";
  static String addReceptionist(String eventId) =>
      "/events/$eventId/add-receptionist";
  static String deleteReceptionist(
          String eventId, String receptionistGuestId) =>
      "/events/$eventId/delete-receptionist/$receptionistGuestId";
  static String inviteReceptionists(String eventId) =>
      "/events/$eventId/invite-receptionists";
  static const String getRegisteredUsers = "/users/all";
  static const String getMyEvents = "/users/my-events";
  static const String userFace = "/users/face";
  static const String userParticipating = "/users/participating";
  static const String userReceptionist = "/users/receptionists";
  static const String eachDateTotalEvent = "/users/total-events";
  static const String userNotifications = '/users/notifications';
  static const String userUpdate = '/users/update';
  static String readNotif(String id) => '/users/notifications/$id';
}
