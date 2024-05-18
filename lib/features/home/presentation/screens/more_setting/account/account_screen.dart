import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/screens/enter_your_baseUrl.dart';
import 'package:avms/features/home/presentation/screens/more_setting/about/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountScreen extends StatefulWidget {
  static const route = 'AccountRoute';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var url= ConfigScreen.saveUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Config.Localization['account']
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(mainPadding),
        children: <Widget>[
          ListTile(
            title: Text(Config.Localization['sign out']),
            subtitle: Text(Config.Localization["Leave The Application"]),
            leading: Icon(Icons.login),
            onTap: () {
              AuthCubit.get(context).signOut(context: context);
            },
          ),
          AppSpaces.vSpace20,
          Padding(
            padding:  EdgeInsets.only(left: 25.w),
            child: Row(
              children: [
                Text('Api Url:',style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),),
                AppSpaces.hSpace16,
                Text(url!,style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
