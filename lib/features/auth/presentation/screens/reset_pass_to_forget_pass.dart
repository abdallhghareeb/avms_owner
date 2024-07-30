import 'dart:developer';

import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordToForgetPassScreen extends StatefulWidget {
  static const route = 'ResetPassword';

  const ResetPasswordToForgetPassScreen({super.key});

  @override
  State<ResetPasswordToForgetPassScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordToForgetPassScreen> {
  late final TextEditingController codeController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController emailController;

  final resetFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  bool isPasswordHidden = true;

  void changePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
    log("isPasswordHidden ${isPasswordHidden}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthResetPasswordSuccess) {
            // showInformationDialog(context: context, title:"resetPass", content:"resetMessageSentSuccessfully");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                padding: EdgeInsets.all(borderRadius),
                child: Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppStrings.appLogo,
                          width: SizeConfig.screenWidth * 0.35,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                      ],
                    ),
                    Center(
                      child: Card(
                        semanticContainer: true,
                        elevation: elevation,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(
                              borderRadius,
                            ),
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 16,
                          ),
                          child: Form(
                            key: resetFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Config.Localization['ResetPassword'],
                                  style: TextStyle(
                                    color: AppColors.appColor,
                                    fontSize: FontSize.s20,
                                    fontFamily: FontFamily.fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).tr(),
                                AppSpaces.vSpace20,
                                Padding(
                                  padding: const EdgeInsets.all(smallPadding),
                                  child: TextFormField(
                                    controller: codeController,
                                    decoration: TextFieldDecoration.copyWith(
                                      labelText: Config.Localization['Code'],
                                      prefixIcon: Icon(
                                        Icons.code,
                                        color: AppColors.appColor,
                                      ),
                                    ),
                                    validator: validator,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(smallPadding),
                                  child: TextFormField(
                                    controller: newPasswordController,
                                    obscureText: isPasswordHidden,
                                    maxLength: 10, // Max length set to 10
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'New Password is required';
                                      } else if (value.length > 10) {
                                        return 'New Password must be at most 10 characters long';
                                      }
                                      return null;
                                    },
                                    decoration: TextFieldDecoration.copyWith(
                                      labelText: Config.Localization['NewPassword'],
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: AppColors.appColor,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            changePasswordVisibility();
                                          });
                                        },
                                        child: Icon(
                                          isPasswordHidden
                                              ? Icons.visibility_sharp
                                              : Icons.visibility_off_sharp,
                                          color: AppColors.appColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(smallPadding),
                                  child: TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: isPasswordHidden,
                                    maxLength: 10, // Max length set to 10
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Confirm Password is required';
                                      } else if (value.length > 10) {
                                        return 'Confirm Password must be at most 10 characters long';
                                      } else if (value != newPasswordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    decoration: TextFieldDecoration.copyWith(
                                      labelText: Config.Localization['ConfirmPassword'],
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: AppColors.appColor,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            changePasswordVisibility();
                                          });
                                        },
                                        child: Icon(
                                          isPasswordHidden
                                              ? Icons.visibility_sharp
                                              : Icons.visibility_off_sharp,
                                          color: AppColors.appColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AppSpaces.vSpace20,
                                // Reset Password button
                                BlocConsumer<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    return ConditionalBuilder(
                                      condition: state is! AuthLoading,
                                      builder: (context) => MainButton(
                                        text: Config.Localization['ResetPassword'],
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (!resetFormKey.currentState!.validate()) return;
                                          resetFormKey.currentState!.save();

                                          // Retrieve email from shared preferences or other source

                                            AuthCubit.get(context).resetPassword(
                                              email: SaveEmailForgetPass!,
                                              code: codeController.text,
                                              password: newPasswordController.text,
                                              confirmPassword: confirmPasswordController.text,
                                            );
                                          }

                                      ),
                                      fallback: (context) => CircularProgressIndicator(),
                                    );
                                  },
                                  listener: (BuildContext context, AuthState state) async {
                                    if (state is AuthResetPasswordSuccess) {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('ResetSave', 'SuccessReset');
                                      Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_LONG,
                                        msg: "${'Success'}",
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                    } else if (state is AuthAuthForgotPasswordError) {

                                    }
                                  },
                                ),
                                AppSpaces.vSpace20,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
