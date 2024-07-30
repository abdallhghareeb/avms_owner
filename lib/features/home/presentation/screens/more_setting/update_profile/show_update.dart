import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/home/data/models/get_all_users.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../auth/data/models/area_unit.dart';

class UpdateUserDialog extends StatefulWidget {
  final GetUserModel user;
  final List<Area> areas;
  final VoidCallback onUpdateSuccess; // Callback to trigger refresh

  UpdateUserDialog({
    required this.user,
    required this.areas,
    required this.onUpdateSuccess,
  });

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  late TextEditingController _phoneController;
  late TextEditingController _imageController;
  late TextEditingController _pictureUrlController;
  late List<int> selectedAreaIds;
  String? selectedRole;
  bool _isUpdating = false; // Add updating state
  bool _isActive = true; // Default value; adjust as needed
  bool _emailConfirmed = true; // Default value; adjust as needed

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _imageController = TextEditingController(text: widget.user.pictureUrl ?? '');
    _pictureUrlController = TextEditingController(text: widget.user.pictureUrl ?? '');

    // Initialize selectedAreaIds with safe default
    selectedAreaIds = []; // Set default from user data
    selectedRole = widget.user.roles.isNotEmpty ? widget.user.roles.first : null;
    _isActive = widget.user.isActive; // Set initial value
    _emailConfirmed = widget.user.emailConfirmed; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    List<String> roles = ['UnitAdmin', 'User'];

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Update User'),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choice Role:', style: TextStyle(color: AppColors.primaryColor)),
              SizedBox(height: 5.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: Text('Select Role'),
                  onChanged: (String? role) {
                    setState(() {
                      selectedRole = role;
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Role is required' : null,
                ),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
              ),
              SizedBox(height: 10),
              Text(
                'Choice your Units:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: FontSize.s16, color: AppColors.appColor),
              ),
              ...widget.areas.map((area) {
                return CheckboxListTile(
                  title: Text(area.name),
                  value: selectedAreaIds.contains(area.id),
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        selectedAreaIds.add(area.id);
                      } else {
                        selectedAreaIds.remove(area.id);
                      }
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 10),
              SwitchListTile(
                title: Text('Is Active'),
                value: _isActive,
                onChanged: (bool value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Email Confirmed'),
                value: _emailConfirmed,
                onChanged: (bool value) {
                  setState(() {
                    _emailConfirmed = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isUpdating ? null : () async { // Disable button when updating
              if (!_formKey.currentState!.validate()) {
                return; // If form is not valid, exit the function
              }

              if (selectedRole == null || selectedAreaIds.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please select role and at least one unit',
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }

              setState(() {
                _isUpdating = true; // Start updating
              });

              List<String> rolesList = [selectedRole!];
              List<int> areaIds = selectedAreaIds;

              await _updateUser(
                widget.user.userId,
                rolesList,
                _isActive,
                _phoneController.text,
                _imageController.text,
                _emailConfirmed,
                _pictureUrlController.text,
                areaIds,
              );

              setState(() {
                _isUpdating = false; // Stop updating
              });

              widget.onUpdateSuccess(); // Call the callback to refresh user list
              Navigator.of(context).pop();
            },
            child: _isUpdating
                ? CircularProgressIndicator() // Show loading spinner
                : Text('Update'), // Show text when not updating
          ),
        ],
      ),
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
      List<int> areaIds,
      ) async {
    if (TokenSave == null) {
      Fluttertoast.showToast(
        msg: 'Token is null',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update user',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating user: $e',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
