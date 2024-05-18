import 'dart:async';
import 'dart:io';

import 'package:avms/core/extensions/navigation_ext.dart';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/core/utils/new_validate.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/features/auth/presentation/cubit/register_cubit/reg_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/register_cubit/reg_state.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<String> getLocalIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      print('Failed to get local IP address: $e');
    }
    return 'Failed to get IP address';
  }

  Future<String> getPublicIpAddress() async {
    final url = Uri.parse('https://httpbin.org/ip');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['origin'];
      } else {
        print('Failed to get public IP address: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to get public IP address: $e');
    }
    return 'Failed to get IP address';
  }



  String localIp = 'Fetching...';
  String publicIp = 'Fetching...';

  @override
  void initState() {
    super.initState();
    fetchIpAddresses();
  }

  Future<void> fetchIpAddresses() async {
    String local = await getLocalIpAddress();
    String public = await getPublicIpAddress();
    setState(() {
      localIp = local;
      publicIp = public;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController? nameController = TextEditingController();
  final TextEditingController ?emailController = TextEditingController();

  final TextEditingController? phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                      width: SizeConfig.screenWidth * 0.35,
                      AppStrings.appLogo,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                Center(
                  child: Card(
                    semanticContainer: true,
                    elevation: elevation,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Config.Localization['signup'],
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontSize: FontSize.s20,
                                fontFamily: FontFamily.fontFamily,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: smallPadding,
                                  vertical: midPadding),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.offWhite,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 5.0,
                                      color: AppColors.secondaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.offWhite,
                                      width: 5.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: Config.Localization['fullName'],
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: AppColors.appColor,
                                  ),
                                ),
                                validator: Validator.validateName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: TextFormField(
                                controller: emailController,
                                validator: Validator.validateEmail,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.offWhite,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 5.0,
                                      color: AppColors.secondaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.offWhite,
                                      width: 5.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: Config.Localization['email'],
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: AppColors.appColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: TextFormField(
                                controller: phoneController,
                                validator: Validator.validatePhone,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.offWhite,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 5.0,
                                      color: AppColors.secondaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.offWhite,
                                      width: 5.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: Config.Localization['phone'],
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: AppColors.appColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Your IP Address: $publicIp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AppSpaces.vSpace20,
                            BlocConsumer<RegCubit, RegState>(
                              builder: (context, state) {
                                return ConditionalBuilder(
                                  condition: state is! RegLoading,
                                  builder: (context) => MainButton(
                                    text: 'signup',
                                    onPressed: () {

                                      FocusScope.of(context).unfocus();
                                      if (!_formKey.currentState!.validate())
                                        return;

                                      _formKey.currentState!.save();
                                      RegCubit.get(context).createAccount(nameController!.text, phoneController!.text, publicIp, emailController!.text, '122');

                                      // Perform sign up action
                                    },
                                  ),
                                  fallback: (context) =>
                                      CircularProgressIndicator(),
                                );
                              },
                              listener: (context, state) {
                                if (state is RegLoading) {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));                             }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('If you have Account?'),
                                TextButton(onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                }, child: Text('SignIn',)),
                              ],
                            )

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
      ),
    );
  }
}
