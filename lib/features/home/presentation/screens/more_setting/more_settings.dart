import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/about/about_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/account/account_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/privacy_policy_tile.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/apearance_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:avms/features/home/presentation/screens/more_setting/profile/profile_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/update_profile/users_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MoreSettingScreen extends StatefulWidget {
  static const route = 'SettingsRoute';
  @override
  State<MoreSettingScreen> createState() => _MoreSettingScreenState();
}

class _MoreSettingScreenState extends State<MoreSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit,LangState>(builder: (context,state){
      return Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: EdgeInsets.all(mainPadding),
          children: <Widget>[
            const PrivacyPolicyTile(),
            const SizedBox(height: 10),
            ListTile(
              title: Text(Config.Localization["account"]),
              subtitle: Text(Config.Localization['Manage your account settings']),
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
            SizedBox(
            height: 10,
            ),

            ListTile(
              title: Text(Config.Localization['Appearance']),
              subtitle: Text(Config.Localization['Customize the app appearance']),
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
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(Config.Localization['Profile']),
              subtitle: Text(Config.Localization['GetToKnowYourData']),
              leading: Icon(
                Icons.person,
              ),
              onTap: () {
                // Navigate to appearance settings screen
                // You can implement the navigation logic here
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: UserScreen.route),
                  screen: UserScreen(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),

           BlocBuilder<HomeCubit,HomeState>(builder: (context,state){
             return  ListTile(
               title: Text(Config.Localization['about']),
               subtitle: Text(Config.Localization['Learn more about the app']),
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
             );
           })
          ],
        ),
      );
    });
  }
}
