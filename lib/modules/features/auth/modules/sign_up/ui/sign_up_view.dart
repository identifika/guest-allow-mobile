import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_up/controllers/sign_up.controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Scaffold(
      backgroundColor: MainColor.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: 1.sh,
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
              SingleChildScrollView(
                child: SafeArea(
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
                          "Sign Up",
                          style: TextStyle(
                            color: MainColor.black,
                            fontSize: 32.r,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 48.h,
                        ),
                        TextField(
                          controller: controller.nameController,
                          keyboardType: TextInputType.name,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: const TextStyle(
                              color: MainColor.black,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: MainColor.black,
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
                                color: MainColor.black,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextField(
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: MainColor.black,
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
                                color: MainColor.black,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomLoginTextField(
                          controller: controller.passwordController,
                          hint: 'Password',
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomLoginTextField(
                          controller: controller.confirmPasswordController,
                          hint: 'Confirm Password',
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 56.h,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isFormValid.value
                                  ? () {
                                      controller.signUp();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MainColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: MainColor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: MainColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Text(
                                " Sign In",
                                style: TextStyle(
                                  color: MainColor.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoginTextField extends StatefulWidget {
  const CustomLoginTextField({
    super.key,
    this.hint,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
  });

  final String? hint;
  final TextEditingController? controller;
  final Function()? onEditingComplete;
  final Function()? onSubmitted;

  @override
  State<CustomLoginTextField> createState() => _CustomLoginTextFieldState();
}

class _CustomLoginTextFieldState extends State<CustomLoginTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscure,
      keyboardType: TextInputType.visiblePassword,
      controller: widget.controller,
      onEditingComplete: () {
        if (widget.onEditingComplete != null) {
          widget.onEditingComplete!();
        }
      },
      onSubmitted: (value) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        }
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: MainColor.black,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: MainColor.black,
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
            color: MainColor.black,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
