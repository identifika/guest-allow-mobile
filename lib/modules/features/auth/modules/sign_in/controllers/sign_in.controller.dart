import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/responses/sign_in.response.dart';
import 'package:guest_allow/modules/features/auth/repositories/auth.repository.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  SignInResponse? signInResponse;

  bool isSignInButtonEnabled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Rx<UIState<SignInResponse>> signInState =
      const UIState<SignInResponse>.idle().obs;

  Future<void> signIn() async {
    CustomDialogWidget.showLoading();
    signInResponse = await _authRepository.signIn(
      emailController.text,
      passwordController.text,
    );
    CustomDialogWidget.closeLoading();

    if (ApiStatusHelper.getApiStatus(signInResponse?.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      signInSuccessHandler(signInResponse?.user, signInResponse?.token ?? '');

      Get.offAllNamed(MainRoute.main);
    } else {
      CustomDialogWidget.showDialogProblem(
        title: 'Gagal',
        description: signInResponse?.message ?? '',
      );
    }
  }

  void signInSuccessHandler(UserModel? user, String token) {
    UserLocalData data = UserLocalData(
      id: 1,
      token: token,
      userId: user?.id,
      email: user?.email,
      name: user?.name,
      photo: user?.photo,
      emailVerifiedAt: user?.emailVerifiedAt,
      faceIdentifier: user?.faceIdentifier,
      createdAt: user?.createdAt,
      updatedAt: user?.updatedAt,
    );
    LocalDbService.insertUserLocalData(data);
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      update(['signInButton']);
    });

    passwordController.addListener(() {
      update(['signInButton']);
    });
  }
}
