import 'dart:io';
import 'dart:developer';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/domain/use_cases/cancel_invitation_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_invitstion_by_id_use_case.dart';
import 'package:avms/widgets/alert_dialog.dart';
import 'package:dialog_loader/dialog_loader.dart';
import 'package:flutter/foundation.dart';
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
      log("infooo ${info}");
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

  // Method to load data for the dashboard
  Future<void> loadDashData() async {
    Future.wait([getDashInfo(), getInvitations()]);
  }

  // Method to create an invitation
  Future<void> createInvitation({
    required BuildContext context,
    required String name,
    required String phone,
    required String email,
    required String nationalId,
    required DateTime registerDate,
    required DateTime expiredDate,
  }) async {
    emit(CreateInvitationLoadingState());

    final res = await createInvitationUseCase.execute(
      fullName: name,
      phone: phone,
      email: email,
      nationalId: nationalId,
      registerDate: registerDate,
      expiredDate: expiredDate,
    );
    if (res.qrImage.isNotEmpty) {
      // Show a dialog with QR code image and a "Share Image" button
      showQrDialog(
          context: context,
          qrImage: res.qrImage,
          buttonName: 'Share Image',
          isCreateInvitation: true,
          onPressed: () async {
            logger.w("qrImg ${res.qrImage}");
            HomeCubit cubit = HomeCubit.get(context);
            await cubit.shareImage(
              res.qrImage,
            );
          });

      log("QrImage ${res.qrImage}");
      emit(CreateInvitationSuccessState(qrImage: res.qrImage));
    } else {
      emit(CreateInvitationErrorState("Error in getDashInfo"));
    }
  }

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
      emit(CancelInvitationError("Error in getDashInfo"));
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
