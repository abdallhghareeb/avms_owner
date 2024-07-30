import 'dart:developer';
import 'dart:io';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:avms/features/auth/presentation/screens/register_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController? userNameController;
  late final TextEditingController? passwordController;

  String? ChangeValue;
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

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId; // Unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    }
    return '';
  }

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
                          Config.Localization['login'],
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
                              labelText: Config.Localization['email'],
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
                                labelText: Config.Localization['password'],
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
                                text: Config.Localization['login'],
                                onPressed: () async {
                                  String deviceId = await getDeviceId();
                                  print(deviceId);
                                  FocusScope.of(context).unfocus();
                                  if (!loginFormKey.currentState!.validate())
                                    return;
                                  SaveNavToLoginWhenSaveApiUrl = false;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('apiUrlSave', false);
                                  loginFormKey.currentState!.save();
                                  AuthCubit.get(context).signIn(
                                      userNameController!.text,
                                      passwordController!.text,
                                      '$deviceId');
                                },
                              ),
                              fallback: (context) =>
                                  CircularProgressIndicator(),
                            );
                          },
                          listener:
                              (BuildContext context, AuthState state) async {
                            if (state is AuthAuthenticated) {
                              SharedPreferences prefs;
                              prefs = await SharedPreferences.getInstance();

                              CacheHelper.userToken = state.user.token;
                              TokenSave = state.user.token;

                              String? tokenDecode = state.user.token;
                              TokenSave = tokenDecode;

                              Map<String, dynamic> decodedToken =
                                  JwtDecoder.decode(tokenDecode!);
                              CacheHelper.userId = decodedToken['UserId'];
                              prefs.setString(
                                  'TokenUserId', '${CacheHelper.userId}');
                              prefs.setString('TokenUser', '${TokenSave}');

                              // Print the userId
                              print('UserId: ${CacheHelper.userId}');
                              // Print the decoded token
                              print('Decoded Token: ${decodedToken}');

                              print(state.user.token);

                              Fluttertoast.showToast(
                                  msg: 'Login Successful',
                                  backgroundColor: Colors.green);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else if (state is AuthError) {}
                          },
                        ),

                        AppSpaces.vSpace20,
                        // Forgot password link
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPasswordScreen()),
                            );
                          },
                          child: Text(
                            Config.Localization['forgetPass'],
                            style: TextStyle(
                                color: AppColors.appColor,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'If you want to SignUp',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: FontSize.s15),
                              ),
                              AppSpaces.hSpace5,
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child:
                                      Text('${Config.Localization['SignUp']}'))
                            ],
                          ),
                        )
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
