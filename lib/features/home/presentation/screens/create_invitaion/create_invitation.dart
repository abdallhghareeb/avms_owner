import 'dart:io';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/features/home/data/models/document_type.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../auth/data/models/area_unit.dart';

class CreateInvitationScreen extends StatefulWidget {
  const CreateInvitationScreen({super.key});

  @override
  State<CreateInvitationScreen> createState() => _CreateInvitationScreenState();
}

class _CreateInvitationScreenState extends State<CreateInvitationScreen> {
  late TextEditingController? nameController;
  late TextEditingController? emailController;
  late TextEditingController? phoneController;
  late TextEditingController? nationalIdController;
  late Future<List<Area>> futureAreasWithOwnerId;
  String imageText='Upload Your Card photo';
  late Future<List<Area>> futureAreas;
  String? userid = CacheHelper.userId;
  static int? selectedAreaIdWithOwnerId;

  int? selectedDocumentTypeId;
  late Future<List<DocumentType>> futureDocumentTypes;
  final createInvitationFormKey = GlobalKey<FormState>();
  XFile? _image;
  final pickedImage = ImagePicker();
  var imagePicked;
  var text_color = Colors.black;


  void UploadImage() async {
    imagePicked = await pickedImage.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imagePicked != null) {
        _image = imagePicked;
        print(imagePicked.path);
      } else {
        print('no Image Picked');
      }
    });
  }

  List<DateTime>? dateTimeList;


  bool pressed = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    nationalIdController = TextEditingController();
    futureAreasWithOwnerId = DioHelper.fetchAreasWi(userid!);
    futureAreas = fetchAreas();
    futureDocumentTypes = DioHelper.getInvitationDocTypes(context: context);
  }
  void showTopNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Adjust this value to position the notification
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red, // Change to your preferred color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the notification after a delay
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
  void clearCreateInvitationsFields() {
    setState(() {
      nameController?.clear();
      emailController?.clear();
      nationalIdController?.clear();
      phoneController?.clear();
      pressed = false;
      dateTimeList = [
        DateTime.now(),
        DateTime.now().add(Duration(days: 1)),
      ];
    });
  }

  Future<List<Area>> fetchAreas() async {
    return await DioHelper.fetchAreasWi(userid!);
  }

  Future<List<DocumentType>> fetchDocType() async {
    return await DioHelper.getInvitationDocTypes(context: context);
  }

  void refreshAreas() {
    setState(() {
      futureAreas = fetchAreas();
    });
  }

  void refreshDocType() {
    setState(() {
      futureDocumentTypes = fetchDocType(); // Re-fetch the areas
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is CreateInvitationSuccessState) {

              HomeCubit.get(context).changeNavBar(index: 0);
              (context as Element).reassemble();
              HomeCubit.get(context).loadDashData();
            } else if (state is CreateInvitationErrorState) {
              print(state.apiResponseToCreateInv.message);
              Fluttertoast.showToast(
                  msg: '${state.e}',
                  backgroundColor: Colors.red,
                  timeInSecForIosWeb: 3);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {

                  setState(() {
                    futureAreas = fetchAreas();
                    futureDocumentTypes = fetchDocType();
                  });
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10.0, vertical: 16),
                        child: Form(
                          key: createInvitationFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Config.Localization['sendInvitation'],
                                style: TextStyle(
                                  color: AppColors.appColor,
                                  fontSize: FontSize.s20,
                                  fontFamily: FontFamily.fontFamily,
                                  fontWeight: FontWeightManager.bold,
                                ),
                              ).tr(),
                              AppSpaces.vSpace20,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: smallPadding,
                                    vertical: smallPadding),
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: TextFieldDecoration.copyWith(
                                    labelText: Config.Localization['fullName'],
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: AppColors.appColor,
                                    ),
                                  ),
                                  validator: nonEmptyValidator,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: smallPadding,
                                    vertical: smallPadding),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: TextFieldDecoration.copyWith(
                                    labelText: Config.Localization['email'],
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: AppColors.appColor,
                                    ),
                                  ),
                                  validator: nonEmptyValidator,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: smallPadding,
                                    vertical: smallPadding),
                                child: IntlPhoneField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: phoneValidator,
                                  onChanged: (phoneNumber) =>
                                      print('changed into $phoneNumber'),
                                  enabled: true,
                                  decoration: TextFieldDecoration.copyWith(
                                      hintText: Config.Localization['phone']),
                                  initialCountryCode: "EG",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(smallPadding),
                                child: TextFormField(
                                  controller: nationalIdController,
                                  keyboardType: TextInputType.number,
                                  validator: nonEmptyValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(14),
                                  ],
                                  decoration: TextFieldDecoration.copyWith(
                                    labelText: Config.Localization['nationalId'],
                                    prefixIcon: FaIcon(
                                      FontAwesomeIcons.idCard,
                                      color: AppColors.appColor,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        final newDateTimeList = await showOmniDateTimeRangePicker(
                                          context: context,
                                          is24HourMode: false,
                                          barrierDismissible: false,
                                          defaultView: DefaultView.start,
                                          startFirstDate: DateTime.now(),
                                          endFirstDate: DateTime.now(),
                                          startInitialDate: dateTimeList?.first ?? DateTime.now(),
                                          endInitialDate: dateTimeList?.last ?? DateTime.now().add(Duration(days: 1)),
                                          startLastDate: DateTime.now().add(Duration(days: 30)),
                                          endLastDate: DateTime.now().add(Duration(days: 30)),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                          type: OmniDateTimePickerType.dateAndTime,
                                        );

                                        if (newDateTimeList != null) {
                                          setState(() {
                                            dateTimeList = [
                                              newDateTimeList.first,
                                              dateTimeList?.last ?? newDateTimeList.last
                                            ];
                                            pressed = true;
                                          });
                                        }
                                      },
                                      child: InputDecorator(
                                        decoration: TextFieldDecoration.copyWith(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 10),
                                            labelText: pressed == false
                                                ? null
                                                : Config.Localization['Register Date']),
                                        child: pressed == false
                                            ? Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment:
                                                AlignmentDirectional
                                                    .centerStart,
                                                child: Icon(
                                                  Icons.date_range,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                Config.Localization[
                                                'Register Date'],
                                                style: TextStyle(
                                                  color:
                                                  AppColors.lightGrey,
                                                  fontSize: FontSize.s13,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                            : Text(
                                          dateTimeList == null
                                              ? 'No date and time range selected'
                                              : '${DateFormat(
                                            'dd-MM-yyyy\nhh:mm a',
                                            "en_Us",
                                          ).format(dateTimeList!.first)}',
                                          style: TextStyle(
                                            color: AppColors.lightGrey,
                                            fontSize: FontSize.s13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        final newDateTimeList = await showOmniDateTimeRangePicker(
                                          context: context,
                                          is24HourMode: false,
                                          barrierDismissible: false,
                                          startFirstDate: DateTime.now(),
                                          defaultView: DefaultView.end,
                                          endFirstDate: DateTime.now(),
                                          startInitialDate: dateTimeList?.first ?? DateTime.now(),
                                          endInitialDate: dateTimeList?.last ?? DateTime.now().add(Duration(days: 1)),
                                          startLastDate: DateTime.now().add(Duration(days: 30)),
                                          endLastDate: DateTime.now().add(Duration(days: 30)),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                          type: OmniDateTimePickerType.dateAndTime,
                                        );

                                        if (newDateTimeList != null) {
                                          setState(() {
                                            dateTimeList = [
                                              dateTimeList?.first ?? DateTime.now(),
                                              newDateTimeList.last
                                            ];
                                            pressed = true;
                                          });
                                        }
                                      },
                                      child: InputDecorator(
                                        decoration: TextFieldDecoration.copyWith(
                                            contentPadding: EdgeInsets.all(16),
                                            labelText: pressed == false
                                                ? null
                                                : Config.Localization['Expired Date']),
                                        child: pressed == false
                                            ? Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .centerStart,
                                                    child: Icon(
                                                      Icons.date_range,
                                                    ))),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                Config.Localization[
                                                'Expired Date'],
                                                style: TextStyle(
                                                  color:
                                                  AppColors.lightGrey,
                                                  fontSize: FontSize.s12,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                            : Text(
                                          dateTimeList == null
                                              ? 'No date and time range selected'
                                              : '${DateFormat(
                                            'dd-MM-yyyy\nhh:mm a',
                                            "en_Us",
                                          ).format(dateTimeList!.last)}',
                                          style: TextStyle(
                                            color: AppColors.lightGrey,
                                            fontSize: FontSize.s12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpaces.vSpace20,
                              Text(
                                'Choice your Unit :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize.s16,
                                    color: AppColors.appColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(smallPadding),
                                child: FutureBuilder<List<Area>>(
                                  future: futureAreas,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: ElevatedButton(
                                            onPressed: refreshAreas,
                                            child: Text("Refresh Areas"),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasData) {
                                      List<Area> areas = snapshot.data!;
                                      if (areas.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'No units available for your account',
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }
                                      return DropdownButton<int>(
                                        hint: Text('Select an Area'),
                                        value: selectedAreaIdWithOwnerId,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedAreaIdWithOwnerId = newValue;
                                          });
                                        },
                                        items: areas.map<DropdownMenuItem<int>>(
                                                (Area area) {
                                              return DropdownMenuItem<int>(
                                                value: area.id,
                                                child: Text(area.name),
                                              );
                                            }).toList(),
                                      );
                                    } else {
                                      return Center(child: Text('No data'));
                                    }
                                  },
                                ),
                              ),
                              Text(
                                'Choice your DocType :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize.s16,
                                    color: AppColors.appColor),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.w), // Adjust padding using ScreenUtil
                                child: FutureBuilder<List<DocumentType>>(
                                  future: futureDocumentTypes,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.h),
                                          child: ElevatedButton(
                                            onPressed: refreshDocType,
                                            child: Text("Refresh DocType"),
                                          ),
                                        ),
                                      );
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return Center(
                                          child: Text('No data available'));
                                    } else {
                                      return DropdownButton<int>(
                                        value: selectedDocumentTypeId,
                                        hint: Text('Select Document Type'),
                                        isExpanded: true,
                                        items: snapshot.data!.map((DocumentType docType) {
                                          return DropdownMenuItem<int>(
                                            value: docType.id,
                                            child: Text(docType.name),
                                          );
                                        }).toList(),
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedDocumentTypeId = newValue;
                                          });
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              // Adding spacing between elements
                              InkWell(
                                onTap: () {
                                  UploadImage();
                                },
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w), // Adjust padding using ScreenUtil
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt_outlined, size: 24.sp,color: text_color,),// Adjust icon size using ScreenUtil
                                        SizedBox(width: 16.w), // Adjust spacing using ScreenUtil
                                        Expanded(
                                          child: Text(
                                            '${imageText}',
                                            style: TextStyle(
                                                fontSize: 15.sp, // Adjust font size using ScreenUtil
                                                fontWeight: FontWeight.bold,
                                                color:text_color
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AppSpaces.vSpace20,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: _image != null
                                      ? Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                  )
                                      : Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpaces.vSpace20,
                              ConditionalBuilder(
                                condition: state is CreateInvitationLoadingState,
                                builder: (context) => CircularProgressIndicator(),
                                fallback: (context) => MainButton(
                                  text: Config.Localization['send'],
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    // Validate form fields
                                    if (!createInvitationFormKey.currentState!
                                        .validate()) return;
                                    if(selectedAreaIdWithOwnerId == null &&selectedDocumentTypeId == null){
                                      showTopNotification(context,
                                          'Please select  Area and DocumentType ');
                                      return;
                                    }else
                                    if (selectedAreaIdWithOwnerId == null) {
                                      showTopNotification(context,
                                          'Please select an Area');
                                      return;
                                    }else
                                    if (selectedDocumentTypeId == null) {
                                      showTopNotification(context,
                                          'Please select a DocumentType');

                                      return;
                                    }

                                    // Validate date selection
                                    if (dateTimeList == null ||
                                        dateTimeList!.length < 2) {
                                      showTopNotification(context,
                                          'Please enter both Register and Expired Dates');
                                      return;
                                    }

                                    // Check if the register date is before the expired date
                                    if (dateTimeList![0]
                                        .isAfter(dateTimeList![1])) {
                                      showTopNotification(context,
                                          'Register Date must be before Expired Date');
                                      return;
                                    }

                                    // Proceed with creating the invitation
                                    await HomeCubit.get(context)
                                        .createInvitation(
                                      context: context,
                                      name: nameController!.text,
                                      phone: phoneController!.text,
                                      email: emailController!.text,
                                      nationalId: nationalIdController!.text,
                                      registerDate: dateTimeList!.first,
                                      expiredDate: dateTimeList!.last,
                                      AreaId: '$selectedAreaIdWithOwnerId',
                                      token: TokenSave!,
                                      DocTypeId: selectedDocumentTypeId!,
                                      file:
                                      _image, // Pass null if _image is null
                                    );

                                    // Clear the image after successful creation
                                    setState(() {
                                      _image = null;
                                    });

                                    // Clear input fields
                                    clearCreateInvitationsFields();
                                    (context as Element).reassemble();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}