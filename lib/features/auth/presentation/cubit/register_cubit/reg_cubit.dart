import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/presentation/cubit/register_cubit/reg_state.dart';
import 'package:avms/services/api_service/api_server.dart';
import 'package:avms/services/local/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class RegCubit extends Cubit<RegState> {
  final Logger _logger = Logger();

  RegCubit(this._apiServer) : super(RegInitial());

  static RegCubit get(context) => BlocProvider.of(context);

  final ApiServer ?_apiServer;

  Future createAccount(
    String Name,
    String Phone,
    String uni,
    String Email,
    String areaId,
  ) async {
    emit(RegLoading(true));
    final Map<String, dynamic> data = {
      "Username": Name,
      "Email": Email,
      "PhoneNumber": Phone,
      "AreaIds": areaId,
      "UniqCode": uni
    };
    await _apiServer?.SignUp(data).then((value) {
      emit(RegLoading(false));
      print('successfully');
    }).onError((error, stackTrace) {
      emit(RegLoading(false));
    });
  }
}
