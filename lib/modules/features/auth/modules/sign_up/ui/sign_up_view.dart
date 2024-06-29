import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/constants/commons/asset_constant.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
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
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Nama Lengkap",
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
                          keyboardType: TextInputType.emailAddress,
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
                        const CustomLoginTextField(
                          hint: 'Password',
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const CustomLoginTextField(
                          hint: 'Confirm Password',
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {},
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
  const CustomLoginTextField({super.key, this.hint, this.controller});

  final String? hint;
  final TextEditingController? controller;

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
