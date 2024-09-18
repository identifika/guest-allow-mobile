import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/auth/repositories/auth.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get to =>
      Get.find<ForgotPasswordController>();

  TextEditingController emailController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool isSignInButtonEnabled() {
    return emailController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text);
  }

  void confirmation() {
    CustomDialogWidget.showDialogChoice(
      title: "Reset Password?",
      description: "Are you sure you want to send reset password link?",
      onTapPositiveButton: () {
        Get.back();
        sendLink();
      },
      onTapNegativeButton: () {
        Get.back();
      },
    );
  }

  Future<void> sendLink() async {
    CustomDialogWidget.showLoading();

    var response = await _authRepository.forgotPassword(
      email: emailController.text,
    );
    CustomDialogWidget.closeLoading();

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      await CustomDialogWidget.showDialogSuccess(
        title: 'Email Sent!',
        description: 'Check your email to reset your password!',
      );
      Get.back();
    } else {
      CustomDialogWidget.showDialogProblem(
        title: 'Failed',
        description: response.message ?? '',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      update(['signInButton']);
    });
  }
}
