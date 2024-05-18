import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/screens/register_screen.dart';
import 'package:avms/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  static  String ?saveUrl;
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController _apiController = TextEditingController();
  String _connectionStatus = '';

  @override
  void initState() {
    super.initState();
    _loadApiURL();
  }

  void _loadApiURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiController.text = prefs.getString('apiURL') ?? '';
    });
  }

  void _testConnection() {
    // Placeholder for actual API connection test
    setState(() {
      _connectionStatus = 'Connection successful!';
    });
  }

  void _saveToSharedPreferences() async {
    String apiURL = _apiController.text;
    if (apiURL.isNotEmpty) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiURL', apiURL);
      ConfigScreen.saveUrl=await prefs.getString('apiURL') ?? 'http://egydns.ddns.net:2599/api/v1/';
      showDialog(
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter API URL.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Configuration'),
      ),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: AssetImage(AppStrings.appLogo),width: 60.w,height: 70.h,),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 80.h,horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _apiController,
                    decoration:TextFieldDecoration.copyWith(
                      labelText: 'API URL',
                      prefixIcon: Icon(
                        Icons.miscellaneous_services_outlined,
                        color: AppColors.appColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0.h),

                 MainButton(text: 'Save', onPressed: _saveToSharedPreferences)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}