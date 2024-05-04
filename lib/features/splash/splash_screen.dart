import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
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
          if (CacheHelper.isLoginBefore) {
            Navigator.pushReplacementNamed(context, HomeScreen.route);
          } else {
            Navigator.pushReplacementNamed(context, LoginScreen.route);
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
