import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/constants/cores/endpoint_constant.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';

class ApiServices {
  ApiServices._();

  static ApiServices? _instance;
  Dio _dioCall() {
    Dio dio = Dio();
    dio.options.baseUrl = EndpointConstant.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${LocalDbService.getUserToken()}';
    dio.interceptors.add(LoggedOutInterceptor());

    return dio;
  }

  static Dio call() {
    _instance ??= ApiServices._();
    return _instance!._dioCall();
  }
}

class LoggedOutInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if ('${err.response?.data['message']}'.toLowerCase() ==
          'unauthenticated') {
        if (getx.Get.isDialogOpen ?? false) {
          return;
        }
        CustomDialogWidget.showDialogProblem(
          title: 'Sesi Anda telah berakhir',
          description: 'Silakan login kembali',
          buttonOnTap: () async {
            await LocalDbService.clearLocalData();
            getx.Get.offAllNamed(MainRoute.signIn);
          },
          barrierDismissible: false,
        );
      }
    }
    super.onError(err, handler);
  }
}
