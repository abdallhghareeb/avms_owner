import 'dart:io';

import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
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
  late Future<List<Area>> futureAreas;
  String? userid = CacheHelper.userId;
  static int? selectedAreaIdWithOwnerId;
  final createInvitationFormKey = GlobalKey<FormState>();
  XFile? _image;
  final pickedImage = ImagePicker();
  var imagePicked;

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

  List<DateTime>? dateTimeList = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];

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

  void refreshAreas() {
    setState(() {
      futureAreas = fetchAreas(); // Re-fetch the areas
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
            }else if(state is CreateInvitationErrorState){
              print(state.error);
              Fluttertoast.showToast(msg: '${state.error}',
              backgroundColor: Colors.red,
                timeInSecForIosWeb: 3

              );
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                                validator: validator,
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
                                validator: validator,
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
                                validator: validator,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(14),
                                ],
                                decoration: TextFieldDecoration.copyWith(
                                  labelText: Config.Localization['nationalId'],
                                  prefixIcon: Icon(
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
                                      dateTimeList =
                                          await showOmniDateTimeRangePicker(
                                        context: context,
                                        is24HourMode: false,
                                        barrierDismissible: false,
                                        defaultView: DefaultView.start,
                                        startFirstDate: DateTime.now(),
                                        endFirstDate: DateTime.now(),
                                        startInitialDate: DateTime.now(),
                                        endInitialDate: DateTime.now()
                                            .add(Duration(days: 1)),
                                        startLastDate: DateTime.now()
                                            .add(Duration(days: 30)),
                                        endLastDate: DateTime.now()
                                            .add(Duration(days: 30)),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        type:
                                            OmniDateTimePickerType.dateAndTime,
                                      );
                                      logger.w("dateTimeList ${dateTimeList}");
                                      setState(() => pressed = true);
                                    },
                                    child: InputDecorator(
                                      decoration: TextFieldDecoration.copyWith(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 10),
                                          labelText: pressed == false
                                              ? null
                                              : Config.Localization[
                                                  'Register Date']),
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
                                      dateTimeList =
                                          await showOmniDateTimeRangePicker(
                                        context: context,
                                        is24HourMode: false,
                                        barrierDismissible: false,
                                        startFirstDate: DateTime.now(),
                                        defaultView: DefaultView.end,
                                        endFirstDate: DateTime.now(),
                                        startInitialDate: DateTime.now(),
                                        endInitialDate: DateTime.now()
                                            .add(Duration(days: 1)),
                                        startLastDate: DateTime.now()
                                            .add(Duration(days: 30)),
                                        endLastDate: DateTime.now()
                                            .add(Duration(days: 30)),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        type:
                                            OmniDateTimePickerType.dateAndTime,
                                      );
                                      logger.w("dateTimeList ${dateTimeList}");
                                      setState(() => pressed = true);
                                    },
                                    child: InputDecorator(
                                      decoration: TextFieldDecoration.copyWith(
                                          contentPadding: EdgeInsets.all(16),
                                          labelText: pressed == false
                                              ? null
                                              : Config.Localization[
                                                  'Expired Date']),
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
                                                // Spacer(),
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
                            Padding(
                              padding: EdgeInsets.only(right: 150.w),
                              child: Text(
                                'Choice your Unit :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontSize.s16,
                                    color: AppColors.appColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(smallPadding),
                              child: FutureBuilder<List<Area>>(
                                future: futureAreas,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child:   Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: ElevatedButton(
                                        onPressed: refreshAreas,
                                        child: Text("Refresh Areas"),
                                      ),
                                    ),);
                                  } else if (snapshot.hasData) {
                                    List<Area> areas = snapshot.data!;
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


                            InkWell(
                              onTap: () {
                                UploadImage();
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt_outlined),
                                      AppSpaces.hSpace16,
                                      Text(
                                        'UpLoad Your Card photo',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
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
                                  if (!createInvitationFormKey.currentState!
                                      .validate()) return;

                                  await HomeCubit.get(context).createInvitation(
                                    context: context,
                                    name: nameController!.text,
                                    phone: phoneController!.text,
                                    email: emailController!.text,
                                    nationalId: nationalIdController!.text,
                                    registerDate: dateTimeList!.first,
                                    expiredDate: dateTimeList!.last,
                                    file: _image!,
                                    AreaId: '$selectedAreaIdWithOwnerId',
                                    token: TokenSave!,
                                  );

                                  // Clear the image after successful creation
                                  setState(() {
                                    _image = null;
                                  });

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
            );
          },
        ),
      );
    });
  }
}
