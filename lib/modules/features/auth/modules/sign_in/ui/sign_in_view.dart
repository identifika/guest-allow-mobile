import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/controllers/sign_in.controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignInController>();

    return Scaffold(
      backgroundColor: MainColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1.sh,
                width: 1.sw,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetConstant.backgroundPattern),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 32.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 72.h,
                    ),
                    Text(
                      "Sign In",
                      style: TextStyle(
                        color: MainColor.black,
                        fontSize: 32.r,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Semantics(
                      identifier: 'emailTxtField',
                      child: TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: const TextStyle(
                            color: MainColor.black,
                            fontSize: 16,
                          ),
                          fillColor: MainColor.lightGrey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: MainColor.grey,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: MainColor.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: MainColor.grey,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomLoginTextField(
                      passwordController: controller.passwordController,
                      onSubmitted: (value) {
                        controller.signIn();
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: MainColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: 1.sw,
                      height: 56.h,
                      child: GetBuilder<SignInController>(
                        id: 'signInButton',
                        builder: (state) {
                          return ElevatedButton(
                            onPressed: state.emailController.text.isNotEmpty &&
                                    state.passwordController.text.isNotEmpty
                                ? () {
                                    controller.signIn();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MainColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: MainColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    SizedBox(
                      width: 1.sw,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(MainRoute.signUp);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: MainColor.primary,
                              width: 2,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: MainColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoginTextField extends StatefulWidget {
  const CustomLoginTextField({
    super.key,
    required this.passwordController,
    required this.onSubmitted,
  });

  final TextEditingController passwordController;
  final Function(String) onSubmitted;
  @override
  State<CustomLoginTextField> createState() => _CustomLoginTextFieldState();
}

class _CustomLoginTextFieldState extends State<CustomLoginTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscure,
      controller: widget.passwordController,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: const TextStyle(
          color: MainColor.black,
          fontSize: 16,
        ),
        fillColor: MainColor.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: MainColor.grey,
            width: 0.5,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: _isObscure ? MainColor.grey : MainColor.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: MainColor.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: MainColor.grey,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
