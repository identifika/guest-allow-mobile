class EndpointConstant {
  EndpointConstant._();

  static const String baseUrl = "http://172.20.10.3:8000/api";

  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";

  static const String getPopularEvent = "/events/popular";
  static const String event = "/events";
  static String eventDetail(String id) => "/events/$id";
  static String joinEvent(String id) => "/events/$id/join";
  static String leaveEvent(String id) => "/events/$id/leave";

  static const String getRegisteredUsers = "/users/all";
  static const String getMyEvents = "/users/my-events";
  static const String userFace = "/users/face";
  static const String userParticipating = "/users/participating";
  static const String userReceptionist = "/users/receptionists";
  static const String eachDateTotalEvent = "/users/total-events";
}
