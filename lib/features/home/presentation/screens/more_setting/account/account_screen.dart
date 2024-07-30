import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  static const route = 'AccountRoute';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<String?> urlFuture;
  late TextEditingController _urlController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    urlFuture = _fetchApiUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<String?> _fetchApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString('apiUrl');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _urlController.text = savedUrl;
      return savedUrl;
    } else {
      return null;
    }
  }

  Future<void> _saveApiUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiUrl', url);
    SaveApiUrl = url;

    // Show dialog to inform user that API URL is saved
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('API URL Saved'),
          content: Text('The API URL has been saved successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                await prefs.setBool('apiUrlSave', true); // Navigate to login screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Config.Localization['account']}',style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: AppColors.appColor, // Replace with your preferred color
      ),
      body: FutureBuilder<String?>(
        future: urlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var url = snapshot.data;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              ListTile(
                title: Text(
                  '${Config.Localization['signOut']}',

                  style: TextStyle(fontSize: 18.0),
                ),
                subtitle: Text(
                  '${Config.Localization['Leave The Application']}',
                  style: TextStyle(fontSize: 14.0),
                ),
                leading: Icon(Icons.logout, size: 32.0),
                onTap: () {
                  AuthCubit.get(context).signOut(context: context);

                },
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You can change the value of ApiUrl:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Api Url:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: _urlController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid API URL';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              // _saveApiUrl(value); // Remove this to avoid auto-saving on change
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter API URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveApiUrl(_urlController.text.trim());
                            }
                          },
                          child: Text('${Config.Localization['save']}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
