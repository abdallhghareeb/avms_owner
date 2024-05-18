import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceScreen extends StatefulWidget {
  static const route = 'appearanceRoute';

  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<LangCubit,LangState>(builder: (context,state){
      return Scaffold(

        appBar: AppBar(
          title: Text(
            Config.Localization['Appearance'],
          ),
        ),

        body: ListView(
          padding: EdgeInsets.all(mainPadding),
          children: <Widget>[

            ListTile(
              title: Text('Change To ${Config.language}'),
              subtitle: Text(Config.Localization["Learn more about the app"]),
              leading: Icon(Icons.change_circle),
              onTap: () {
               LangCubit.get(context).changeLang();
              },
            ),

          ],
        ),
      );
    });
  }
}
