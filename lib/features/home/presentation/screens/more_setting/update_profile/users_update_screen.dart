import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/data/models/get_all_users.dart';
import 'package:avms/features/home/presentation/screens/more_setting/update_profile/show_update.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../auth/data/models/area_unit.dart';

class UpdateUsersScreen extends StatefulWidget {
  @override
  _UpdateUsersScreenState createState() => _UpdateUsersScreenState();
}

class _UpdateUsersScreenState extends State<UpdateUsersScreen> {
  late Future<List<GetUserModel>> _futureUsers;
  List<GetUserModel> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  Map<String, int?> _selectedStatusMap = {};
  late Future<List<Area>> futureAreas;
  String? userid = CacheHelper.userId;
  List<int> selectedAreaIds = [];

  @override
  void initState() {
    super.initState();
    _futureUsers = _fetchUsersWithToken();
    futureAreas = DioHelper.fetchAreasWi(userid!);
  }

  Future<List<Area>> fetchAreas() async {
    return await DioHelper.fetchAreasWi(userid!);
  }

  void refreshAreas() {
    setState(() {
      futureAreas = fetchAreas(); // Re-fetch the areas
    });
  }

  Future<List<GetUserModel>> _fetchUsersWithToken() async {
    if (TokenSave == null) {
      Fluttertoast.showToast(
        msg: 'Token is null',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      _hasError = true;
      return []; // Return empty list to avoid further errors
    }

    try {
      final response = await DioHelper.getData(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/get-users',
        token: TokenSave!,
      );

      if (response.statusCode == 200) {
        List<GetUserModel> users = (response.data['data'] as List)
            .map((userJson) => GetUserModel.fromJson(userJson))
            .where((user) => !user.isDeleted)
            .toList();

        // Initialize status map without using SharedPreferences
        for (var user in users) {
          _selectedStatusMap[user.userId] = null; // Set default status or as needed
        }

        _hasError = false;
        return users;
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
    
      _hasError = true;
      return []; // Return empty list to avoid further errors
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _hasError = false;
      _futureUsers = _fetchUsersWithToken();
    });
  }

  Future<void> _updateAccountStatus(String userId, int status) async {
    setState(() {
      _isLoading = true;
    });

    if (TokenSave == null) {
      Fluttertoast.showToast(
        msg: 'Token is null',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await DioHelper.postData(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/account-status',
        token: TokenSave!,
        data: {
          'id': userId,
          'accountStatus': status,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Status updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update status',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Error updating status: $e',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _updateUser(
      String userId,
      List<String> roles,
      bool isActive,
      String phoneNumber,
      String image,
      bool emailConfirmed,
      String pictureUrl,
      List<int> areaIds,
      ) async {
    setState(() {
      _isLoading = true;
    });

    if (TokenSave == null) {
      Fluttertoast.showToast(
        msg: 'Token is null',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await DioHelper.postDataForRequest(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/UpdateUser',
        token: TokenSave!,
        data: FormData.fromMap({
          'Id': userId,
          'Roles': roles,
          'IsActive': isActive,
          'PhoneNumber': phoneNumber,
          'Image': image,
          'EmailConfirmed': emailConfirmed,
          'PictureUrl': pictureUrl,
          'AreaIds': areaIds,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'User updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _refreshUsers(); // Refresh the user list or update UI accordingly
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update user',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Error updating user: $e',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  String _statusToString(int? status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Reject';
      case 2:
        return 'Accept';
      default:
        return 'Unknown';
    }
  }

  Future<void> _showUpdateUserDialog(GetUserModel user) async {
    // Fetch areas asynchronously before showing the dialog
    List<Area> areas = await DioHelper.fetchAreasWi(userid!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateUserDialog(
          user: user,
          areas: areas,
          onUpdateSuccess: _refreshUsers, // Pass the callback
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Config.Localization['Users']}',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor, // Define your primary color in AppColors
        elevation: 4.0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshUsers,
            child: FutureBuilder<List<GetUserModel>>(
              future: _futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (_hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.signal_wifi_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No internet connection.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check your connection and try again.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _refreshUsers,
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No users found'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshUsers,
                          child: Text('Refresh'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  );
                } else {
                  _users = snapshot.data!;
                  return ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(user.pictureUrl),
                          onBackgroundImageError: (error, stackTrace) {
                            // Optionally log or handle the error here
                          },
                          child: user.pictureUrl.isEmpty
                              ? null
                              : ClipOval(
                            child: Image.network(
                              user.pictureUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                // Display a default image if the network image fails to load
                                return Image.asset('assets/images/defultImage/def1.png', fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          user.username,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<int>(
                              hint: Text('${user.accountStatus}'),
                              value: _selectedStatusMap[user.userId],
                              items: [
                                DropdownMenuItem(value: 0, child: Text('Pending')),
                                DropdownMenuItem(value: 1, child: Text('Reject')),
                                DropdownMenuItem(value: 2, child: Text('Accept')),
                              ],
                              onChanged: (status) {
                                if (status != null) {
                                  setState(() {
                                    _selectedStatusMap[user.userId] = status;
                                    _updateAccountStatus(user.userId, status);
                                  });
                                }
                              },
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: AppColors.primaryColor),
                              onPressed: () {
                                _showUpdateUserDialog(user);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

}
