import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/reset_pass_to_forget_pass.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/widgets/alert_dialog.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const route = 'ForgetPassword';

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final TextEditingController emailRecoveryController;
  final Dio _dio = Dio(); // Create Dio instance
  bool _isLoading = false; // Track loading state

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

  Future<void> _sendRecoveryEmail(String email) async {
    final String apiUrl =
        '$BASE_URL$SaveApiUrl$postForgetPasswordEndPoint'; // Replace with your API URL

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await _dio.post(
        apiUrl,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final recoveryEmail = email; // Or extract from response if needed
        showCustomAdaptiveDialog(
            context: context,
            title: "resetPass",
            content: "resetMessageSentSuccessfully",
            showCancelButton: false,
            onOkPressed: () =>
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => ResetPasswordToForgetPassScreen()), (
                    route) => false));
            } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content:
        Text('Failed to send recovery email. Please try again.')),
        );
        }
        } catch (e)
        {
          // Handle request error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email is incorrect. Please try again.')),
          );
        } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
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
              onOkPressed: () =>
                  Navigator.pushReplacementNamed(
                    context,
                    ResetPasswordScreen.route,
                    arguments: state.recoveryEmail,
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
              child: Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
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
                          Radius.circular(borderRadius),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10.0,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${Config.Localization['SendCodeToEmail']}",
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontSize: FontSize.s18,
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
                                validator: nonEmptyValidator,
                                controller: emailRecoveryController,
                                decoration: TextFieldDecoration.copyWith(
                                  labelText: 'E-mail',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: AppColors.appColor,
                                  ),
                                ),
                              ),
                            ),
                            AppSpaces.vSpace20,
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ConditionalBuilder(
                                  condition: !_isLoading,
                                  builder: (context) =>
                                      MainButton(
                                        text: "${Config.Localization['send']}",
                                        onPressed: () async {
                                          final email =
                                              emailRecoveryController.text;
                                          SharedPreferences prefs;
                                          prefs =
                                          await SharedPreferences.getInstance();
                                          SaveEmailForgetPass =
                                              emailRecoveryController.text;
                                          prefs.setString('SaveEmailForgetPass',
                                              emailRecoveryController.text);
                                          _sendRecoveryEmail(email);
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
