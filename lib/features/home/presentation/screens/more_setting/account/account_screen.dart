import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/about/about_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const route = 'AccountRoute';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account"
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(mainPadding),
        children: <Widget>[
          ListTile(
            title: Text('Sign Out'),
            subtitle: Text('Leave The Application'),
            leading: Icon(Icons.login),
            onTap: () {
              AuthCubit.get(context).signOut(context: context);
            },
          ),
        ],
      ),
    );
  }
}
