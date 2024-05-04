import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/widgets/alert_dialog.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const route = 'ForgetPassword';

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final TextEditingController emailRecoveryController;

  @override
  void initState() {
    super.initState();
    emailRecoveryController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailRecoveryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            showCustomAdaptiveDialog(
              context: context,
              title: "resetPass",
              content: "resetMessageSentSuccessfully",
              showCancelButton: false,
              onOkPressed: () => Navigator.pushReplacementNamed(
                  context, ResetPasswordScreen.route,
                  arguments: state.recoveryEmail
              ),
            );
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
                          horizontal: 10.0, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "SendCodeToEmail",
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
                              horizontal: smallPadding,
                              vertical: midPadding,
                            ),
                            child: TextFormField(
                              controller: emailRecoveryController,
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
                          AppSpaces.vSpace20,
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return ConditionalBuilder(
                                condition: state is! AuthForgotPasswordLoading,
                                builder: (context) => MainButton(
                                  text: "send",
                                  onPressed: () {
                                    AuthCubit.get(context).forgotPassword(
                                        emailRecoveryController.text);
                                  },
                                ),
                                fallback: (context) =>
                                    CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Spacer(
                //   flex: 10,
                // ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
