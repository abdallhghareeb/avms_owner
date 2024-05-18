import 'package:avms/core/bloc/internet_cubit/internet_cubit.dart';
import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Execute loadDashData after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await HomeCubit.get(context).loadDashData();
    });

    // Initialize tabController for the PersistentTabView
    HomeCubit.get(context).tabController = PersistentTabController(
        initialIndex: HomeCubit.get(context).currentNavIndex);
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit cubit = HomeCubit.get(context);

    return BlocBuilder<LangCubit,LangState>(builder: (context,state){
      return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // Listener for HomeCubit state changes
          // Add any necessary logic based on state changes here
        },
        builder: (context, state) {
          return PersistentTabView(
            context,
            controller: cubit.tabController,
            screens: cubit.navScreens(),
            items: cubit.navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.white,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            bottomScreenMargin: 35,
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
              boxShadow: shadow,
              borderRadius: BorderRadius.circular(borderRadius),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style1,
          );
        },
      );
    });
  }
}
