import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserScreen extends StatefulWidget {
  static const route = 'UserScreen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? userId = CacheHelper.userId;
  bool isLoading = false; // Add a loading state variable

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    if (userId == null) {
      return {'error': 'User ID is null'};
    }

    try {
      Response response = await DioHelper.getData(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/$userId',
        token: TokenSave!,
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          return {'error': 'User not found'};
        }
      }
      return {'error': 'No internet connection.'};
    } catch (e) {
      return {'error': 'Failed to fetch user data'};
    }
  }

  Future<void> showUpdateUserDialog(Map<String, dynamic> userData) async {
    final TextEditingController phoneNumberController = TextEditingController(text: userData['phoneNumber']);
    final TextEditingController pictureUrlController = TextEditingController(text: userData['pictureUrl']);
    bool isActive = userData['isActive'] ?? false;
    bool emailConfirmed = userData['emailConfirmed'] ?? false;
    List<int> areaIds = (userData['areas'] as List<dynamic>).map<int>((area) => area['id'] as int).toList();
    List<String> roles = List<String>.from(userData['roles'] ?? []);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to manage state inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update User'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 10),
                    SwitchListTile(
                      title: Text('Is Active'),
                      value: isActive,
                      onChanged: (bool value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Email Confirmed'),
                      value: emailConfirmed,
                      onChanged: (bool value) {
                        setState(() {
                          emailConfirmed = value;
                        });
                      },
                    ),
                    // Add more fields as required
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: isLoading ? CircularProgressIndicator() : Text('Update'), // Show loading indicator if updating
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _updateUser(
                      userId: userId!,
                      phoneNumber: phoneNumberController.text,
                      isActive: isActive,
                      emailConfirmed: emailConfirmed,
                      pictureUrl: pictureUrlController.text,
                      roles: roles,
                      areaIds: areaIds,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateUser({
    required String userId,
    required String phoneNumber,
    required bool isActive,
    required bool emailConfirmed,
    required String pictureUrl,
    required List<String> roles,
    required List<int> areaIds,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'Id': userId,
        'PhoneNumber': phoneNumber,
        'IsActive': isActive,
        'EmailConfirmed': emailConfirmed,
        'PictureUrl': pictureUrl,
        'Roles': roles,
        'AreaIds': areaIds,
      });

      Response response = await DioHelper.postDataForRequest(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/UpdateUser',
        data: formData,
        token: TokenSave!,
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Updated Successfully',
          backgroundColor: Colors.green,
        );
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: 'Failed to update user');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.response?.data ?? 'Unknown error'}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Config.Localization['Profile']}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.appColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            var userData = snapshot.data!['data'];
            if (userData != null) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoTile('Username', userData['username'], Icons.person),
                            _buildInfoTile('Email', userData['email'], Icons.email),
                            _buildInfoTile('Phone Number', userData['phoneNumber'], Icons.phone),
                            _buildInfoTile('Roles', userData['roles']?.join(', ') ?? 'N/A', Icons.group),
                            _buildInfoTile('Account Status', userData['accountStatus'] ?? 'N/A', Icons.info),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showUpdateUserDialog(userData);
                      },
                      child: Text('${Config.Localization['Update Your Profile']}'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data!['error'] != null) {
              return Center(child: Text(snapshot.data!['error']));
            } else {
              return Center(child: Text('No user data available'));
            }
          } else {
            return Center(child: Text('Failed to load user data'));
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String? value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.appColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? 'N/A'),
    );
  }
}
