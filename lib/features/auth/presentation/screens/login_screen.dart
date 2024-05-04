import 'dart:developer';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController? userNameController;
  late final TextEditingController? passwordController;
  final loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController?.dispose();
    passwordController?.dispose();
  }

  bool isPasswordHidden = true;

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    log("isPasswordHidden ${isPasswordHidden}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          padding: EdgeInsetsDirectional.all(borderRadius),
          child: Stack(clipBehavior: Clip.antiAliasWithSaveLayer, children: [
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
                      horizontal: 10.0, vertical: 16),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "login",
                          style: TextStyle(
                            color: AppColors.appColor,
                            fontSize: FontSize.s20,
                            fontFamily: FontFamily.fontFamily,
                            fontWeight: FontWeightManager.bold,
                          ),
                        ).tr(),
                        AppSpaces.vSpace20,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: smallPadding, vertical: midPadding),
                          child: TextFormField(
                            controller: userNameController,
                            decoration: TextFieldDecoration.copyWith(
                              labelText: 'E-mail',
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppColors.appColor,
                              ),
                            ),
                            validator: validator,
                          ),
                        ),
                        // AppSpaces.vSpace10,
                        Padding(
                          padding: const EdgeInsets.all(smallPadding),
                          child: TextFormField(
                              controller: passwordController,
                              obscureText: isPasswordHidden,
                              validator: validator,
                              decoration: TextFieldDecoration.copyWith(
                                labelText: 'password'.tr(),
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
                                text: "login",
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (!loginFormKey.currentState!.validate())
                                    return;

                                  loginFormKey.currentState!.save();
                                  AuthCubit.get(context).signIn(
                                    userNameController!.text,
                                    passwordController!.text,
                                  );
                                },
                              ),
                              fallback: (context) =>
                                  CircularProgressIndicator(),
                            );
                          },
                          listener: (BuildContext context, AuthState state) {
                            if (state is AuthAuthenticated) {
                              Navigator.pushReplacementNamed(
                                context,
                                HomeScreen.route,
                              );
                            }
                          },
                        ),
                        AppSpaces.vSpace20,
                        // Forgot password link
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ForgetPasswordScreen.route,
                            );
                          },
                          child: Text(
                            'forgetPass',
                            style: TextStyle(
                                color: AppColors.appColor,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Spacer(
            //   flex: 10,
            // ),
          ]),
        ),
      ),
    );
  }
}
