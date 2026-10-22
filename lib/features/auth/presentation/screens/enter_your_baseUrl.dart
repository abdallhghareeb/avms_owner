import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/widgets/btn.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  static String? saveUrl;

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController _apiController = TextEditingController();
  String _connectionStatus = '';
  String _fetchedData = '';

  @override
  void initState() {
    super.initState();
    _loadApiURL();
  }

  void _loadApiURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiController.text = prefs.getString('apiUrl') ?? '';
    });
  }

  void _testConnection() {
    // Placeholder for actual API connection test
    setState(() {
      _connectionStatus = 'Connection successful!';
    });
  }

  Future<void> _saveToSharedPreferences() async {
    String apiURL = normalizeApiUrl(_apiController.text);
    if (apiURL.isNotEmpty ) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('apiUrl', apiURL);
      await prefs.setBool('apiUrlSave', true);
      ConfigScreen.saveUrl = apiURL;
      SaveApiUrl = apiURL;
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('API URL saved successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Enter a valid server address, for example https://server.example.com'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _fetchData() async {
    String? apiUrl = await _fetchApiUrl();
    if (apiUrl != null) {
      try {
        var response = await Dio().get(normalizeApiUrl(apiUrl));
        setState(() {
          _fetchedData = response.data.toString();
        });
      } catch (e) {
        setState(() {
          _fetchedData = 'Failed to fetch data: $e';
        });
      }
    } else {
      setState(() {
        _fetchedData = 'No API URL found';
      });
    }
  }

  Future<String?> _fetchApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString('apiUrl');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _apiController.text = savedUrl;
      return savedUrl;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(AppStrings.appLogo),
                      width: 60.w,
                      height: 70.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _apiController,
                          decoration: TextFieldDecoration.copyWith(
                            labelText: 'API URL',
                            prefixIcon: Icon(
                              Icons.miscellaneous_services_outlined,
                              color: AppColors.appColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0.h),
                        MainButton(text: 'Save', onPressed: _saveToSharedPreferences),
                        SizedBox(height: 20.0.h),
                        MainButton(text: 'Fetch Data', onPressed: _fetchData),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
