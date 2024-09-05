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
  bool _isUpdating = false;
  bool _isActive = true;
  bool _emailConfirmed = true; // Default value; adjust as needed

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _imageController = TextEditingController(text: widget.user.pictureUrl ?? '');
    _pictureUrlController = TextEditingController(text: widget.user.pictureUrl ?? '');

    selectedAreaIds = widget.user.areas.map((area) => area['id'] as int).toList(); // Extract IDs
    selectedRole = widget.user.roles.isNotEmpty ? widget.user.roles.first : null;
    _isActive = widget.user.isActive; // Set initial value
    _emailConfirmed = widget.user.emailConfirmed; // Set initial value
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Update User'),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Role:', style: TextStyle(color: AppColors.primaryColor)),
              SizedBox(height: 5.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${selectedRole}'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
              ),
              SizedBox(height: 10),
              Text(
                'Choose your Units:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: FontSize.s16, color: AppColors.appColor),
              ),
              ...widget.areas.map((area) {
                bool isChecked = selectedAreaIds.contains(area.id);
                // Check if the user's role is 'UnitAdmin'
                bool isUnitAdmin = selectedRole == 'UnitAdmin';

                // Ensure all units are checked for UnitAdmin
                if (isUnitAdmin) {
                  isChecked = true;
                }

                return CheckboxListTile(
                  title: Text(area.name),
                  value: isChecked,
                  onChanged: isUnitAdmin
                      ? null // Disable checkbox changes for UnitAdmin
                      : (bool? checked) {
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
            onPressed: _isUpdating ? null : () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              // Handle fallback for selectedAreaIds
              List<int> areaIds = selectedAreaIds.isNotEmpty
                  ? selectedAreaIds
                  : widget.user.areas.map((area) => area['id'] as int).toList();

              if (areaIds.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please select at least one unit',
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }

              setState(() {
                _isUpdating = true;
              });

              List<String> rolesList = [selectedRole!];

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
                _isUpdating = false;
              });

              widget.onUpdateSuccess();
              Navigator.of(context).pop();
            },
            child: _isUpdating
                ? CircularProgressIndicator()
                : Text('Update'),
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
