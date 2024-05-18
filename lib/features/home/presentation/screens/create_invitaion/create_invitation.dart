import 'dart:io';

import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/auth/presentation/widgets/validator.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:avms/widgets/btn.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

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
  final createInvitationFormKey = GlobalKey<FormState>();
  File? _image;
  final pickedImage = ImagePicker();

  void UploadImage() async {
    var imagePicked = await pickedImage.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imagePicked != null) {
        _image = File(imagePicked.path);
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
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
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
                            // TextFormField(
                            //   enabled: false,
                            //   decoration: TextFieldDecoration.copyWith(
                            //     hintText: 'Register Date'.tr(),
                            //     labelText: pressed == false
                            //         ? null
                            //         : dateTimeList == null
                            //             ? 'No date and time range selected'
                            //             : 'Register Date: ${DateFormat('dd-MM-yyyy  hh:mm a', "en_Us").format(dateTimeList!.first)}\nExpired Date: ${DateFormat(
                            //                 'dd-MM-yyyy  hh:mm a',
                            //                 "en_Us",
                            //               ).format(dateTimeList!.last)}',
                            //     labelStyle: TextStyle(
                            //       fontSize: FontSize.s14,
                            //       color: Colors.black,
                            //     ),
                            //     prefixIcon: Icon(
                            //       Icons.date_range,
                            //       color: AppColors.appColor,
                            //     ),
                            //   ),
                            //   // enabled: false,
                            //   validator: (value) {
                            //     if (dateTimeList == null)
                            //       return 'requiredMSG'.tr();
                            //     return null;
                            //   },
                            //   onTap: () async {
                            //     FocusScope.of(context).unfocus();
                            //     dateTimeList =
                            //         await showOmniDateTimeRangePicker(
                            //       context: context,
                            //       is24HourMode: false,
                            //       barrierDismissible: false,
                            //       startFirstDate: DateTime.now(),
                            //       endFirstDate: DateTime.now(),
                            //       startInitialDate: DateTime.now(),
                            //       endInitialDate:
                            //           DateTime.now().add(Duration(days: 1)),
                            //       startLastDate:
                            //           DateTime.now().add(Duration(days: 30)),
                            //       endLastDate:
                            //           DateTime.now().add(Duration(days: 30)),
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(10.0),
                            //         topRight: Radius.circular(10.0),
                            //       ),
                            //       type: OmniDateTimePickerType.dateAndTime,
                            //     );
                            //     logger.w("dateTimeList ${dateTimeList}");
                            //     setState(() => pressed = true);
                            //   },
                            // ),
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
                                        'UpLoad',
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
                                        _image!.absolute,
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

                                  // createInvitationFormKey.currentState!.save();

                                  await HomeCubit.get(context).createInvitation(
                                    context: context,
                                    name: nameController!.text,
                                    phone: phoneController!.text,
                                    email: emailController!.text,
                                    nationalId: nationalIdController!.text,
                                    registerDate: dateTimeList!.first,
                                    expiredDate: dateTimeList!.last,
                                  );

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
