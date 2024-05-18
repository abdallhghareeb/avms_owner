import 'dart:convert';

import 'package:flutter/services.dart';

abstract class Config{
 static  Map Localization={};
 static  String language='English';

  static loadLanguage(String lang)async{
    String Translation;
    if(lang=='ar'){
      Translation= await rootBundle.loadString('assets/translation/ar.json');
    }else{
      Translation= await rootBundle.loadString('assets/translation/en.json');
    }
Localization= jsonDecode(Translation);
  }
  static textChange(String lang){
    if (lang=='English') {
      language='English';
    }  else{
      language='Arabic';
    }

  }

}