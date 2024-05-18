import 'package:avms/features/auth/data/models/reg_model.dart';

abstract class RegState {}

class RegInitial extends RegState {}



class RegLoading extends RegState {
  bool loading;

  RegLoading(this.loading);
}

class RegAuthenticatedSignUp extends RegState {

}

class RegError extends RegState {

}