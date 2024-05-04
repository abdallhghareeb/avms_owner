import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/presentation/screens/more_setting/about/about_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/account/account_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/apearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MoreSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(mainPadding),
        children: <Widget>[
          ListTile(
            title: Text('Account'),
            subtitle: Text('Manage your account settings'),
            leading: Icon(
              Icons.account_circle,
            ),
            onTap: () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AccountScreen.route),
                screen: AccountScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          ListTile(
            title: Text('Appearance'),
            subtitle: Text('Customize the app appearance'),
            leading: Icon(
              Icons.palette,
            ),
            onTap: () {
              // Navigate to appearance settings screen
              // You can implement the navigation logic here
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppearanceScreen.route),
                screen: AppearanceScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          ListTile(
            title: Text('About'),
            subtitle: Text('Learn more about the app'),
            leading: Icon(Icons.info),
            onTap: () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AboutScreen.route),
                screen: AboutScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
        ],
      ),
    );
  }
}
