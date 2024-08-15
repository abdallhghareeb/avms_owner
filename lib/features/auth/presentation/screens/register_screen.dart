import 'dart:async';
import 'dart:io';
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
import 'package:avms/features/auth/presentation/screens/enter_your_baseUrl.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/area_unit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Future<List<Area>> futureAreasWitout;
  late Future<List<Area>> futureAreas;
  late Future<String> _deviceId;

  static int? selectedAreaId;
  static int? selectedAreaIdWithOut;
  XFile? _image;
  final pickedImage = ImagePicker();
  var imagePicked;
  bool checkUnitAdmin = false;
  bool checkUser = false;

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

  void UploadImage() async {
    imagePicked = await pickedImage.pickImage(source: ImageSource.gallery);
    print(imagePicked);
    setState(() {
      if (imagePicked != null) {
        _image = imagePicked;

        print(imagePicked.path);
      } else {
        print('no Image Picked');
      }
    });
  }

  // Initialize selectedAreaId as nullable int
  Future<String> _initDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId; // Unique ID on Android
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // Unique ID on iOS
      } else {
        return 'Unknown device';
      }
    } catch (e) {
      print('Failed to get device info: $e');
      return 'Failed to get device ID';
    }
  }

  String localIp = 'Fetching...';
  String publicIp = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _deviceId = _initDeviceId();
    futureAreas = DioHelper.fetchAreasWithOwners();
    futureAreasWitout = DioHelper.fetchAreasWithoutOwners();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController? nameController = TextEditingController();
  final TextEditingController? emailController = TextEditingController();

  final TextEditingController? phoneController = TextEditingController();
  List<String> _locations = ['user', 'UnitAdmin']; // Option 2
  String selectedLocation = 'user';

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
                        child: SingleChildScrollView(
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
                                padding: const EdgeInsets.all(12.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: _image != null
                                            ? Image.file(
                                                File(_image!.path),
                                                fit: BoxFit.cover,
                                              )
                                            : Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/defultImage/def1.png'),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          UploadImage();
                                        },
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/defultImage/camera.png'),
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                              AppSpaces.vSpace20,
                              Padding(
                                padding: EdgeInsets.only(right: 150.w),
                                child: Text(
                                  'Choice your Roles:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s16,
                                      color: AppColors.appColor),
                                ),
                              ),
                              AppSpaces.vSpace10,
                              DropdownButton(
                                hint: Text('Please choose a location'),
                                // Not necessary for Option 1
                                value: selectedLocation,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedLocation = newValue!;
                                  });
                                },
                                items: _locations.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                              AppSpaces.vSpace20,
                              Padding(
                                padding: EdgeInsets.only(right: 150.w),
                                child: Text(
                                  'Choice your Unit :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s16,
                                      color: AppColors.appColor),
                                ),
                              ),
                              if (selectedLocation == 'UnitAdmin')
                                FutureBuilder<List<Area>>(
                                  future: futureAreasWitout,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.warning_amber),
                                            Expanded(
                                              child: Text(
                                                  'There is a problem with the network'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasData) {
                                      List<Area> areas = snapshot.data!;
                                      return DropdownButton<int>(
                                        hint: Text('Select an Area'),
                                        value: selectedAreaIdWithOut,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedAreaIdWithOut = newValue;
                                          });
                                        },
                                        items: areas.map<DropdownMenuItem<int>>(
                                            (Area area) {
                                          return DropdownMenuItem<int>(
                                            value: area.id,
                                            child: Text(area.name),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Text('No data');
                                    }
                                  },
                                ),
                              if (selectedLocation == 'user')
                                FutureBuilder<List<Area>>(
                                  future: futureAreas,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.warning_amber),
                                            Expanded(
                                              child: Text(
                                                  'There is a problem with the network'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasData) {
                                      List<Area> areas = snapshot.data!;
                                      return DropdownButton<int>(
                                        hint: Text('Select an Area'),
                                        value: selectedAreaId,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedAreaId = newValue;
                                          });
                                        },
                                        items: areas.map<DropdownMenuItem<int>>(
                                            (Area area) {
                                          return DropdownMenuItem<int>(
                                            value: area.id,
                                            child: Text(area.name),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Text('No data');
                                    }
                                  },
                                ),
                              AppSpaces.vSpace20,
                              FutureBuilder<String>(
                                future: _deviceId,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else {
                                    String deviceId =
                                        snapshot.data ?? 'Unknown Device';
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Device ID: $deviceId',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              AppSpaces.vSpace20,
                              BlocConsumer<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return ConditionalBuilder(
                                    condition: state is! AuthLoading1,
                                    builder: (context) => MainButton(
                                      text: Config.Localization['SignUp'],
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (!_formKey.currentState!.validate())
                                          return;

                                        _formKey.currentState!.save();

                                        print(
                                            'Selected Location: $selectedLocation');
                                        if (selectedLocation == 'user') {
                                          print(
                                              'Selected Area ID (User): $selectedAreaId');
                                          SharedPreferences prefs;
                                          prefs = await SharedPreferences
                                              .getInstance();
                                          SaveEmailRegisterToReset =
                                              emailController!.text;
                                          String Id = await getDeviceId();
                                          print(Id);

                                          prefs.setString(
                                              'SaveEmailRegisterToReset',
                                              emailController!.text);

                                          if (_image != null) {
                                            AuthCubit.get(context).signUp(
                                                file: _image!,
                                                email: emailController!.text,
                                                phone: phoneController!.text,
                                                roles: selectedLocation,
                                                name: nameController!.text,
                                                uni: Id,
                                                area: '$selectedAreaId');
                                            checkUser = true;
                                            checkUnitAdmin = false;
                                          } else {
                                            ByteData? assetByteData =
                                                await rootBundle.load(
                                                    'assets/images/defultImage/def1.png');
                                            List<int> bytes = assetByteData
                                                .buffer
                                                .asUint8List();

                                            // Get temporary directory path
                                            Directory tempDir =
                                                await getTemporaryDirectory();
                                            String tempPath = tempDir.path;

                                            // Create temporary file and write bytes to it
                                            File tempFile =
                                                File('$tempPath/def1.png');
                                            await tempFile.writeAsBytes(bytes);

                                            setState(() {
                                              // Convert File to XFile
                                              _image = XFile(tempFile.path);
                                            });
                                            AuthCubit.get(context).signUp(
                                                file: _image,
                                                email: emailController!.text,
                                                phone: phoneController!.text,
                                                roles: selectedLocation,
                                                name: nameController!.text,
                                                uni: Id,
                                                area: '$selectedAreaId');
                                            checkUser = true;
                                            checkUnitAdmin = false;
                                          }
                                        } else if (selectedLocation ==
                                            'UnitAdmin') {
                                          String Id = await getDeviceId();
                                          print(
                                              'Selected Area ID (UnitAdmin): $selectedAreaIdWithOut');
                                          int? value = selectedAreaIdWithOut;
                                          if (_image != null) {
                                            AuthCubit.get(context).signUp(
                                                file: _image!,
                                                email: emailController!.text,
                                                phone: phoneController!.text,
                                                roles: selectedLocation,
                                                name: nameController!.text,
                                                uni: Id,
                                                area: '$value');
                                            checkUnitAdmin = true;
                                            checkUser = false;
                                          } else {
                                            ByteData? assetByteData =
                                                await rootBundle.load(
                                                    'assets/images/defultImage/def1.png');
                                            List<int> bytes = assetByteData
                                                .buffer
                                                .asUint8List();

                                            // Get temporary directory path
                                            Directory tempDir =
                                                await getTemporaryDirectory();
                                            String tempPath = tempDir.path;

                                            // Create temporary file and write bytes to it
                                            File tempFile =
                                                File('$tempPath/def1.png');
                                            await tempFile.writeAsBytes(bytes);

                                            setState(() {
                                              // Convert File to XFile
                                              _image = XFile(tempFile.path);
                                            });
                                            AuthCubit.get(context).signUp(
                                                file: _image,
                                                email: emailController!.text,
                                                phone: phoneController!.text,
                                                roles: selectedLocation,
                                                name: nameController!.text,
                                                uni: Id,
                                                area: '$value');
                                            checkUnitAdmin = true;
                                            checkUser = false;
                                          }
                                        }
                                      },
                                    ),
                                    fallback: (context) =>
                                        CircularProgressIndicator(),
                                  );
                                },
                                listener: (context, state) async {
                                  if (state is AuthLoading1) {
                                    print('lllllllod');
                                  } else if (state is AuthAuthenticatedSignUp) {
                                    SharedPreferences prefs;
                                    prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('RigisterSave',
                                        'Registration successful');
                                    saveEmail = emailController!.text;
                                    prefs.setString(
                                        'emailSave', '${saveEmail}');
                                    SaveEmailRegisterToReset =
                                        emailController!.text;

                                    print(state.registerResponse.message);
                                    print(state.registerResponse.message);
                                    Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_LONG,
                                        msg:
                                            "${state.registerResponse.data!.confirmMessage}",
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    print(
                                        ' dattttta ${state.registerResponse.message}');
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPasswordScreen()),
                                        (route) => false);
                                    print('zay el foul');
                                  } else if (state is AuthError1) {
                                    if (selectedAreaIdWithOut == null &&
                                        checkUnitAdmin == true) {
                                      Fluttertoast.showToast(
                                          toastLength: Toast.LENGTH_LONG,
                                          msg: "Please Choice Unit",
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (selectedAreaId == null &&
                                        checkUser == true) {
                                      Fluttertoast.showToast(
                                          toastLength: Toast.LENGTH_LONG,
                                          msg: "Please Choice Unit",
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (state.registerModel.message ==
                                        null) {
                                      Fluttertoast.showToast(
                                          toastLength: Toast.LENGTH_LONG,
                                          msg:
                                              "License limit reached. Please update your license.",
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          toastLength: Toast.LENGTH_LONG,
                                          msg: "${state.registerModel.message}",
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'If you want to login',
                                      style: TextStyle(
                                          fontSize: FontSize.s15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
                                        },
                                        child: Text(
                                            '${Config.Localization['login']}'))
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                width: 150,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Back To API URL ',
                                    style: TextStyle(
                                        fontSize: FontSize.s15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfigScreen()),
                                            (route) => false);
                                      },
                                      child: Text('API URL'))
                                ],
                              ),
                            ],
                          ),
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
