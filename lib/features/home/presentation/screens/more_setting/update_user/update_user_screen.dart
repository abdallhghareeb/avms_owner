// import 'package:avms/core/utils/app_color.dart';
// import 'package:avms/core/utils/font_size.dart';
// import 'package:avms/features/home/data/models/get_all_users.dart';
// import 'package:avms/services/api_service/dio_helper.dart';
// import 'package:avms/services/api_service/end_point.dart';
// import 'package:avms/services/local/cache_helper.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../../../../../auth/data/models/area_unit.dart';
// class UpdateUser extends StatefulWidget {
//   final GetUserModel user;
//   final List<Area> areas;
//   final VoidCallback onUpdateSuccess; // Callback to trigger refresh
//
//   UpdateUser({
//     required this.user,
//     required this.areas,
//     required this.onUpdateSuccess,
//   });
//
//   @override
//   _UpdateUserDialogState createState() => _UpdateUserDialogState();
// }
//
// class _UpdateUserDialogState extends State<UpdateUser> {
//   final _formKey = GlobalKey<FormState>(); // Form key for validation
//   late TextEditingController _phoneController;
//   late TextEditingController _imageController;
//   late TextEditingController _pictureUrlController;
//   bool _isUpdating = false;
//   String? userId = CacheHelper.userId; // Add updating state
//
//   @override
//   void initState() {
//     super.initState();
//     _phoneController = TextEditingController(text: widget.user.phoneNumber);
//     _imageController = TextEditingController(text: widget.user.pictureUrl ?? '');
//     _pictureUrlController = TextEditingController(text: widget.user.pictureUrl ?? '');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: AlertDialog(
//         title: Text('Update User'),
//         content: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Role: ${widget.user.roles.join(', ')}', // Display current roles
//                 style: TextStyle(color: AppColors.primaryColor),
//               ),
//               SizedBox(height: 5.h),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'All Units will be updated:',
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: FontSize.s16, color: AppColors.appColor),
//               ),
//               // Remove the CheckboxListTile for area selection
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: _isUpdating ? null : () async { // Disable button when updating
//               if (!_formKey.currentState!.validate()) {
//                 return; // If form is not valid, exit the function
//               }
//
//               setState(() {
//                 _isUpdating = true; // Start updating
//               });
//
//               List<String> rolesList = widget.user.roles; // Use existing roles
//               List<int> areaIds = widget.areas.map((area) => area.id).toList(); // Send all areas
//               bool isActive = true; // Or fetch from user data
//               bool emailConfirmed = true; // Or fetch from user data
//
//               await _updateUser(
//                 userId!,
//                 rolesList,
//                 isActive,
//                 _phoneController.text,
//                 _imageController.text,
//                 emailConfirmed,
//                 _pictureUrlController.text,
//                 areaIds,
//               );
//
//               setState(() {
//                 _isUpdating = false; // Stop updating
//               });
//
//               widget.onUpdateSuccess(); // Call the callback to refresh user list
//               Navigator.of(context).pop();
//             },
//             child: _isUpdating
//                 ? CircularProgressIndicator() // Show loading spinner
//                 : Text('Update'), // Show text when not updating
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _updateUser(
//       String userId,
//       List<String> roles,
//       bool isActive,
//       String phoneNumber,
//       String image,
//       bool emailConfirmed,
//       String pictureUrl,
//       List<int> areaIds,
//       ) async {
//     if (TokenSave == null) {
//       Fluttertoast.showToast(
//         msg: 'Token is null',
//         toastLength: Toast.LENGTH_SHORT,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       final response = await DioHelper.postDataForRequest(
//         url: '$BASE_URL$SaveApiUrl/api/v1/user/UpdateUser',
//         token: TokenSave!,
//         data: FormData.fromMap({
//           'Id': userId,
//           'Roles': roles,
//           'IsActive': isActive,
//           'PhoneNumber': phoneNumber,
//           'Image': image,
//           'EmailConfirmed': emailConfirmed,
//           'PictureUrl': pictureUrl,
//           'AreaIds': areaIds,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: 'User updated successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: 'Failed to update user',
//           toastLength: Toast.LENGTH_SHORT,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Error updating user: $e',
//         toastLength: Toast.LENGTH_SHORT,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }
// }
