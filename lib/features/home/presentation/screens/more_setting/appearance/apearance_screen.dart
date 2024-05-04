import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:flutter/material.dart';

class AppearanceScreen extends StatefulWidget {
  static const route = 'appearanceRoute';

  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text(
          "Appearance",
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(mainPadding),
        children: <Widget>[

          ListTile(
            title: Text('Change To ${Localization.currentLanguage(context)}'),
            subtitle: Text('Learn more about the app'),
            leading: Icon(Icons.change_circle),
            onTap: () {
              // Navigate to about screen
              // You can implement the navigation logic here

            },
          ),

        ],
      ),
    );
  }
}
