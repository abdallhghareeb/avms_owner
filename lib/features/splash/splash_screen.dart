import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/features/auth/presentation/screens/enter_your_baseUrl.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/screens/register_screen.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(
        const Duration(seconds: 2),
      ).whenComplete(
        () {
          if(SaveNavToLoginWhenSaveApiUrl==true){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

          }else if (CacheHelper.isLoginBefore) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          } else if(RigisterSave=='Registration successful'&& ResetPassSave!='SuccessReset'){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
          }else if(RigisterSave=='Registration successful'&& ResetPassSave=='SuccessReset'){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }
          else if(RigisterSave!='Registration successful'&&SaveApiUrl!= null){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
          } else if(RigisterSave!='Registration successful'&& ResetPassSave!='SuccessReset'&& SaveApiUrl==null){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ConfigScreen()));
          }
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('buuuiiiiillllddd');

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Image.asset(
              AppStrings.appLogo,
              width: SizeConfig.screenWidth * 0.6,
            ),
          ),
          PositionedDirectional(
            bottom: SizeConfig.screenHeight * 0.1,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
