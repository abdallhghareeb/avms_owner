import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
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
  bool _isLoading = false;
  bool _hasError = false;
  Map<String, int?> _selectedStatusMap = {};
  late Future<List<Area>> futureAreas;
  String? userid = CacheHelper.userId;

  @override
  void initState() {
    super.initState();
    _futureUsers = _fetchUsersWithToken();
    futureAreas = DioHelper.fetchAreasWi(userid!);
  }


  Future<List<GetUserModel>> _fetchUsersWithToken() async {
    if (TokenSave == null) {
      _handleError('Token is null');
      return [];
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

        for (var user in users) {
          _selectedStatusMap[user.userId] = null;
        }

        _hasError = false;
        return users;
      }else if(response.statusCode==401){
        Fluttertoast.showToast(

            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);
        return[];
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      _handleError('Error fetching users:  No Internet');
      return [];
    }
  }

  void _handleError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    setState(() {
      _hasError = true;
    });
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _hasError = false;
      _futureUsers = _fetchUsersWithToken();
    });
  }
  Future<void> _deleteUser(String userId) async {
    setState(() {
      _isLoading = true;
    });

    if (TokenSave == null) {
      _handleError('Token is null');
      return;
    }

    try {
      final response = await DioHelper.postData(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/delete',
        token: TokenSave!,
        data: {'id': userId},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'User deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }else if(response.statusCode==401){
        Fluttertoast.showToast(

            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);

      } else {
        _handleError('Failed to delete user');
      }
    } catch (e) {
      _handleError('Error deleting user: No Internet');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _updateAccountStatus(String userId, int status) async {
    setState(() {
      _isLoading = true;
    });

    if (TokenSave == null) {
      _handleError('Token is null');
      return;
    }

    try {
      final response = await DioHelper.postData(
        url: '$BASE_URL$SaveApiUrl/api/v1/user/account-status',
        token: TokenSave!,
        data: {'id': userId, 'accountStatus': status},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Status updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _refreshUsers();

      } else if (response.statusCode==401){
        Fluttertoast.showToast(

            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);

      }else {
        _handleError('Failed to update status');
      }
    } catch (e) {
      _handleError('Error updating status:No Internet');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _showDeleteConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteUser(userId); // Call the delete method
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUser(
      String userId,
      List<String> roles,
      bool isActive,
      String phoneNumber,
      String image,
      bool emailConfirmed,
      String pictureUrl,
      List<int> areaIds) async {
    setState(() {
      _isLoading = true;
    });

    if (TokenSave == null) {
      _handleError('Token is null');
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

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'User updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _refreshUsers();
      } else {
        _handleError('Failed to update user');
      }
    } catch (e) {
      _handleError('Error updating user: No Internet');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _statusToString(int? status) {
    switch (status) {
      case 0: return 'Pending';
      case 1: return 'Reject';
      case 2: return 'Accept';
      default: return 'Unknown';
    }
  }

  Future<void> _showUpdateUserDialog(GetUserModel user) async {
    List<Area> areas = [];
    bool hasError = false;

    try {
      areas = await DioHelper.fetchAreasWi(userid!);
    } catch (e) {
      hasError = true;
      _handleError('Error fetching areas: No Internet');
    }

    if (hasError) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateUserDialog(
          user: user,
          areas: areas,
          onUpdateSuccess: _refreshUsers,
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
        backgroundColor: AppColors.primaryColor,
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
                  return _buildErrorState();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return _buildUserList(snapshot.data!);
                }
              },
            ),
          ),
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No internet connection.', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text('Check your connection and try again.', style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshUsers,
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
  }

  Widget _buildUserList(List<GetUserModel> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(user.pictureUrl),
            onBackgroundImageError: (error, stackTrace) {
              // Optionally log or handle the error here
            },
            child: user.pictureUrl.isEmpty
                ? Icon(Icons.person, size: 24, color: Colors.grey)
                : null,
          ),
          title: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          subtitle: Text(user.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusDropdown(user),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.primaryColor),
                onPressed: () => _showUpdateUserDialog(user),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red), // Delete icon
                onPressed: () {
                  // Add your delete logic here
                  _showDeleteConfirmationDialog(user.userId);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildStatusDropdown(GetUserModel user) {
    bool isStatusFinal = user.accountStatus == 'Reject' || user.accountStatus == 'Accept';

    return IgnorePointer(
      ignoring: isStatusFinal,
      child: DropdownButton<int>(
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
        icon: Icon(Icons.arrow_drop_down, color: isStatusFinal ? Colors.grey : Colors.black),
        disabledHint: Text(
          '${user.accountStatus}', // Display current status when disabled
          style: TextStyle(color: Colors.grey), // Greyed-out text when disabled
        ),
      ),
    );
  }


  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
