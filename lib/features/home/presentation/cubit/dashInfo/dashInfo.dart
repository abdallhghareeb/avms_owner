import 'package:avms/features/home/data/models/dashInfo_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(context) => BlocProvider.of(context);

  Dio dio = Dio();
  DashboardTabsInfo? info;

  HomeCubit() : super(HomeInitial());

  Future<void> loadDashData() async {
    emit(GetDashInfoLoadingState());
    try {
      final response = await dio.get('http://egydns.ddns.net:8624/api/v1/dashboard/TabsInfo');
      if (response.statusCode == 200) {
        info = DashboardTabsInfo.fromJson(response.data);
        emit(GetDashInfoSuccessState());
      } else {
        emit(GetDashInfoErrorState('Failed to load data'));
      }
    } catch (e) {
      emit(GetDashInfoErrorState(e.toString()));
    }
  }
}

// Define states for HomeCubit
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetDashInfoLoadingState extends HomeState {}

class GetDashInfoSuccessState extends HomeState {}

class GetDashInfoErrorState extends HomeState {
  final String error;

  GetDashInfoErrorState(this.error);
}
