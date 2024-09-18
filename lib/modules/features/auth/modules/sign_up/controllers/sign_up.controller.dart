import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/controllers/sign_in.controller.dart';
import 'package:guest_allow/modules/features/auth/repositories/auth.repository.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:guest_allow/utils/helpers/api_status.helper.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isFormValid = false.obs;

  final AuthRepository _authRepository = AuthRepository();

  Future<void> signUp() async {
    try {
      CustomDialogWidget.showLoading();
      var timezone = tz.local.name;

      var response = await _authRepository.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        timezone: timezone,
      );

      CustomDialogWidget.closeLoading();

      if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
        await CustomDialogWidget.showDialogSuccess(
          title: 'Registration Success',
          description:
              'Your account has been successfully registered, check your email to verify your account',
          duration: 5,
          buttonOnTap: () {
            Get.back();
          },
        );

        signIn();
        // resetForm();
      } else {
        CustomDialogWidget.showDialogProblem(
          title: 'Registration Failed',
          description: response.message ?? 'Please try again',
        );
      }
    } catch (e) {
      CustomDialogWidget.showDialogProblem(
        title: 'Registration Failed',
        description: e.toString(),
      );
    }
  }

  Future<void> signIn() async {
    CustomDialogWidget.showLoading();
    UserLocalData? oldData = await LocalDbService.getUserLocalData();

    var response = await _authRepository.signIn(
      emailController.text,
      passwordController.text,
      fcmToken: oldData?.token,
    );
    CustomDialogWidget.closeLoading();

    if (ApiStatusHelper.isApiSuccess(response.statusCode)) {
      signInSuccessHandler(response.user, response.token ?? "");

      Get.offAllNamed(MainRoute.main);
    } else {
      CustomDialogWidget.showDialogProblem(
        title: 'Login Failed',
        description: response.message ?? 'Please try again',
      );
    }
  }

  void signInSuccessHandler(UserModel? user, String token) async {
    UserLocalData? oldData = await LocalDbService.getUserLocalData();

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
      fcmToken: oldData?.fcmToken,
    );
    LocalDbService.insertUserLocalData(data);
  }

  void resetForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void checkFormValid() {
    isFormValid.value = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text &&
        emailController.text.isEmail;
  }

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(checkFormValid);
    emailController.addListener(checkFormValid);
    passwordController.addListener(checkFormValid);
    confirmPasswordController.addListener(checkFormValid);
  }
}
