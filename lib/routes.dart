import 'package:avms/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/expired_invitations/expired_invitations_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/today_invitations/today_invitations_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/upcoming_invitations/upcoming_invitation_screen.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/about/about_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/account/account_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/apearance_screen.dart';
import 'package:avms/features/splash/splash_screen.dart';

var routes = {
  SplashScreen.route: (_) => const SplashScreen(),
  LoginScreen.route: (_) => const LoginScreen(),
  HomeScreen.route: (_) => const HomeScreen(),
  ForgetPasswordScreen.route: (_) => const ForgetPasswordScreen(),
  ResetPasswordScreen.route: (_) => const ResetPasswordScreen(),
  TodayInvitationsScreen.route: (_) => const TodayInvitationsScreen(),
  UpComingInvitationsScreen.route: (_) => const UpComingInvitationsScreen(),
  ExpiredInvitationsScreen.route: (_) => const ExpiredInvitationsScreen(),
  AccountScreen.route: (_) => const AccountScreen(),
  AppearanceScreen.route: (_) => const AppearanceScreen(),
  AboutScreen.route: (_) => const AboutScreen(),
};
