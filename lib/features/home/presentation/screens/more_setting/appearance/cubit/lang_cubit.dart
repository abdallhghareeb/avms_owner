 import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangCubit extends Cubit<LangState>{
  LangCubit ():super(LangIntial());

  static LangCubit get(context)=>BlocProvider.of(context);
  void changeLang()async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String lang=preferences.getString('lang')??'en';
String textLang=preferences.getString('text')??'English';
    if(lang=='ar'){
      preferences.setString('lang', 'en');
      Config.loadLanguage('en');
      preferences.setString('text', 'Arabic');
      Config.textChange('Arabic');
    }else{
      preferences.setString('lang', 'ar');
      Config.loadLanguage('ar');
      preferences.setString('text', 'English');
      Config.textChange('English');



    }
emit(LangAdded());
  }

}