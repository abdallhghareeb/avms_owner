part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class ChangeNavBarState extends HomeState {}

class GetDashInfoLoadingState extends HomeState {}

class GetDashInfoSuccessState extends HomeState {}

class GetDashInfoErrorState extends HomeState {
  final String error;

  GetDashInfoErrorState(this.error);
}

class GetInvitationLoadingState extends HomeState {}

class GetInvitationSuccessState extends HomeState {}

class GetInvitationErrorState extends HomeState {
  final String error;

  GetInvitationErrorState(this.error);
}

class CreateInvitationLoadingState extends HomeState {}

class CreateInvitationSuccessState extends HomeState {
  final String qrImage;

  CreateInvitationSuccessState({required this.qrImage});
}

class CreateInvitationErrorState extends HomeState {
  final String error;

  CreateInvitationErrorState(this.error);
}

class ShareInvitationQrLoadingState extends HomeState {}

class ShareInvitationQrSuccessState extends HomeState {
  final bool isSuccess;

  ShareInvitationQrSuccessState({required this.isSuccess});
}

class ShareInvitationQrErrorState extends HomeState {
  final String error;

  ShareInvitationQrErrorState(this.error);
}

class clearCreateInvitationsFieldsState extends HomeState {}

class CancelInvitationLoadingState extends HomeState {}

class CancelInvitationSuccess extends HomeState {}

class CancelInvitationError extends HomeState {
  final String error;

  CancelInvitationError(this.error);
}

class GetInvitationByIdLoadingState extends HomeState {}

class GetInvitationByIdSuccess extends HomeState {}

class GetInvitationByIdError extends HomeState {
  final String error;

  GetInvitationByIdError(this.error);
}
