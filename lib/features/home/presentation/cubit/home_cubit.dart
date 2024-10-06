import 'dart:io';
import 'dart:developer';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/home/data/models/api_res_create_inv.dart';
import 'package:avms/features/home/domain/use_cases/cancel_invitation_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_invitstion_by_id_use_case.dart';
import 'package:avms/features/home/presentation/screens/more_setting/update_profile/users_update_screen.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_values.dart';
import 'package:avms/core/utils/font_size.dart';
import 'package:avms/features/home/domain/entities/info.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/use_cases/create_invitation_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_dash_info_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_invitation_visits_use_case.dart';
import 'package:avms/features/home/presentation/screens/create_invitaion/create_invitation.dart';
import 'package:avms/features/home/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:avms/features/home/presentation/screens/invitation/invitations.dart';
import 'package:avms/features/home/presentation/screens/more_setting/more_settings.dart';
import 'package:avms/widgets/success_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Import the auto-generated state file
part 'home_state.dart';

// Define the HomeCubit class that extends Cubit<HomeState>
class HomeCubit extends Cubit<HomeState> {
  // Define use cases
  GetDashInfoUseCase dashInfoUseCase;
  GetInvitationVisitsUseCase getInvitationUseCase;
  CreateInvitationUseCase createInvitationUseCase;
  CancelInvitationUseCase cancelInvitationUseCase;
  GetInvitationByIdUseCase getInvitationByIdUseCase;

  // Constructor for the HomeCubit class
  HomeCubit({
    required this.dashInfoUseCase,
    required this.getInvitationUseCase,
    required this.createInvitationUseCase,
    required this.cancelInvitationUseCase,
    required this.getInvitationByIdUseCase,
  }) : super(HomeInitial());

  // Static method to get an instance of HomeCubit using the context
  static HomeCubit get(context) => BlocProvider.of(context);

  // Variable to store the current navigation index
  int currentNavIndex = 0;

  // Method to change the navigation bar
  void changeNavBar({required int index}) {
    // Update the index and emit the state change
    tabController?.index = index;
    emit(ChangeNavBarState());
  }

  // PersistentTabController for managing the bottom navigation bar
  PersistentTabController? tabController;

  // List of screens to be displayed in the bottom navigation bar
  List<Widget> navScreens() {
    return [
      DashboardScreen(),
      CreateInvitationScreen(),
      InvitationsScreen(),
      UpdateUsersScreen(),
      MoreSettingScreen(),
    ];
  }

  // List of items for the bottom navigation bar
  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: (Config.Localization['Dashboard']),
        activeColorPrimary: AppColors.appColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: TextStyle(
          fontWeight: FontWeightManager.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.insert_invitation_rounded),
        title: (Config.Localization['Create']),
        textStyle: TextStyle(
          fontWeight: FontWeightManager.bold,
        ),
        activeColorPrimary: AppColors.appColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
        title: (Config.Localization['Invitations']),
        activeColorPrimary: AppColors.appColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: TextStyle(
          fontSize: AppSize.s20,
          fontWeight: FontWeightManager.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_crop_rectangle_fill),
        title: (Config.Localization['Users']),
        activeColorPrimary: AppColors.appColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: TextStyle(
          fontWeight: FontWeightManager.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: (Config.Localization['Settings']),
        activeColorPrimary: AppColors.appColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: TextStyle(
          fontSize: AppSize.s20,
          fontWeight: FontWeightManager.bold,
        ),
      ),
    ];
  }

  // Variable to store information data
  Info? info;

  // Method to get dashboard information
  Future<void> getDashInfo() async {
    emit(GetDashInfoLoadingState());

    info = await dashInfoUseCase.execute();
    if (info != null) {

      emit(GetDashInfoSuccessState());
    } else {
      emit(GetDashInfoErrorState("Error in getDashInfo"));
    }
  }

  // Lists to store different categories of invitations
  List<Visit> allInvitations = [];
  List<Visit> todayInvitations = [];
  List<Visit> upcomingInvitations = [];
  List<Visit> ExpiredInvitations = [];

  // Method to get all invitations
  Future<void> getInvitations() async {
    emit(GetInvitationLoadingState());

    allInvitations = await getInvitationUseCase.execute();
    if (allInvitations.isNotEmpty) {
      // Filter invitations based on different categories
      todayInvitations =
          allInvitations.where((visit) => visit.isToday()).toList();
      todayInvitations
          .sort((a, b) => a.registrationDate!.compareTo(b.registrationDate!));

      upcomingInvitations =
          allInvitations.where((visit) => visit.isUpcoming()).toList();
      upcomingInvitations
          .sort((a, b) => a.registrationDate!.compareTo(b.registrationDate!));

      ExpiredInvitations =
          allInvitations.where((visit) => visit.isExpired()).toList();

      ExpiredInvitations.sort((a, b) {
        if (a.expiryDate != null) {
          return a.expiryDate!.compareTo(b.expiryDate!);
        } else
          return 0;
      });

      emit(GetInvitationSuccessState());
    } else {
      emit(GetInvitationErrorState(
          "Error in GetInvitationInvitationsErrorState"));
    }
  }

  Future<void> getAllInv() async {
    emit(GetInvitationLoadingState());
    final res = await getInvitationUseCase.execute();
    emit(GetInvitationByIdSuccess());
  }

  Future<void> createBlackList({
    required String? name,
    required String ?documentIdno,
    required List<int> ?areaIds,
  }) async {
    emit(BlackListLoading());

    try {
      final formData = FormData.fromMap({
        'Name': name,
        'DocumentIdno': documentIdno,
        'AreaIds': areaIds,
      });

      final response = await DioHelper.postDataToBlackList(
        data: formData,
        url: '$BASE_URL$SaveApiUrl/api/v1/black-list/create',
        token: TokenSave!,
      );

      if (response.statusCode == 201) {
        emit(BlackListSuccess('Created Successfully'));
      } else {
        // Extract error message from response body if available
        String apiErrorMessage = '';
        if (response.data is Map<String, dynamic>) {
          final responseBody = response.data as Map<String, dynamic>;
          apiErrorMessage = responseBody['message'] ?? 'Unknown error occurred';
        }

        emit(BlackListError(
          'Failed to create. Status code: ${response.statusCode}',
          apiErrorMessage: apiErrorMessage,
        ));
      }
    } catch (e) {
      emit(BlackListError('Error occurred: $e'));
    }
  }

  ApiResponseToCreateInv ?response;
  // Method to load data for the dashboard
  Future<void> loadDashData() async {
    Future.wait([getDashInfo(), getInvitations()]);
  }

  Future<void> createInvitation({
    XFile? file,
    required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String nationalId,
    required DateTime registerDate,
    required DateTime expiredDate,
    required String AreaId,
    required String token,
    required int DocTypeId,
  }) async {
    emit(CreateInvitationLoadingState());

    try {
      final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", 'en_US');

      final Map<String, dynamic> formDataMap = {
        "fullName": name,
        "email": email,
        "phone": phone,
        "documentId": nationalId,
        "registrationDate": dateFormat.format(registerDate.toUtc()),
        "expiryDate": dateFormat.format(expiredDate.toUtc()),
        "AreaId": AreaId,
        'DeviceIp': '147',
        'InvitDocType': DocTypeId,
      };

      // Add file to formDataMap if it's not null
      if (file != null) {
        formDataMap["Image"] = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
      }

      // Create FormData
      final formData = FormData.fromMap(formDataMap);


      final response = await DioHelper.createToInvitations(
        url: '$BASE_URL$SaveApiUrl$postCreateInvitationsEndPoint',
        param: formData,
        token: token,
      );

      if (response.data!.qrLink.isNotEmpty) {
        showQrDialog(
          context: context,
          qrImage: response.data!.qrLink,
          buttonName: 'Share Image',
          isCreateInvitation: true,
          onPressed: () async {
            logger.w("qrImg ${response.data?.qrLink}");
            final cubit = HomeCubit.get(context);
            await cubit.shareImage(response.data!.qrLink);
          },
        );

        emit(CreateInvitationSuccessState(qrImage: response.data!.qrLink, Message: response.message));
      } else if(response.statusCode==401){
        Fluttertoast.showToast(

            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);

      }else {
        final errorResponse = ApiResponseToCreateInv.fromJson(response.data as Map<String, dynamic>);
        emit(CreateInvitationErrorState(response.message.isEmpty ? 'The User in blackList' : response.message, errorResponse));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if(e.response!.statusCode==401){
          Fluttertoast.showToast(

              msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
          AuthCubit.get(context).signOut(context: context);
        }else
        if (e.response!.statusCode == 400) {
          // Handle validation errors
          final validationErrors = e.response!.data['errors'] as Map<String, dynamic>;
          final errorMessages = validationErrors.entries
              .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
              .join('\n');
          emit(CreateInvitationErrorState(errorMessages.isEmpty  ? 'You cannot send invitations as you are in the blacklist.' : errorMessages, ApiResponseToCreateInv(
            statusCode: 0,
            succeeded: false,
            message: 'You cannot send invitations as you are in the blacklist.',
            data: Data(qrLink: ''),
            meta: null,
            errors: null,
          )));
        } else {
          // Handle other errors
          final errorResponse = ApiResponseToCreateInv.fromJson(e.response!.data as Map<String, dynamic>);
          emit(CreateInvitationErrorState(e.response!.statusMessage!.isEmpty ? 'You cannot send invitations as you are in the blacklist.' : '${errorResponse.message}', errorResponse));
        }
      } else {
        emit(CreateInvitationErrorState('${e.message}', ApiResponseToCreateInv(
          statusCode: 0,
          succeeded: false,
          message: 'Unexpected error occurred',
          data: Data(qrLink: ''),
          meta: null,
          errors: null,
        )));
      }
    } catch (e) {
      emit(CreateInvitationErrorState('Unexpected error: $e', ApiResponseToCreateInv(
        statusCode: 0,
        succeeded: false,
        message: 'Unexpected error occurred',
        data: Data(qrLink: ''),
        meta: null,
        errors: null,
      )));
    }
  }






// Function to handle image sharing (You need to implement this)

  // Method to cancel an invitation
  Future<void> cancelInvitation({
    required String canceledId,
  }) async {
    emit(CancelInvitationLoadingState());

    final res = await cancelInvitationUseCase.execute(
      canceledId: canceledId,
    );
    if (res.isNotEmpty) {
      logger.t("ress ${res}");
      loadDashData();
      emit(CancelInvitationSuccess());
    } else {
      emit(CancelInvitationError("Error in getDashInfo,the "));
    }
  }

  // Method to clear fields after creating an invitation
  void clearCreateInvitationsFields(
      TextEditingController? nameController,
      TextEditingController? emailController,
      TextEditingController? phoneController,
      TextEditingController? nationalIdController,
      List<DateTime>? dateTimeList,
      bool pressed) {
    nameController?.clear();
    emailController?.clear();
    nationalIdController?.clear();
    pressed = false;
    phoneController?.clear();
    dateTimeList = [
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
    ];

    emit(clearCreateInvitationsFieldsState());
  }

  // Method to share an invitation image
  Future<bool> shareImage(
    String imageUrl,
  ) async {
    try {
      emit(ShareInvitationQrLoadingState());
      final url = Uri.parse(imageUrl);
      final res = await http.get(url);
      final bytes = res.bodyBytes;
      Uint8List pngBytes = bytes.buffer.asUint8List();
      final directoryPath = (await getTemporaryDirectory()).path;
      final imagePath = '$directoryPath/Qr_invition.png';
      final imageFile = await File(imagePath).create(recursive: true);
      imageFile.writeAsBytesSync(pngBytes);

      final file = XFile(imagePath);
      await Share.shareXFiles([file]);

      emit(ShareInvitationQrSuccessState(isSuccess: true));
      return true;
    } catch (ex) {
      log("${ex}");
      emit(ShareInvitationQrErrorState(ex.toString()));
      return false;
    }
  }

  // Method to get invitation details by ID
  Future<void> getInvitationById({
    required BuildContext context,
    required String invitationId,
  }) async {
    emit(GetInvitationByIdLoadingState());
    final res =
        await getInvitationByIdUseCase.execute(invitationId: invitationId);
    if (res.qrLink != null) {
      emit(GetInvitationByIdSuccess());
    } else {
      emit(GetInvitationByIdError("Error In getInvitationById"));
    }
  }
}
