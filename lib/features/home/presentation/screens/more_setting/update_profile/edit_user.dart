import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:avms/services/api_service/end_point.dart';

class EditUserDialog extends StatefulWidget {
  final String initialUserId;
  final String initialPhoneNumber;

  EditUserDialog({required this.initialUserId, required this.initialPhoneNumber});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _phoneController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
    _idController = TextEditingController(text: widget.initialUserId);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'User ID'),
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
        TextButton(
          onPressed: () async {
            final userId = _idController.text;
            final phoneNumber = _phoneController.text;

            try {
              final dio = Dio();
              final formData = FormData.fromMap({
                'Id': userId,
                'PhoneNumber': phoneNumber,
              });

              final response = await dio.post(
                '$BASE_URL$SaveApiUrl/api/v1/user/UpdateUser',
                data: formData,
                options: Options(headers: {
                  'Authorization': 'Bearer $TokenSave',
                }),
              );

              if (response.statusCode == 200) {
                print('Updated Successfully');
                Navigator.of(context).pop();
              } else {
                print('Failed to update user - ${response.statusCode}');
                // Handle other status codes if needed
              }
            } catch (e) {
              print('Error updating user: $e');
              // Handle other exceptions if needed
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
