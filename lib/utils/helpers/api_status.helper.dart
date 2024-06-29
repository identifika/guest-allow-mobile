import 'package:guest_allow/utils/enums/api_status.enum.dart';

class ApiStatusHelper {
  ApiStatusHelper._();

  static ApiStatusEnum getApiStatus(int status) {
    if (status > 100 && status <= 199) {
      return ApiStatusEnum.informational;
    } else if (status >= 200 && status <= 299) {
      return ApiStatusEnum.success;
    } else if (status >= 300 && status <= 399) {
      return ApiStatusEnum.redirect;
    } else if (status >= 400 && status <= 499) {
      return ApiStatusEnum.clientError;
    } else if (status >= 500 && status <= 599) {
      return ApiStatusEnum.serverError;
    } else {
      return ApiStatusEnum.clientError;
    }
  }
}
