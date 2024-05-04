import 'dart:developer';

import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const route = 'ResetPassword';

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController codeController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
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
    confirmPasswordController.dispose();
  }

  bool isPasswordHidden = true;

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    log("isPasswordHidden ${isPasswordHidden}");
  }

  @override
  Widget build(BuildContext context) {
    final recoveryEmail = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthResetPasswordSuccess) {
            // showInformationDialog(context: context, title:"resetPass", content:"resetMessageSentSuccessfully");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              padding: EdgeInsetsDirectional.all(borderRadius),
              child:
                  Stack(clipBehavior: Clip.antiAliasWithSaveLayer, children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      width: SizeConfig.screenWidth * 0.35,
                      AppStrings.appLogo,
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
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10.0,
                        vertical: 16,
                      ),
                      child: Form(
                        key: resetFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ResetPass",
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontSize: FontSize.s20,
                                fontFamily: FontFamily.fontFamily,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ).tr(),
                            AppSpaces.vSpace20,
                            Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: TextFormField(
                                controller: codeController,
                                decoration: TextFieldDecoration.copyWith(
                                  labelText: 'code'.tr(),
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
                                  validator: passwordValidator,
                                  decoration: TextFieldDecoration.copyWith(
                                    labelText: 'newPassword'.tr(),
                                    prefixIcon: Icon(
                                      Icons.key,
                                      color: AppColors.appColor,
                                    ),
                                    suffixIcon: isPasswordHidden
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                changePasswordVisibility();
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_sharp,
                                              color: AppColors.appColor,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                changePasswordVisibility();
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_off_sharp,
                                              color: AppColors.appColor,
                                            ),
                                          ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: isPasswordHidden,
                                  validator: (password) =>
                                      confirmPasswordValidator(
                                        newPasswordController.text,
                                        password,
                                      ),
                                  decoration: TextFieldDecoration.copyWith(
                                    labelText: 'confirmPassword'.tr(),
                                    prefixIcon: Icon(
                                      Icons.key,
                                      color: AppColors.appColor,
                                    ),
                                    suffixIcon: isPasswordHidden
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                changePasswordVisibility();
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_sharp,
                                              color: AppColors.appColor,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                changePasswordVisibility();
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_off_sharp,
                                              color: AppColors.appColor,
                                            ),
                                          ),
                                  )),
                            ),
                            AppSpaces.vSpace20,
                            // Login button
                            BlocConsumer<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ConditionalBuilder(
                                  condition: state is! AuthLoading,
                                  builder: (context) => MainButton(
                                    text: "ResetPass",
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (!resetFormKey.currentState!
                                          .validate()) return;

                                      resetFormKey.currentState!.save();
                                      AuthCubit.get(context).resetPassword(
                                        email: recoveryEmail,
                                        code: codeController.text,
                                        password: newPasswordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      );
                                    },
                                  ),
                                  fallback: (context) =>
                                      CircularProgressIndicator(),
                                );
                              },
                              listener:
                                  (BuildContext context, AuthState state) {
                                if (state is AuthResetPasswordSuccess) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    LoginScreen.route,
                                  );
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
              ]),
            ),
          );
        },
      ),
    );
  }
}
